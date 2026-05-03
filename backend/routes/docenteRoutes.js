const express = require("express");
const router = express.Router();

const docenteController = require("../controllers/docenteController");

// ✔ rutas que SÍ existen
router.get("/alumnos", docenteController.obtenerAlumnos);
router.get("/resultados", docenteController.obtenerResultadosGenerales);
router.get("/panel/:docenteId", docenteController.obtenerPanelDocente);

router.put("/panel/:docenteId/alumnos/:alumnoId", docenteController.actualizarAlumnoCurso);
router.delete("/panel/:docenteId/alumnos/:alumnoId", docenteController.eliminarAlumnoCurso);

router.put("/panel/:docenteId/alumnos-pendientes/:pendienteId", docenteController.actualizarAlumnoPendiente);
router.delete("/panel/:docenteId/alumnos-pendientes/:pendienteId", docenteController.eliminarAlumnoPendiente);

router.post(
  "/panel/:docenteId/alumnos-pendientes",
  docenteController.registrarAlumnoPendienteEnCursoDocente
);

module.exports = router;