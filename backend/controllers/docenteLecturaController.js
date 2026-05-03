const pool = require("../config/db");

/* =========================
   OBTENER CURSOS DISPONIBLES
========================= */
const obtenerCursosDisponibles = async (req, res) => {
  try {
    const resultado = await pool.query(`
      SELECT 
        c.id,
        c.nombre,
        c.nivel,
        c.anio,
        u.nombre AS profesor_nombre,
        u.apellido AS profesor_apellido
      FROM cursos c
      LEFT JOIN usuarios u ON c.docente_id = u.id
      ORDER BY c.nombre ASC
    `);

    return res.status(200).json(resultado.rows);
  } catch (error) {
    console.error("Error al obtener cursos:", error);
    return res.status(500).json({ message: "Error al obtener cursos" });
  }
};

/* =========================
   CREAR LECTURA Y ASIGNARLA AL CURSO
========================= */
const crearLecturaYAsignarCurso = async (req, res) => {
  const { docenteId } = req.params;
  const { titulo, autor, nivel_dificultad, categoria, contenido, curso_id } = req.body;

  const client = await pool.connect();

  try {
    if (!titulo || !nivel_dificultad || !contenido || !curso_id) {
      return res.status(400).json({
        message: "Debes completar todos los campos obligatorios"
      });
    }

    await client.query("BEGIN");

    const cursoRes = await client.query(
      `SELECT id, nombre
       FROM cursos
       WHERE id = $1`,
      [curso_id]
    );

    if (cursoRes.rows.length === 0) {
      await client.query("ROLLBACK");
      return res.status(404).json({ message: "Curso no encontrado" });
    }

    const alumnosRes = await client.query(
      `SELECT u.id
       FROM matriculas m
       INNER JOIN usuarios u ON m.alumno_id = u.id
       WHERE m.curso_id = $1
       ORDER BY u.apellido ASC, u.nombre ASC`,
      [curso_id]
    );

    const nuevaLectura = await client.query(
      `INSERT INTO lecturas (titulo, autor, nivel_dificultad, categoria, contenido, creado_por)
      VALUES ($1, $2, $3, $4, $5, $6)
      RETURNING *`,
      [
        titulo.trim(),
        autor?.trim() || null,
        nivel_dificultad.trim(),
        categoria?.trim() || null,
        contenido.trim(),
        Number(docenteId)
      ]
    );

    const lecturaId = nuevaLectura.rows[0].id;

    for (const alumno of alumnosRes.rows) {
      await client.query(
        `INSERT INTO asignaciones_lectura (lectura_id, alumno_id, curso_id, estado)
         VALUES ($1, $2, $3, 'asignada')
         ON CONFLICT (lectura_id, alumno_id, curso_id) DO NOTHING`,
        [lecturaId, alumno.id, curso_id]
      );
    }

    await client.query(
      `INSERT INTO eventos_log (usuario_id, tipo_evento, detalle)
       VALUES ($1, $2, $3)`,
      [
        Number(docenteId),
        "creacion_lectura_curso",
        `Docente creó la lectura "${titulo}" y la asignó al curso ${cursoRes.rows[0].nombre}`
      ]
    );

    await client.query("COMMIT");

    return res.status(201).json({
      message: "Lectura creada y asignada al curso correctamente",
      lectura: nuevaLectura.rows[0],
      total_asignados: alumnosRes.rows.length
    });
  } catch (error) {
    await client.query("ROLLBACK");
    console.error("Error al crear lectura y asignar curso:", error);
    return res.status(500).json({ message: "Error al crear la lectura" });
  } finally {
    client.release();
  }
};

