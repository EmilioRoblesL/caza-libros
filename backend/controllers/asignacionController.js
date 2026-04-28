const pool = require("../config/db");

const crearAsignacion = async (req, res) => {
  try {
    const { lectura_id, curso_id, alumno_id, fecha_inicio, fecha_fin } = req.body;

    if (!lectura_id) {
      return res.status(400).json({
        message: "Falta lectura_id",
      });
    }

    const nuevaAsignacion = await pool.query(
      `INSERT INTO asignaciones (lectura_id, curso_id, alumno_id, fecha_inicio, fecha_fin)
       VALUES ($1, $2, $3, $4, $5)
       RETURNING *`,
      [
        lectura_id,
        curso_id || null,
        alumno_id || null,
        fecha_inicio || null,
        fecha_fin || null
      ]
    );

    return res.status(201).json({
      message: "Asignación creada correctamente",
      asignacion: nuevaAsignacion.rows[0],
    });
  } catch (error) {
    console.error("Error al crear asignación:", error);
    return res.status(500).json({ message: "Error al crear asignación" });
  }
};

const obtenerAsignaciones = async (req, res) => {
  try {
    const resultado = await pool.query(`
      SELECT
        al.id,
        al.lectura_id,
        al.alumno_id,
        al.curso_id,
        al.estado,
        l.titulo,
        l.autor,
        l.contenido
      FROM asignaciones_lectura al
      LEFT JOIN lecturas l ON al.lectura_id = l.id
      ORDER BY al.id DESC
    `);

    return res.json(resultado.rows);
  } catch (error) {
    console.error("Error al obtener asignaciones:", error);
    return res.status(500).json({ message: "Error al obtener asignaciones" });
  }
};

module.exports = {
  crearAsignacion,
  obtenerAsignaciones,
};