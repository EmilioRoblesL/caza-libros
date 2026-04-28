const pool = require("../config/db");

/* =========================
   CREAR CUESTIONARIO EN BORRADOR
========================= */
const crearCuestionario = async (req, res) => {
  try {
    const { docente_id, lectura_id, titulo, curso_id } = req.body;

    if (!docente_id || !lectura_id || !titulo || !curso_id) {
      return res.status(400).json({
        message: "Faltan datos obligatorios para crear el cuestionario"
      });
    }

    const resultado = await pool.query(
      `INSERT INTO cuestionarios (docente_id, lectura_id, titulo, curso_id, estado)
       VALUES ($1, $2, $3, $4, 'borrador')
       RETURNING *`,
      [docente_id, lectura_id, titulo.trim(), curso_id]
    );

    return res.status(201).json({
      message: "Cuestionario creado correctamente",
      cuestionario: resultado.rows[0]
    });
  } catch (error) {
    console.error("Error al crear cuestionario:", error);
    return res.status(500).json({
      message: "Error al crear cuestionario"
    });
  }
};

/* =========================
   OBTENER CUESTIONARIOS DEL DOCENTE
========================= */
const obtenerCuestionariosDocente = async (req, res) => {
  try {
    const { docenteId } = req.params;

    const resultado = await pool.query(
      `SELECT 
          c.id,
          c.docente_id,
          c.lectura_id,
          c.curso_id,
          c.titulo,
          c.estado,
          c.creado_en,
          c.actualizado_en,
          l.titulo AS lectura_titulo,
          cu.nombre AS curso_nombre,
          cu.nivel AS curso_nivel,
          cu.anio AS curso_anio,
          COUNT(DISTINCT p.id)::int AS total_preguntas
       FROM cuestionarios c
       LEFT JOIN lecturas l ON c.lectura_id = l.id
       LEFT JOIN cursos cu ON c.curso_id = cu.id
       LEFT JOIN preguntas p ON p.cuestionario_id = c.id
       WHERE c.docente_id = $1
       GROUP BY c.id, l.titulo, cu.nombre, cu.nivel, cu.anio
       ORDER BY c.creado_en DESC`,
      [docenteId]
    );

    return res.status(200).json(resultado.rows);
  } catch (error) {
    console.error("Error al obtener cuestionarios:", error);
    return res.status(500).json({
      message: "Error al obtener cuestionarios"
    });
  }
};

/* =========================
   OBTENER UN CUESTIONARIO CON PREGUNTAS Y OPCIONES
========================= */
const obtenerCuestionarioDetalle = async (req, res) => {
  try {
    const { cuestionarioId } = req.params;

    const cuestionarioRes = await pool.query(
      `SELECT * FROM cuestionarios WHERE id = $1`,
      [cuestionarioId]
    );

    if (cuestionarioRes.rows.length === 0) {
      return res.status(404).json({
        message: "Cuestionario no encontrado"
      });
    }

    const preguntasRes = await pool.query(
      `SELECT 
          p.id,
          p.cuestionario_id,
          p.lectura_id,
          p.enunciado,
          p.tipo,
          p.orden_pregunta
       FROM preguntas p
       WHERE p.cuestionario_id = $1
       ORDER BY p.orden_pregunta ASC, p.id ASC`,
      [cuestionarioId]
    );

    const preguntas = preguntasRes.rows;

    const preguntasConOpciones = [];

    for (const pregunta of preguntas) {
      const opcionesRes = await pool.query(
        `SELECT id, pregunta_id, texto, es_correcta
         FROM opciones
         WHERE pregunta_id = $1
         ORDER BY id ASC`,
        [pregunta.id]
      );

      preguntasConOpciones.push({
        ...pregunta,
        opciones: opcionesRes.rows
      });
    }

    return res.status(200).json({
      cuestionario: cuestionarioRes.rows[0],
      preguntas: preguntasConOpciones
    });
  } catch (error) {
    console.error("Error al obtener detalle del cuestionario:", error);
    return res.status(500).json({
      message: "Error al obtener detalle del cuestionario"
    });
  }
};

