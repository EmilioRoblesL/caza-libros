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

const obtenerUsuarios = async (req, res) => {
  try {
    const resultado = await pool.query(
      `SELECT 
        id,
        nombre,
        apellido,
        correo,
        rol,
        asignatura,
        curso,
        es_profesor_jefe
       FROM usuarios
       ORDER BY id ASC`
    );

    res.status(200).json(resultado.rows);
  } catch (error) {
    console.error("Error al obtener usuarios:", error);
    res.status(500).json({ message: "Error al obtener usuarios" });
  }
};

const obtenerResumenSistema = async (req, res) => {
  try {
    const totalUsuarios = await pool.query(`SELECT COUNT(*) FROM usuarios`);
    const totalAlumnos = await pool.query(`SELECT COUNT(*) FROM usuarios WHERE rol = 'alumno'`);
    const nuevosRegistros = await pool.query(`
      SELECT COUNT(*)
      FROM usuarios
      WHERE DATE(creado_en) = CURRENT_DATE
    `);

    res.status(200).json({
      total_usuarios: Number(totalUsuarios.rows[0].count),
      total_alumnos: Number(totalAlumnos.rows[0].count),
      nuevos_registros: Number(nuevosRegistros.rows[0].count),
    });
  } catch (error) {
    console.error("Error al obtener resumen del sistema:", error);
    res.status(500).json({ message: "Error al obtener resumen del sistema" });
  }
};

const obtenerAlertasSistema = async (req, res) => {
  try {
    const resultado = await pool.query(
      `SELECT id, tipo_evento, detalle, fecha_hora
       FROM eventos_log
       ORDER BY fecha_hora DESC
       LIMIT 10`
    );

    res.status(200).json(resultado.rows);
  } catch (error) {
    console.error("Error al obtener alertas:", error);
    res.status(500).json({ message: "Error al obtener alertas" });
  }
};

