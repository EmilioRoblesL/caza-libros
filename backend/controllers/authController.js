const pool = require("../config/db");
const bcrypt = require("bcryptjs");

const sincronizarCursoDocente = async (docenteId, rol, curso, es_profesor_jefe) => {
  await pool.query(
    `UPDATE cursos
     SET docente_id = NULL
     WHERE docente_id = $1`,
    [docenteId]
  );

  if (rol !== "docente" || !curso || !es_profesor_jefe) {
    return;
  }

  const cursoExiste = await pool.query(
    `SELECT id FROM cursos WHERE nombre = $1 LIMIT 1`,
    [curso]
  );

  if (cursoExiste.rows.length > 0) {
    await pool.query(
      `UPDATE cursos
       SET docente_id = $1
       WHERE id = $2`,
      [docenteId, cursoExiste.rows[0].id]
    );
  } else {
    await pool.query(
      `INSERT INTO cursos (nombre, nivel, anio, docente_id)
       VALUES ($1, $2, $3, $4)`,
      [curso, "Básica", 2026, docenteId]
    );
  }
};

const register = async (req, res) => {
  const {
    nombre,
    apellido,
    correo,
    password,
    rol,
    asignatura,
    curso,
    es_profesor_jefe
  } = req.body;

  try {
    const rolesValidos = ["alumno", "docente"];

    if (!rolesValidos.includes(rol)) {
      return res.status(400).json({ message: "Rol no permitido" });
    }

    if (!nombre || !apellido || !correo || !password || !rol) {
      return res.status(400).json({ message: "Faltan datos obligatorios" });
    }

    const correoNormalizado = correo.trim().toLowerCase();

    const existe = await pool.query(
      `SELECT id FROM usuarios WHERE LOWER(correo) = LOWER($1)`,
      [correoNormalizado]
    );

    if (existe.rows.length > 0) {
      return res.status(400).json({ message: "El usuario ya existe" });
    }

    if (rol === "docente" && (!asignatura || !curso)) {
      return res.status(400).json({
        message: "Para docentes debes ingresar asignatura y curso"
      });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    let nuevoUsuario;

    if (rol === "docente") {
      nuevoUsuario = await pool.query(
        `INSERT INTO usuarios 
        (nombre, apellido, correo, password, rol, asignatura, curso, es_profesor_jefe)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
        RETURNING id, nombre, apellido, correo, rol, asignatura, curso, es_profesor_jefe`,
        [
          nombre.trim(),
          apellido.trim(),
          correoNormalizado,
          hashedPassword,
          rol,
          asignatura || null,
          curso || null,
          es_profesor_jefe || false
        ]
      );

      await sincronizarCursoDocente(
        nuevoUsuario.rows[0].id,
        rol,
        curso,
        es_profesor_jefe
      );
    } else {
      // REGISTRO DE ALUMNO
      nuevoUsuario = await pool.query(
        `INSERT INTO usuarios (nombre, apellido, correo, password, rol)
         VALUES ($1, $2, $3, $4, $5)
         RETURNING id, nombre, apellido, correo, rol`,
        [
          nombre.trim(),
          apellido.trim(),
          correoNormalizado,
          hashedPassword,
          rol
        ]
      );

      // BUSCAR SI EL ALUMNO ESTABA PENDIENTE POR CORREO
      const pendiente = await pool.query(
        `SELECT id, curso_id
         FROM alumnos_pendientes
         WHERE LOWER(correo) = LOWER($1)
         LIMIT 1`,
        [correoNormalizado]
      );

      if (pendiente.rows.length > 0) {
        const cursoId = pendiente.rows[0].curso_id;

        // EVITAR DUPLICAR MATRÍCULA
        const yaMatriculado = await pool.query(
          `SELECT id
           FROM matriculas
           WHERE alumno_id = $1 AND curso_id = $2`,
          [nuevoUsuario.rows[0].id, cursoId]
        );

        if (yaMatriculado.rows.length === 0) {
          await pool.query(
            `INSERT INTO matriculas (alumno_id, curso_id, fecha_matricula, estado)
             VALUES ($1, $2, CURRENT_DATE, 'activo')`,
            [nuevoUsuario.rows[0].id, cursoId]
          );
        }

        // ELIMINAR DE PENDIENTES PARA QUE NO SIGA APARECIENDO
        await pool.query(
          `DELETE FROM alumnos_pendientes
           WHERE id = $1`,
          [pendiente.rows[0].id]
        );
      }
    }

    await pool.query(
      `INSERT INTO eventos_log (usuario_id, tipo_evento, detalle)
       VALUES ($1, $2, $3)`,
      [
        nuevoUsuario.rows[0].id,
        "registro",
        `Nuevo usuario registrado: ${nuevoUsuario.rows[0].nombre} ${nuevoUsuario.rows[0].apellido}`
      ]
    );

    res.status(201).json({
      message: "Usuario registrado correctamente",
      usuario: nuevoUsuario.rows[0],
    });
  } catch (error) {
    console.error("Error en registro:", error);
    res.status(500).json({ message: "Error en el servidor" });
  }
};

const login = async (req, res) => {
  const { correo, password } = req.body;

  try {
    if (!correo || !password) {
      return res.status(400).json({ message: "Debes ingresar correo y contraseña" });
    }

    const correoNormalizado = correo.trim().toLowerCase();

    const result = await pool.query(
      `SELECT * FROM usuarios WHERE LOWER(correo) = LOWER($1)`,
      [correoNormalizado]
    );

    if (result.rows.length === 0) {
      await pool.query(
        `INSERT INTO eventos_log (tipo_evento, detalle)
         VALUES ($1, $2)`,
        [
          "error_login",
          `Intento fallido de login con correo: ${correoNormalizado}`
        ]
      );

      return res.status(400).json({ message: "Usuario no encontrado" });
    }

    const usuario = result.rows[0];

    const match = await bcrypt.compare(password, usuario.password);

    if (!match) {
      await pool.query(
        `INSERT INTO eventos_log (usuario_id, tipo_evento, detalle)
         VALUES ($1, $2, $3)`,
        [
          usuario.id,
          "error_password",
          `Error de contraseña para usuario ${correoNormalizado}`
        ]
      );

      return res.status(400).json({ message: "Contraseña incorrecta" });
    }

    res.status(200).json({
      message: "Login exitoso",
      usuario: {
        id: usuario.id,
        nombre: usuario.nombre,
        apellido: usuario.apellido,
        correo: usuario.correo,
        rol: usuario.rol,
        asignatura: usuario.asignatura || null,
        curso: usuario.curso || null,
        es_profesor_jefe: usuario.es_profesor_jefe || false
      },
    });
  } catch (error) {
    console.error("Error en login:", error);
    res.status(500).json({ message: "Error en el servidor" });
  }
};

module.exports = {
  register,
  login,
};