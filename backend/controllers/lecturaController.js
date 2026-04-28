const pool = require("../config/db");

const crearLectura = async (req, res) => {
  try {
    const { titulo, autor, nivel_dificultad, contenido, creado_por } = req.body;

    if (!titulo || !nivel_dificultad || !contenido) {
      return res.status(400).json({
        message: "Faltan campos obligatorios",
      });
    }

    const nuevaLectura = await pool.query(
      `INSERT INTO lecturas (titulo, autor, nivel_dificultad, contenido, creado_por)
       VALUES ($1, $2, $3, $4, $5)
       RETURNING *`,
      [titulo, autor, nivel_dificultad, contenido, creado_por]
    );

    res.status(201).json({
      message: "Lectura creada correctamente",
      lectura: nuevaLectura.rows[0],
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error al crear lectura" });
  }
};

const obtenerLecturas = async (req, res) => {
  try {
    const lecturas = await pool.query("SELECT * FROM lecturas ORDER BY id DESC");

    res.json(lecturas.rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error al obtener lecturas" });
  }
};

module.exports = {
  crearLectura,
  obtenerLecturas,
};