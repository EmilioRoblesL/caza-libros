const pool = require("../config/db");

const obtenerPuntosAlumno = async (req, res) => {
  try {
    const { alumno_id } = req.params;

    const movimientos = await pool.query(
      `SELECT id, alumno_id, motivo, delta, creado_en
       FROM puntos
       WHERE alumno_id = $1
       ORDER BY creado_en DESC`,
      [alumno_id]
    );

    const total = await pool.query(
      `SELECT COALESCE(SUM(delta), 0) AS total_puntos
       FROM puntos
       WHERE alumno_id = $1`,
      [alumno_id]
    );

    return res.status(200).json({
      alumno_id: Number(alumno_id),
      total_puntos: Number(total.rows[0].total_puntos),
      movimientos: movimientos.rows,
    });
  } catch (error) {
    console.error("Error al obtener puntos:", error);
    return res.status(500).json({
      message: "Error al obtener puntos",
    });
  }
};

module.exports = { obtenerPuntosAlumno };