/* =========================
   LISTAR LECTURAS DEL DOCENTE
========================= */
const obtenerLecturasDocente = async (req, res) => {
  const { docenteId } = req.params;

  try {
   const resultado = await pool.query(
      `
      SELECT 
        l.id,
        l.titulo,
        l.autor,
        l.nivel_dificultad,
        l.categoria,
        l.contenido,
        l.creado_por,
        MIN(al.curso_id) AS curso_id,
        c.nombre AS curso_nombre,
        c.nivel AS curso_nivel,
        c.anio AS curso_anio,
        COUNT(al.id)::int AS total_asignaciones
      FROM lecturas l
      LEFT JOIN asignaciones_lectura al ON l.id = al.lectura_id
      LEFT JOIN cursos c ON c.id = al.curso_id
      WHERE l.creado_por = $1
      GROUP BY 
        l.id,
        l.titulo,
        l.autor,
        l.nivel_dificultad,
        l.categoria,
        l.contenido,
        l.creado_por,
        c.nombre,
        c.nivel,
        c.anio
      ORDER BY l.id DESC
      `,
      [Number(docenteId)]
    );

    return res.status(200).json(resultado.rows);
  } catch (error) {
    console.error("Error al obtener lecturas del docente:", error);
    return res.status(500).json({ message: "Error al obtener lecturas" });
  }
};

/* =========================
   ACTUALIZAR LECTURA
========================= */
const actualizarLectura = async (req, res) => {
  const { docenteId, lecturaId } = req.params;
  const { titulo, autor, nivel_dificultad, contenido } = req.body;

  try {
    if (!titulo || !nivel_dificultad || !contenido) {
      return res.status(400).json({
        message: "Debes completar los campos obligatorios"
      });
    }

    const actualizado = await pool.query(
      `UPDATE lecturas
       SET titulo = $1,
           autor = $2,
           nivel_dificultad = $3,
           contenido = $4
       WHERE id = $5 AND creado_por = $6
       RETURNING *`,
      [
        titulo.trim(),
        autor?.trim() || null,
        nivel_dificultad.trim(),
        contenido.trim(),
        Number(lecturaId),
        Number(docenteId)
      ]
    );

    if (actualizado.rows.length === 0) {
      return res.status(404).json({ message: "Lectura no encontrada" });
    }

    await pool.query(
      `INSERT INTO eventos_log (usuario_id, tipo_evento, detalle)
       VALUES ($1, $2, $3)`,
      [
        Number(docenteId),
        "actualizacion_lectura",
        `Docente actualizó la lectura "${titulo}"`
      ]
    );

    return res.status(200).json({
      message: "Lectura actualizada correctamente",
      lectura: actualizado.rows[0]
    });
  } catch (error) {
    console.error("Error al actualizar lectura:", error);
    return res.status(500).json({ message: "Error al actualizar lectura" });
  }
};

/* =========================
   ELIMINAR LECTURA
========================= */
const eliminarLectura = async (req, res) => {
  const { docenteId, lecturaId } = req.params;

  const client = await pool.connect();

  try {
    await client.query("BEGIN");

    await client.query(
      `DELETE FROM asignaciones_lectura
       WHERE lectura_id = $1`,
      [Number(lecturaId)]
    );

    const eliminado = await client.query(
      `DELETE FROM lecturas
       WHERE id = $1 AND creado_por = $2
       RETURNING id, titulo`,
      [Number(lecturaId), Number(docenteId)]
    );

    if (eliminado.rows.length === 0) {
      await client.query("ROLLBACK");
      return res.status(404).json({ message: "Lectura no encontrada" });
    }

    await client.query(
      `INSERT INTO eventos_log (usuario_id, tipo_evento, detalle)
       VALUES ($1, $2, $3)`,
      [
        Number(docenteId),
        "eliminacion_lectura",
        `Docente eliminó la lectura "${eliminado.rows[0].titulo}"`
      ]
    );

    await client.query("COMMIT");

    return res.status(200).json({
      message: "Lectura eliminada correctamente"
    });
  } catch (error) {
    await client.query("ROLLBACK");
    console.error("Error al eliminar lectura:", error);
    return res.status(500).json({ message: "Error al eliminar lectura" });
  } finally {
    client.release();
  }
};

module.exports = {
  obtenerCursosDisponibles,
  crearLecturaYAsignarCurso,
  obtenerLecturasDocente,
  actualizarLectura,
  eliminarLectura
};