/* =========================
   AGREGAR PREGUNTA CON 4 OPCIONES
========================= */
const agregarPregunta = async (req, res) => {
  const client = await pool.connect();

  try {
    const { cuestionarioId } = req.params;
    const {
      enunciado,
      tipo,
      opciones,
      lectura_id
    } = req.body;

    if (!enunciado || !tipo || !Array.isArray(opciones) || opciones.length !== 4) {
      return res.status(400).json({
        message: "Debes enviar el enunciado, el tipo y exactamente 4 opciones"
      });
    }

    const correctas = opciones.filter((o) => o.es_correcta === true);
    if (correctas.length !== 1) {
      return res.status(400).json({
        message: "Debe existir exactamente 1 opción correcta y 3 falsas"
      });
    }

    await client.query("BEGIN");

    const cuestionarioRes = await client.query(
      `SELECT * FROM cuestionarios WHERE id = $1`,
      [cuestionarioId]
    );

    if (cuestionarioRes.rows.length === 0) {
      await client.query("ROLLBACK");
      return res.status(404).json({
        message: "Cuestionario no encontrado"
      });
    }

    if (cuestionarioRes.rows[0].estado === "enviado") {
      await client.query("ROLLBACK");
      return res.status(400).json({
        message: "No puedes modificar preguntas de un cuestionario ya enviado"
      });
    }

    const ordenRes = await client.query(
      `SELECT COALESCE(MAX(orden_pregunta), 0) + 1 AS siguiente
       FROM preguntas
       WHERE cuestionario_id = $1`,
      [cuestionarioId]
    );

    const orden = Number(ordenRes.rows[0].siguiente || 1);

    const preguntaRes = await client.query(
      `INSERT INTO preguntas (lectura_id, cuestionario_id, enunciado, tipo, orden_pregunta)
       VALUES ($1, $2, $3, $4, $5)
       RETURNING *`,
      [
        lectura_id || cuestionarioRes.rows[0].lectura_id,
        cuestionarioId,
        enunciado.trim(),
        tipo,
        orden
      ]
    );

    const pregunta = preguntaRes.rows[0];

    const opcionesGuardadas = [];
    for (const opcion of opciones) {
      const opcionRes = await client.query(
        `INSERT INTO opciones (pregunta_id, texto, es_correcta)
         VALUES ($1, $2, $3)
         RETURNING *`,
        [pregunta.id, opcion.texto.trim(), opcion.es_correcta === true]
      );

      opcionesGuardadas.push(opcionRes.rows[0]);
    }

    await client.query("COMMIT");

    return res.status(201).json({
      message: "Pregunta guardada correctamente",
      pregunta,
      opciones: opcionesGuardadas
    });
  } catch (error) {
    await client.query("ROLLBACK");
    console.error("Error al agregar pregunta:", error);
    return res.status(500).json({
      message: "Error al agregar pregunta"
    });
  } finally {
    client.release();
  }
};

