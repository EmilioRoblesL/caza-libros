const pool = require("../config/db");

const obtenerAlumnos = async (req, res) => {
  try {
    const resultado = await pool.query(
      `SELECT id, nombre, apellido, correo, rol
       FROM usuarios
       WHERE rol = 'alumno'
       ORDER BY nombre ASC, apellido ASC`
    );

    res.status(200).json(resultado.rows);
  } catch (error) {
    console.error("Error al obtener alumnos:", error);
    res.status(500).json({ message: "Error al obtener alumnos" });
  }
};

const obtenerResultadosGenerales = async (req, res) => {
  try {
    const resultado = await pool.query(
      `SELECT 
          u.nombre,
          u.apellido,
          l.titulo,
          i.puntaje,
          i.aprobado,
          i.creado_en
       FROM intentos i
       INNER JOIN usuarios u ON i.alumno_id = u.id
       INNER JOIN lecturas l ON i.lectura_id = l.id
       ORDER BY i.creado_en DESC`
    );

    res.status(200).json(resultado.rows);
  } catch (error) {
    console.error("Error al obtener resultados generales:", error);
    res.status(500).json({ message: "Error al obtener resultados generales" });
  }
};

const obtenerPanelDocente = async (req, res) => {
  try {
    const docenteId = Number(req.params.docenteId || req.query.docenteId);

    if (!docenteId) {
      return res.status(400).json({ message: "Falta el ID del docente" });
    }

    const cursoRes = await pool.query(
      `SELECT id, nombre, nivel, anio, docente_id
       FROM cursos
       WHERE docente_id = $1
       LIMIT 1`,
      [docenteId]
    );

    if (cursoRes.rows.length === 0) {
      return res.status(404).json({ message: "Este docente no tiene curso asignado" });
    }

    const curso = cursoRes.rows[0];

    const alumnosRes = await pool.query(
      `SELECT 
          u.id,
          u.nombre,
          u.apellido,
          u.correo
       FROM matriculas m
       INNER JOIN usuarios u ON m.alumno_id = u.id
       WHERE m.curso_id = $1
       ORDER BY u.nombre ASC, u.apellido ASC`,
      [curso.id]
    );

    const alumnos = alumnosRes.rows;

    const pendientesRes = await pool.query(
  `SELECT 
      id,
      nombre,
      apellido,
      correo,
      estado,
      creado_en
   FROM alumnos_pendientes
   WHERE curso_id = $1
     AND estado = 'pendiente'
   ORDER BY nombre ASC, apellido ASC`,
  [curso.id]
);

    const progresoRes = await pool.query(
      `SELECT 
          p.alumno_id,
          MAX(p.porcentaje_avance) AS porcentaje_avance
       FROM progreso_lectura p
       GROUP BY p.alumno_id`
    );

    const mapaProgreso = {};
    progresoRes.rows.forEach((fila) => {
      mapaProgreso[fila.alumno_id] = Number(fila.porcentaje_avance) || 0;
    });

    const resultadosRes = await pool.query(
      `SELECT 
          u.id AS alumno_id,
          u.nombre,
          u.apellido,
          l.titulo,
          i.puntaje,
          i.aprobado,
          i.creado_en
       FROM intentos i
       INNER JOIN usuarios u ON i.alumno_id = u.id
       INNER JOIN lecturas l ON i.lectura_id = l.id
       INNER JOIN matriculas m ON m.alumno_id = u.id
       WHERE m.curso_id = $1
       ORDER BY i.creado_en DESC`,
      [curso.id]
    );

    const listaAlumnos = alumnos.map((alumno, index) => {
      const progreso = mapaProgreso[alumno.id] || 0;

      return {
        numero: index + 1,
        id: alumno.id,
        nombre: alumno.nombre,
        apellido: alumno.apellido,
        nombre_completo: `${alumno.nombre} ${alumno.apellido}`,
        correo: alumno.correo,
        porcentaje_avance: progreso,
        estado_lectura:
          progreso >= 100 ? "Completado" :
          progreso > 0 ? "En progreso" :
          "Sin iniciar"
      };
    });

    res.status(200).json({
      curso: {
        id: curso.id,
        nombre: curso.nombre,
        nivel: curso.nivel,
        anio: curso.anio,
        docente_id: curso.docente_id
      },
      total_registrados: listaAlumnos.length,
      total_pendientes: pendientesRes.rows.length,
      total_esperado: 32,
      alumnos: listaAlumnos,
      alumnos_pendientes: pendientesRes.rows,
      resultados: resultadosRes.rows
    });
  } catch (error) {
    console.error("Error al obtener panel del docente:", error);
    res.status(500).json({ message: "Error al obtener panel del docente" });
  }
};

