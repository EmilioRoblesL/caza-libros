const express = require("express");
const router = express.Router();
const { obtenerResultadosAlumno } = require("../controllers/resultadosController");

router.get("/:alumno_id", obtenerResultadosAlumno);

module.exports = router;