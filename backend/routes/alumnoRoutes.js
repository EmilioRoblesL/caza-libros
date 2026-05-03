const express = require("express");
const router = express.Router();

const alumnoController = require("../controllers/alumnoController");

// 🔹 Perfil del alumno (curso + profesor)
router.get("/:alumnoId/perfil", alumnoController.obtenerPerfilAlumno);

// 🔹 Cuestionarios asignados al alumno
router.get("/:alumnoId/cuestionarios", alumnoController.obtenerCuestionariosAlumno);

module.exports = router;