const registrarAlumnoPendienteEnCursoDocente = async (req, res) => {
  const { docenteId } = req.params;
  const { nombre, apellido, correo } = req.body;

  try {
    if (!nombre || !apellido || !correo) {
      return res.status(400).json({
        message: "Debes completar nombre, apellido y correo"
      });
    }

    const cursoRes = await pool.query(
      `SELECT id, nombre
       FROM cursos
       WHERE docente_id = $1
       LIMIT 1`,
      [docenteId]
    );

    if (cursoRes.rows.length === 0) {
      return res.status(404).json({
        message: "El docente no tiene curso asignado"
      });
    }

    const curso = cursoRes.rows[0];

    const existeUsuario = await pool.query(
  `SELECT id FROM usuarios WHERE LOWER(correo) = LOWER($1)`,
  [correo]
);

    if (existeUsuario.rows.length > 0) {
      return res.status(400).json({
        message: "Ya existe un usuario registrado con ese correo"
      });
    }

  const existePendiente = await pool.query(
  `SELECT id FROM alumnos_pendientes WHERE LOWER(correo) = LOWER($1)`,
  [correo]
);
    if (existePendiente.rows.length > 0) {
      return res.status(400).json({
        message: "Ese alumno ya fue agregado como pendiente"
      });
    }

    const nuevoPendiente = await pool.query(
      `INSERT INTO alumnos_pendientes (curso_id, nombre, apellido, correo, estado)
       VALUES ($1, $2, $3, $4, 'pendiente')
       RETURNING id, curso_id, nombre, apellido, correo, estado, creado_en`,
      [curso.id, nombre, apellido, correo]
    );

    await pool.query(
      `INSERT INTO eventos_log (usuario_id, tipo_evento, detalle)
       VALUES ($1, $2, $3)`,
      [
        docenteId,
        "registro_alumno_pendiente",
        `Docente agregó alumno pendiente ${nombre} ${apellido} al curso ${curso.nombre}`
      ]
    );

    res.status(201).json({
      message: "Alumno pendiente agregado correctamente",
      alumno_pendiente: nuevoPendiente.rows[0],
      curso: curso.nombre
    });
  } catch (error) {
    console.error("Error al registrar alumno pendiente:", error);
    res.status(500).json({ message: "Error al registrar alumno pendiente" });
  }
};

const actualizarAlumnoCurso = async (req, res) => {
  const { docenteId, alumnoId } = req.params;
  const { nombre, apellido, correo } = req.body;

  try {
    if (!nombre || !apellido || !correo) {
      return res.status(400).json({ message: "Completa todos los campos" });
    }

    const cursoRes = await pool.query(
      `SELECT id FROM cursos WHERE docente_id = $1 LIMIT 1`,
      [docenteId]
    );

    if (cursoRes.rows.length === 0) {
      return res.status(404).json({ message: "El docente no tiene curso asignado" });
    }

    const matriculaRes = await pool.query(
      `SELECT id FROM matriculas WHERE curso_id = $1 AND alumno_id = $2`,
      [cursoRes.rows[0].id, alumnoId]
    );

    if (matriculaRes.rows.length === 0) {
      return res.status(403).json({ message: "El alumno no pertenece al curso del docente" });
    }

    const actualizado = await pool.query(
      `UPDATE usuarios
       SET nombre = $1, apellido = $2, correo = $3
       WHERE id = $4 AND rol = 'alumno'
       RETURNING id, nombre, apellido, correo`,
      [nombre.trim(), apellido.trim(), correo.trim(), alumnoId]
    );

    res.json({
      message: "Alumno actualizado correctamente",
      alumno: actualizado.rows[0]
    });
  } catch (error) {
    console.error("Error al actualizar alumno:", error);
    res.status(500).json({ message: "Error al actualizar alumno" });
  }
};

