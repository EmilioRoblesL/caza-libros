const express = require("express");
const router = express.Router();

const {
  responderEvaluacion,
  obtenerCuestionariosAlumno
} = require("../controllers/evaluacionController");

router.get("/alumno/:alumnoId/cuestionarios", obtenerCuestionariosAlumno);
router.post("/responder", responderEvaluacion);

module.exports = router;