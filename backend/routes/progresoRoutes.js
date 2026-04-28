const express = require("express");
const router = express.Router();

const progresoController = require("../controllers/progresoController");

/* =========================
   GUARDAR / ACTUALIZAR PROGRESO
========================= */
router.post("/", progresoController.guardarProgreso);

/* =========================
   OBTENER PROGRESO DE UN ALUMNO
========================= */
router.get("/alumno/:alumno_id", progresoController.obtenerProgresoAlumno);

module.exports = router;