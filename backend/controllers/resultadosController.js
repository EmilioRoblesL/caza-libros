const pool = require("../config/db");

const obtenerResultadosAlumno = async (req, res) => {
  try {
    const { alumno_id } = req.params;

    const resultado = await pool.query(
      `SELECT 
          i.id AS intento_id,
          i.alumno_id,
          i.lectura_id,
          l.titulo,
          i.puntaje,
          i.aprobado,
          i.creado_en
       FROM intentos i
       INNER JOIN lecturas l ON i.lectura_id = l.id
       WHERE i.alumno_id = $1
       ORDER BY i.creado_en DESC`,
      [alumno_id]
    );

    return res.status(200).json(resultado.rows);
  } catch (error) {
    console.error("Error al obtener resultados del alumno:", error);
    return res.status(500).json({
      message: "Error al obtener resultados",
    });
  }
};

module.exports = { obtenerResultadosAlumno };