/* =========================
   ACTUALIZAR PREGUNTA Y OPCIONES
========================= */
const actualizarPregunta = async (req, res) => {
  const client = await pool.connect();

  try {
    const { preguntaId } = req.params;
    const { enunciado, tipo, opciones } = req.body;

    if (!enunciado || !tipo || !Array.isArray(opciones) || opciones.length !== 4) {
      return res.status(400).json({
        message: "Debes enviar el enunciado, el tipo y exactamente 4 opciones"
      });
    }

    const correctas = opciones.filter((o) => o.es_correcta === true);
    if (correctas.length !== 1) {
      return res.status(400).json({
        message: "Debe existir exactamente 1 opción correcta"
      });
    }

    await client.query("BEGIN");

    const preguntaRes = await client.query(
      `SELECT p.*, c.estado
       FROM preguntas p
       INNER JOIN cuestionarios c ON c.id = p.cuestionario_id
       WHERE p.id = $1`,
      [preguntaId]
    );

    if (preguntaRes.rows.length === 0) {
      await client.query("ROLLBACK");
      return res.status(404).json({
        message: "Pregunta no encontrada"
      });
    }

    if (preguntaRes.rows[0].estado === "enviado") {
      await client.query("ROLLBACK");
      return res.status(400).json({
        message: "No puedes modificar preguntas de un cuestionario ya enviado"
      });
    }

    const preguntaActualizada = await client.query(
      `UPDATE preguntas
       SET enunciado = $1,
           tipo = $2
       WHERE id = $3
       RETURNING *`,
      [enunciado.trim(), tipo, preguntaId]
    );

    await client.query(
      `DELETE FROM opciones
       WHERE pregunta_id = $1`,
      [preguntaId]
    );

    const nuevasOpciones = [];
    for (const opcion of opciones) {
      const opcionRes = await client.query(
        `INSERT INTO opciones (pregunta_id, texto, es_correcta)
         VALUES ($1, $2, $3)
         RETURNING *`,
        [preguntaId, opcion.texto.trim(), opcion.es_correcta === true]
      );
      nuevasOpciones.push(opcionRes.rows[0]);
    }

    await client.query("COMMIT");

    return res.status(200).json({
      message: "Pregunta actualizada correctamente",
      pregunta: preguntaActualizada.rows[0],
      opciones: nuevasOpciones
    });
  } catch (error) {
    await client.query("ROLLBACK");
    console.error("Error al actualizar pregunta:", error);
    return res.status(500).json({
      message: "Error al actualizar pregunta"
    });
  } finally {
    client.release();
  }
};

/* =========================
   ELIMINAR PREGUNTA
========================= */
const eliminarPregunta = async (req, res) => {
  try {
    const { preguntaId } = req.params;

    const preguntaRes = await pool.query(
      `SELECT p.*, c.estado
       FROM preguntas p
       INNER JOIN cuestionarios c ON c.id = p.cuestionario_id
       WHERE p.id = $1`,
      [preguntaId]
    );

    if (preguntaRes.rows.length === 0) {
      return res.status(404).json({
        message: "Pregunta no encontrada"
      });
    }

    if (preguntaRes.rows[0].estado === "enviado") {
      return res.status(400).json({
        message: "No puedes eliminar preguntas de un cuestionario ya enviado"
      });
    }

    await pool.query(
      `DELETE FROM preguntas
       WHERE id = $1`,
      [preguntaId]
    );

    return res.status(200).json({
      message: "Pregunta eliminada correctamente"
    });
  } catch (error) {
    console.error("Error al eliminar pregunta:", error);
    return res.status(500).json({
      message: "Error al eliminar pregunta"
    });
  }
};

/* =========================
   ACTUALIZAR CUESTIONARIO
========================= */
const actualizarCuestionario = async (req, res) => {
  try {
    const { cuestionarioId } = req.params;
    const { titulo, lectura_id, curso_id } = req.body;

    const existeRes = await pool.query(
      `SELECT * FROM cuestionarios WHERE id = $1`,
      [cuestionarioId]
    );

    if (existeRes.rows.length === 0) {
      return res.status(404).json({
        message: "Cuestionario no encontrado"
      });
    }

    if (existeRes.rows[0].estado === "enviado") {
      return res.status(400).json({
        message: "No puedes editar un cuestionario ya enviado"
      });
    }

    const actualizado = await pool.query(
      `UPDATE cuestionarios
       SET titulo = $1,
           lectura_id = $2,
           curso_id = $3,
           actualizado_en = CURRENT_TIMESTAMP
       WHERE id = $4
       RETURNING *`,
      [titulo.trim(), lectura_id, curso_id, cuestionarioId]
    );

    return res.status(200).json({
      message: "Cuestionario actualizado correctamente",
      cuestionario: actualizado.rows[0]
    });
  } catch (error) {
    console.error("Error al actualizar cuestionario:", error);
    return res.status(500).json({
      message: "Error al actualizar cuestionario"
    });
  }
};

