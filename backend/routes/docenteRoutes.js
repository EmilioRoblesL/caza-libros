const express = require("express");
const router = express.Router();

const docenteController = require("../controllers/docenteController");

// ✔ rutas que SÍ existen
router.get("/alumnos", docenteController.obtenerAlumnos);
router.get("/resultados", docenteController.obtenerResultadosGenerales);
router.get("/panel/:docenteId", docenteController.obtenerPanelDocente);

router.post(
  "/panel/:docenteId/alumnos-pendientes",
  docenteController.registrarAlumnoPendienteEnCursoDocente
);

module.exports = router;