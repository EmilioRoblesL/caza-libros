const pool = require("../config/db");

/* =========================
   PERFIL DEL ALUMNO
========================= */
const obtenerPerfilAlumno = async (req, res) => {
  try {
    const { alumnoId } = req.params;

    const result = await pool.query(
      `
      SELECT 
        u.nombre,
        u.apellido,
        c.id AS curso_id,
        c.nombre AS curso,
        c.nivel,
        c.anio,
        d.nombre AS docente_nombre,
        d.apellido AS docente_apellido
      FROM usuarios u
      LEFT JOIN matriculas m ON m.alumno_id = u.id
      LEFT JOIN cursos c ON c.id = m.curso_id
      LEFT JOIN usuarios d ON d.id = c.docente_id
      WHERE u.id = $1
      `,
      [alumnoId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Alumno no encontrado" });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error("Error perfil alumno:", error);
    res.status(500).json({ message: "Error al obtener perfil" });
  }
};

/* =========================
   CUESTIONARIOS ASIGNADOS
========================= */
const obtenerCuestionariosAlumno = async (req, res) => {
  try {
    const { alumnoId } = req.params;

    const result = await pool.query(
      `
      SELECT 
        ca.cuestionario_id,
        q.titulo AS cuestionario_titulo,
        l.id AS lectura_id,
        l.titulo AS lectura_titulo,
        ca.enviado_en,
        ca.activo
      FROM cuestionarios_asignados ca
      INNER JOIN cuestionarios q ON q.id = ca.cuestionario_id
      INNER JOIN lecturas l ON l.id = q.lectura_id
      INNER JOIN matriculas m ON m.curso_id = ca.curso_id
      WHERE m.alumno_id = $1
      AND ca.activo = true
      ORDER BY ca.enviado_en DESC
      `,
      [alumnoId]
    );

    res.json(result.rows);
  } catch (error) {
    console.error("Error cuestionarios alumno:", error);
    res.status(500).json({ message: "Error al obtener cuestionarios" });
  }
};

module.exports = {
  obtenerPerfilAlumno,
  obtenerCuestionariosAlumno
};