const eliminarAlumnoCurso = async (req, res) => {
  const { docenteId, alumnoId } = req.params;
  const client = await pool.connect();

  try {
    await client.query("BEGIN");

    const cursoRes = await client.query(
      `SELECT id FROM cursos WHERE docente_id = $1 LIMIT 1`,
      [docenteId]
    );

    if (cursoRes.rows.length === 0) {
      await client.query("ROLLBACK");
      return res.status(404).json({ message: "El docente no tiene curso asignado" });
    }

    const cursoId = cursoRes.rows[0].id;

    const matriculaRes = await client.query(
      `SELECT id FROM matriculas WHERE curso_id = $1 AND alumno_id = $2`,
      [cursoId, alumnoId]
    );

    if (matriculaRes.rows.length === 0) {
      await client.query("ROLLBACK");
      return res.status(404).json({ message: "El alumno no pertenece al curso" });
    }

    await client.query(
      `DELETE FROM matriculas WHERE curso_id = $1 AND alumno_id = $2`,
      [cursoId, alumnoId]
    );

    await client.query(
      `INSERT INTO eventos_log (usuario_id, tipo_evento, detalle)
       VALUES ($1, $2, $3)`,
      [docenteId, "eliminacion_alumno_curso", `Docente eliminó al alumno ${alumnoId} del curso ${cursoId}`]
    );

    await client.query("COMMIT");

    res.json({ message: "Alumno eliminado del curso correctamente" });
  } catch (error) {
    await client.query("ROLLBACK");
    console.error("Error al eliminar alumno:", error);
    res.status(500).json({ message: "Error al eliminar alumno" });
  } finally {
    client.release();
  }
};

const actualizarAlumnoPendiente = async (req, res) => {
  const { docenteId, pendienteId } = req.params;
  const { nombre, apellido, correo } = req.body;

  try {
    if (!nombre || !apellido || !correo) {
      return res.status(400).json({ message: "Completa todos los campos" });
    }

    const cursoRes = await pool.query(
      `SELECT id FROM cursos WHERE docente_id = $1 LIMIT 1`,
      [docenteId]
    );

    if (cursoRes.rows.length === 0) {
      return res.status(404).json({ message: "El docente no tiene curso asignado" });
    }

    const actualizado = await pool.query(
      `UPDATE alumnos_pendientes
       SET nombre = $1, apellido = $2, correo = $3
       WHERE id = $4 AND curso_id = $5
       RETURNING id, nombre, apellido, correo, estado, creado_en`,
      [nombre.trim(), apellido.trim(), correo.trim(), pendienteId, cursoRes.rows[0].id]
    );

    if (actualizado.rows.length === 0) {
      return res.status(404).json({ message: "Alumno pendiente no encontrado" });
    }

    res.json({
      message: "Alumno pendiente actualizado correctamente",
      alumno_pendiente: actualizado.rows[0]
    });
  } catch (error) {
    console.error("Error al actualizar pendiente:", error);
    res.status(500).json({ message: "Error al actualizar pendiente" });
  }
};

const eliminarAlumnoPendiente = async (req, res) => {
  const { docenteId, pendienteId } = req.params;

  try {
    const cursoRes = await pool.query(
      `SELECT id FROM cursos WHERE docente_id = $1 LIMIT 1`,
      [docenteId]
    );

    if (cursoRes.rows.length === 0) {
      return res.status(404).json({ message: "El docente no tiene curso asignado" });
    }

    const eliminado = await pool.query(
      `DELETE FROM alumnos_pendientes
       WHERE id = $1 AND curso_id = $2
       RETURNING id`,
      [pendienteId, cursoRes.rows[0].id]
    );

    if (eliminado.rows.length === 0) {
      return res.status(404).json({ message: "Alumno pendiente no encontrado" });
    }

    res.json({ message: "Alumno pendiente eliminado correctamente" });
  } catch (error) {
    console.error("Error al eliminar pendiente:", error);
    res.status(500).json({ message: "Error al eliminar pendiente" });
  }
};

module.exports = {
  obtenerAlumnos,
  obtenerResultadosGenerales,
  obtenerPanelDocente,
  registrarAlumnoPendienteEnCursoDocente,
  actualizarAlumnoCurso,
  eliminarAlumnoCurso,
  actualizarAlumnoPendiente,
  eliminarAlumnoPendiente
};