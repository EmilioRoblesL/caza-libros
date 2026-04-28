const pool = require("../config/db");

const guardarProgreso = async (req, res) => {
  try {
    let { alumno_id, lectura_id, porcentaje_avance, ultima_pagina } = req.body;

    alumno_id = Number(alumno_id);
    lectura_id = Number(lectura_id);
    porcentaje_avance = Number(porcentaje_avance);

    if (!alumno_id || !lectura_id || Number.isNaN(porcentaje_avance)) {
      return res.status(400).json({
        message: "Faltan datos obligatorios",
      });
    }

    if (porcentaje_avance < 0 || porcentaje_avance > 100) {
      return res.status(400).json({
        message: "El porcentaje debe estar entre 0 y 100",
      });
    }

    if (ultima_pagina !== undefined && ultima_pagina !== null && ultima_pagina !== "") {
      ultima_pagina = Number(ultima_pagina);

      if (Number.isNaN(ultima_pagina) || ultima_pagina < 1) {
        return res.status(400).json({
          message: "La última página debe ser un número válido mayor o igual a 1",
        });
      }
    } else {
      ultima_pagina = 1;
    }

    const progresoExistente = await pool.query(
      `SELECT id
       FROM progreso_lectura
       WHERE alumno_id = $1 AND lectura_id = $2`,
      [alumno_id, lectura_id]
    );

    let resultado;

    if (progresoExistente.rows.length > 0) {
      resultado = await pool.query(
        `UPDATE progreso_lectura
         SET porcentaje_avance = $1,
             ultima_pagina = $2,
             actualizado_en = CURRENT_TIMESTAMP
         WHERE alumno_id = $3 AND lectura_id = $4
         RETURNING *`,
        [porcentaje_avance, ultima_pagina, alumno_id, lectura_id]
      );
    } else {
      resultado = await pool.query(
        `INSERT INTO progreso_lectura (
          alumno_id,
          lectura_id,
          porcentaje_avance,
          ultima_pagina,
          actualizado_en
        )
         VALUES ($1, $2, $3, $4, CURRENT_TIMESTAMP)
         RETURNING *`,
        [alumno_id, lectura_id, porcentaje_avance, ultima_pagina]
      );
    }

    return res.status(200).json({
      message: "Progreso guardado correctamente",
      progreso: resultado.rows[0],
    });
  } catch (error) {
    console.error("Error al guardar progreso:", error);
    return res.status(500).json({
      message: "Error al guardar progreso",
    });
  }
};

const obtenerProgresoAlumno = async (req, res) => {
  try {
    const alumno_id = Number(req.params.alumno_id);

    if (!alumno_id) {
      return res.status(400).json({
        message: "ID de alumno inválido",
      });
    }

    const resultado = await pool.query(
      `SELECT 
          p.id,
          p.alumno_id,
          p.lectura_id,
          p.porcentaje_avance,
          p.ultima_pagina,
          p.actualizado_en,
          l.titulo,
          l.autor
       FROM progreso_lectura p
       INNER JOIN lecturas l ON p.lectura_id = l.id
       WHERE p.alumno_id = $1
       ORDER BY p.actualizado_en DESC`,
      [alumno_id]
    );

    return res.status(200).json(resultado.rows);
  } catch (error) {
    console.error("Error al obtener progreso:", error);
    return res.status(500).json({
      message: "Error al obtener progreso",
    });
  }
};

module.exports = {
  guardarProgreso,
  obtenerProgresoAlumno,
};