const crearUsuarioAdmin = async (req, res) => {
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
    const rolesValidos = ["alumno", "docente", "admin"];

    if (!rolesValidos.includes(rol)) {
      return res.status(400).json({ message: "Rol no válido" });
    }

    if (!nombre || !apellido || !correo || !password || !rol) {
      return res.status(400).json({ message: "Faltan datos obligatorios" });
    }

    if (rol === "docente" && (!asignatura || !curso)) {
      return res.status(400).json({
        message: "Para docentes debes ingresar asignatura y curso"
      });
    }

    const existe = await pool.query(
      "SELECT id FROM usuarios WHERE correo = $1",
      [correo]
    );

    if (existe.rows.length > 0) {
      return res.status(400).json({ message: "El correo ya está registrado" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const nuevoUsuario = await pool.query(
      `INSERT INTO usuarios (
        nombre,
        apellido,
        correo,
        password,
        rol,
        asignatura,
        curso,
        es_profesor_jefe
      )
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
       RETURNING id, nombre, apellido, correo, rol, asignatura, curso, es_profesor_jefe`,
      [
        nombre,
        apellido,
        correo,
        hashedPassword,
        rol,
        rol === "docente" ? asignatura : null,
        rol === "docente" ? curso : null,
        rol === "docente" ? (es_profesor_jefe || false) : false
      ]
    );

    await sincronizarCursoDocente(
      nuevoUsuario.rows[0].id,
      rol,
      curso,
      es_profesor_jefe
    );

    await pool.query(
      `INSERT INTO eventos_log (usuario_id, tipo_evento, detalle)
       VALUES ($1, $2, $3)`,
      [
        nuevoUsuario.rows[0].id,
        "registro_admin",
        `Administrador creó usuario: ${nuevoUsuario.rows[0].nombre} ${nuevoUsuario.rows[0].apellido}`
      ]
    );

    res.status(201).json({
      message: "Usuario creado correctamente",
      usuario: nuevoUsuario.rows[0],
    });
  } catch (error) {
    console.error("Error al crear usuario:", error);
    res.status(500).json({ message: "Error al crear usuario" });
  }
};

const actualizarUsuarioAdmin = async (req, res) => {
  const { id } = req.params;
  const {
    nombre,
    apellido,
    correo,
    rol,
    asignatura,
    curso,
    es_profesor_jefe
  } = req.body;

  try {
    const rolesValidos = ["alumno", "docente", "admin"];

    if (!rolesValidos.includes(rol)) {
      return res.status(400).json({ message: "Rol no válido" });
    }

    if (!nombre || !apellido || !correo || !rol) {
      return res.status(400).json({ message: "Faltan datos obligatorios" });
    }

    if (rol === "docente" && (!asignatura || !curso)) {
      return res.status(400).json({
        message: "Para docentes debes ingresar asignatura y curso"
      });
    }

    const actualizado = await pool.query(
      `UPDATE usuarios
       SET 
         nombre = $1,
         apellido = $2,
         correo = $3,
         rol = $4,
         asignatura = $5,
         curso = $6,
         es_profesor_jefe = $7
       WHERE id = $8
       RETURNING id, nombre, apellido, correo, rol, asignatura, curso, es_profesor_jefe`,
      [
        nombre,
        apellido,
        correo,
        rol,
        rol === "docente" ? asignatura : null,
        rol === "docente" ? curso : null,
        rol === "docente" ? (es_profesor_jefe || false) : false,
        id
      ]
    );

    if (actualizado.rows.length === 0) {
      return res.status(404).json({ message: "Usuario no encontrado" });
    }

    await sincronizarCursoDocente(id, rol, curso, es_profesor_jefe);

    await pool.query(
      `INSERT INTO eventos_log (usuario_id, tipo_evento, detalle)
       VALUES ($1, $2, $3)`,
      [
        id,
        "actualizacion_usuario",
        `Administrador actualizó usuario: ${actualizado.rows[0].nombre} ${actualizado.rows[0].apellido}`
      ]
    );

    res.status(200).json({
      message: "Usuario actualizado correctamente",
      usuario: actualizado.rows[0],
    });
  } catch (error) {
    console.error("Error al actualizar usuario:", error);
    res.status(500).json({ message: "Error al actualizar usuario" });
  }
};

const eliminarUsuarioAdmin = async (req, res) => {
  const { id } = req.params;

  try {
    const usuario = await pool.query(
      `SELECT id, nombre, apellido, rol FROM usuarios WHERE id = $1`,
      [id]
    );

    if (usuario.rows.length === 0) {
      return res.status(404).json({ message: "Usuario no encontrado" });
    }

    await pool.query(
      `UPDATE cursos
       SET docente_id = NULL
       WHERE docente_id = $1`,
      [id]
    );

    await pool.query(`DELETE FROM usuarios WHERE id = $1`, [id]);

    await pool.query(
      `INSERT INTO eventos_log (tipo_evento, detalle)
       VALUES ($1, $2)`,
      [
        "eliminacion_usuario",
        `Administrador eliminó usuario: ${usuario.rows[0].nombre} ${usuario.rows[0].apellido}`
      ]
    );

    res.status(200).json({ message: "Usuario eliminado correctamente" });
  } catch (error) {
    console.error("Error al eliminar usuario:", error);
    res.status(500).json({ message: "Error al eliminar usuario" });
  }
};

const obtenerActividadSemanal = async (req, res) => {
  try {
    const resultado = await pool.query(`
      SELECT 
        TO_CHAR(dia, 'DD/MM') AS fecha,
        COUNT(e.id) AS total_eventos
      FROM generate_series(
        CURRENT_DATE - INTERVAL '6 days',
        CURRENT_DATE,
        '1 day'
      ) AS dia
      LEFT JOIN eventos_log e
        ON DATE(e.fecha_hora) = DATE(dia)
      GROUP BY dia
      ORDER BY dia ASC
    `);

    res.status(200).json(resultado.rows);
  } catch (error) {
    console.error("Error actividad semanal:", error);
    res.status(500).json({ message: "Error al obtener actividad semanal" });
  }
};

const obtenerAuditoriaSistema = async (req, res) => {
  try {
    const resultado = await pool.query(`
      SELECT
        e.id,
        e.tipo_evento,
        e.detalle,
        e.fecha_hora,
        u.nombre,
        u.apellido,
        u.correo
      FROM eventos_log e
      LEFT JOIN usuarios u ON e.usuario_id = u.id
      ORDER BY e.fecha_hora DESC
    `);

    res.status(200).json(resultado.rows);
  } catch (error) {
    console.error("Error al obtener auditoría:", error);
    res.status(500).json({ message: "Error al obtener auditoría" });
  }
};

const obtenerReportesSistema = async (req, res) => {
  try {
    const totalUsuarios = await pool.query(`SELECT COUNT(*) FROM usuarios`);
    const totalCuestionarios = await pool.query(`SELECT COUNT(*) FROM intentos`);
    const rendimientoGeneral = await pool.query(`
      SELECT COALESCE(AVG(puntaje), 0) AS promedio
      FROM intentos
    `);
    const lecturasCompletadas = await pool.query(`
      SELECT COUNT(*) 
      FROM intentos
      WHERE aprobado = true
    `);

    res.status(200).json({
      total_usuarios: Number(totalUsuarios.rows[0].count),
      total_cuestionarios: Number(totalCuestionarios.rows[0].count),
      rendimiento_general: Number(rendimientoGeneral.rows[0].promedio),
      total_lecturas_completadas: Number(lecturasCompletadas.rows[0].count),
    });
  } catch (error) {
    console.error("Error al obtener reportes:", error);
    res.status(500).json({ message: "Error al obtener reportes" });
  }
};

const exportarAuditoriaCSV = async (req, res) => {
  try {
    const resultado = await pool.query(`
      SELECT
        e.id,
        e.tipo_evento,
        e.detalle,
        e.fecha_hora,
        COALESCE(u.nombre || ' ' || u.apellido, 'Sistema') AS usuario
      FROM eventos_log e
      LEFT JOIN usuarios u ON e.usuario_id = u.id
      ORDER BY e.fecha_hora DESC
    `);

    const filas = resultado.rows;
    let csv = "Usuario,Accion,Fecha,Hora,Descripcion\n";

    filas.forEach((fila) => {
      const fechaObj = fila.fecha_hora ? new Date(fila.fecha_hora) : null;
      const fecha = fechaObj ? fechaObj.toLocaleDateString("es-CL") : "";
      const hora = fechaObj
        ? fechaObj.toLocaleTimeString("es-CL", { hour: "2-digit", minute: "2-digit" })
        : "";

      const usuario = `"${(fila.usuario || "").replace(/"/g, '""')}"`;
      const accion = `"${(fila.tipo_evento || "").replace(/"/g, '""')}"`;
      const descripcion = `"${(fila.detalle || "").replace(/"/g, '""')}"`;

      csv += `${usuario},${accion},${fecha},${hora},${descripcion}\n`;
    });

    res.setHeader("Content-Type", "text/csv; charset=utf-8");
    res.setHeader("Content-Disposition", "attachment; filename=auditoria_cazalibros.csv");
    res.status(200).send(csv);
  } catch (error) {
    console.error("Error al exportar auditoría:", error);
    res.status(500).json({ message: "Error al exportar auditoría" });
  }
};

const respaldarSistema = async (req, res) => {
  try {
    const usuarios = await pool.query(`SELECT * FROM usuarios ORDER BY id ASC`);
    const lecturas = await pool.query(`SELECT * FROM lecturas ORDER BY id ASC`);
    const preguntas = await pool.query(`SELECT * FROM preguntas ORDER BY id ASC`);
    const opciones = await pool.query(`SELECT * FROM opciones ORDER BY id ASC`);
    const intentos = await pool.query(`SELECT * FROM intentos ORDER BY id ASC`);
    const eventos = await pool.query(`SELECT * FROM eventos_log ORDER BY id ASC`);

    const respaldo = {
      fecha_respaldo: new Date().toISOString(),
      usuarios: usuarios.rows,
      lecturas: lecturas.rows,
      preguntas: preguntas.rows,
      opciones: opciones.rows,
      intentos: intentos.rows,
      eventos_log: eventos.rows
    };

    res.setHeader("Content-Type", "application/json");
    res.setHeader("Content-Disposition", "attachment; filename=respaldo_cazalibros.json");
    res.status(200).send(JSON.stringify(respaldo, null, 2));
  } catch (error) {
    console.error("Error al generar respaldo:", error);
    res.status(500).json({ message: "Error al generar respaldo" });
  }
};

const verificarSeguridadSistema = async (req, res) => {
  try {
    const correosDuplicados = await pool.query(`
      SELECT correo, COUNT(*) 
      FROM usuarios
      GROUP BY correo
      HAVING COUNT(*) > 1
    `);

    const usuariosSinRol = await pool.query(`
      SELECT id, nombre, apellido, correo
      FROM usuarios
      WHERE rol IS NULL OR rol = ''
    `);

    const intentosHuerfanos = await pool.query(`
      SELECT i.id
      FROM intentos i
      LEFT JOIN usuarios u ON i.alumno_id = u.id
      WHERE u.id IS NULL
    `);

    const eventosHuerfanos = await pool.query(`
      SELECT e.id
      FROM eventos_log e
      LEFT JOIN usuarios u ON e.usuario_id = u.id
      WHERE e.usuario_id IS NOT NULL AND u.id IS NULL
    `);

    const problemas = {
      correos_duplicados: correosDuplicados.rows,
      usuarios_sin_rol: usuariosSinRol.rows,
      intentos_huerfanos: intentosHuerfanos.rows,
      eventos_huerfanos: eventosHuerfanos.rows
    };

    const totalProblemas =
      problemas.correos_duplicados.length +
      problemas.usuarios_sin_rol.length +
      problemas.intentos_huerfanos.length +
      problemas.eventos_huerfanos.length;

    res.status(200).json({
      estado: totalProblemas === 0 ? "Todo seguro" : "Se detectaron observaciones",
      total_problemas: totalProblemas,
      detalle: problemas
    });
  } catch (error) {
    console.error("Error en verificación de seguridad:", error);
    res.status(500).json({ message: "Error en verificación de seguridad" });
  }
};

module.exports = {
  obtenerUsuarios,
  obtenerResumenSistema,
  obtenerAlertasSistema,
  crearUsuarioAdmin,
  actualizarUsuarioAdmin,
  eliminarUsuarioAdmin,
  obtenerActividadSemanal,
  obtenerAuditoriaSistema,
  obtenerReportesSistema,
  exportarAuditoriaCSV,
  respaldarSistema,
  verificarSeguridadSistema
};