/* =========================
   ELIMINAR CUESTIONARIO
========================= */
const eliminarCuestionario = async (req, res) => {
  try {
    const { cuestionarioId } = req.params;

    const existeRes = await pool.query(
      `SELECT * FROM cuestionarios WHERE id = $1`,
      [cuestionarioId]
    );

    if (existeRes.rows.length === 0) {
      return res.status(404).json({
        message: "Cuestionario no encontrado"
      });
    }

    await pool.query(
      `DELETE FROM cuestionarios
       WHERE id = $1`,
      [cuestionarioId]
    );

    return res.status(200).json({
      message: "Cuestionario eliminado correctamente"
    });
  } catch (error) {
    console.error("Error al eliminar cuestionario:", error);
    return res.status(500).json({
      message: "Error al eliminar cuestionario"
    });
  }
};

/* =========================
   ENVIAR CUESTIONARIO AL CURSO
========================= */
const enviarCuestionarioAlCurso = async (req, res) => {
  try {
    const { cuestionarioId } = req.params;
    const { enviado_por } = req.body;

    const cuestionarioRes = await pool.query(
      `SELECT * FROM cuestionarios WHERE id = $1`,
      [cuestionarioId]
    );

    if (cuestionarioRes.rows.length === 0) {
      return res.status(404).json({
        message: "Cuestionario no encontrado"
      });
    }

    const cuestionario = cuestionarioRes.rows[0];

    const preguntasRes = await pool.query(
      `SELECT id FROM preguntas WHERE cuestionario_id = $1`,
      [cuestionarioId]
    );

    if (preguntasRes.rows.length === 0) {
      return res.status(400).json({
        message: "No puedes enviar un cuestionario sin preguntas"
      });
    }

    await pool.query(
      `INSERT INTO cuestionarios_asignados (cuestionario_id, curso_id, enviado_por, activo)
       VALUES ($1, $2, $3, TRUE)
       ON CONFLICT DO NOTHING`,
      [cuestionarioId, cuestionario.curso_id, enviado_por]
    );

    const actualizado = await pool.query(
      `UPDATE cuestionarios
       SET estado = 'enviado',
           actualizado_en = CURRENT_TIMESTAMP
       WHERE id = $1
       RETURNING *`,
      [cuestionarioId]
    );

    return res.status(200).json({
      message: "Cuestionario enviado al curso correctamente",
      cuestionario: actualizado.rows[0]
    });
  } catch (error) {
    console.error("Error al enviar cuestionario:", error);
    return res.status(500).json({
      message: "Error al enviar cuestionario"
    });
  }
};

/* =========================
   QUITAR ENVÍO / DESACTIVAR
========================= */
const desactivarEnvioCuestionario = async (req, res) => {
  try {
    const { cuestionarioId } = req.params;

    await pool.query(
      `UPDATE cuestionarios_asignados
       SET activo = FALSE
       WHERE cuestionario_id = $1`,
      [cuestionarioId]
    );

    const actualizado = await pool.query(
      `UPDATE cuestionarios
       SET estado = 'borrador',
           actualizado_en = CURRENT_TIMESTAMP
       WHERE id = $1
       RETURNING *`,
      [cuestionarioId]
    );

    return res.status(200).json({
      message: "Envío desactivado correctamente",
      cuestionario: actualizado.rows[0]
    });
  } catch (error) {
    console.error("Error al desactivar envío:", error);
    return res.status(500).json({
      message: "Error al desactivar envío"
    });
  }
};

module.exports = {
  crearCuestionario,
  obtenerCuestionariosDocente,
  obtenerCuestionarioDetalle,
  agregarPregunta,
  actualizarPregunta,
  eliminarPregunta,
  actualizarCuestionario,
  eliminarCuestionario,
  enviarCuestionarioAlCurso,
  desactivarEnvioCuestionario
};