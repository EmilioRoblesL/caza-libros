const express = require("express");
const router = express.Router();

const cuestionarioController = require("../controllers/cuestionarioController");

router.post("/", cuestionarioController.crearCuestionario);
router.get("/docente/:docenteId", cuestionarioController.obtenerCuestionariosDocente);
router.get("/:cuestionarioId", cuestionarioController.obtenerCuestionarioDetalle);

router.post("/:cuestionarioId/preguntas", cuestionarioController.agregarPregunta);
router.put("/preguntas/:preguntaId", cuestionarioController.actualizarPregunta);
router.delete("/preguntas/:preguntaId", cuestionarioController.eliminarPregunta);

router.put("/:cuestionarioId", cuestionarioController.actualizarCuestionario);
router.delete("/:cuestionarioId", cuestionarioController.eliminarCuestionario);

router.post("/:cuestionarioId/enviar", cuestionarioController.enviarCuestionarioAlCurso);
router.put("/:cuestionarioId/desactivar", cuestionarioController.desactivarEnvioCuestionario);

module.exports = router;