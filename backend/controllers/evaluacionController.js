const pool = require("../config/db");

const responderEvaluacion = async (req, res) => {
  const client = await pool.connect();

  try {
    const { alumno_id, lectura_id, respuestas } = req.body;

    if (!alumno_id || !lectura_id || !respuestas || !Array.isArray(respuestas) || respuestas.length === 0) {
      return res.status(400).json({
        message: "Datos incompletos",
      });
    }

    await client.query("BEGIN");

    const intentoResult = await client.query(
      `INSERT INTO intentos (alumno_id, lectura_id)
       VALUES ($1, $2)
       RETURNING id`,
      [alumno_id, lectura_id]
    );

    const intento_id = intentoResult.rows[0].id;
    let correctas = 0;

    for (const r of respuestas) {
      const { pregunta_id, opcion_id } = r;

      if (!pregunta_id || !opcion_id) {
        await client.query("ROLLBACK");
        return res.status(400).json({
          message: "Cada respuesta debe incluir pregunta_id y opcion_id",
        });
      }

      const opcion = await client.query(
        `SELECT id, pregunta_id, es_correcta
         FROM opciones
         WHERE id = $1`,
        [opcion_id]
      );

      if (opcion.rows.length === 0) {
        await client.query("ROLLBACK");
        return res.status(404).json({
          message: `La opción con id ${opcion_id} no existe`,
        });
      }

      const opcionData = opcion.rows[0];

      if (opcionData.pregunta_id !== pregunta_id) {
        await client.query("ROLLBACK");
        return res.status(400).json({
          message: `La opción ${opcion_id} no pertenece a la pregunta ${pregunta_id}`,
        });
      }

      const esCorrecta = opcionData.es_correcta;

      if (esCorrecta) {
        correctas++;
      }

      await client.query(
        `INSERT INTO respuestas (intento_id, pregunta_id, opcion_id, correcta)
         VALUES ($1, $2, $3, $4)`,
        [intento_id, pregunta_id, opcion_id, esCorrecta]
      );
    }

    const total = respuestas.length;
    const puntaje = Number(((correctas / total) * 100).toFixed(2));
    const aprobado = puntaje >= 60;

    await client.query(
      `UPDATE intentos
       SET puntaje = $1, aprobado = $2
       WHERE id = $3`,
      [puntaje, aprobado, intento_id]
    );

    let puntosGanados = 0;

    if (aprobado) {
      puntosGanados = 20;

      await client.query(
        `INSERT INTO puntos (alumno_id, motivo, delta)
         VALUES ($1, $2, $3)`,
        [alumno_id, `Aprobó evaluación de lectura ${lectura_id}`, puntosGanados]
      );
    }

    await client.query("COMMIT");

    return res.status(200).json({
      message: "Evaluación enviada correctamente",
      intento_id,
      correctas,
      total,
      puntaje,
      aprobado,
      puntos_ganados: puntosGanados,
    });
  } catch (error) {
    await client.query("ROLLBACK");
    console.error("Error en evaluación:", error);
    return res.status(500).json({
      message: "Error en evaluación",
    });
  } finally {
    client.release();
  }
};

module.exports = { responderEvaluacion };