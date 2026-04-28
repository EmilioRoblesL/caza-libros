const express = require("express");
const router = express.Router();
const { obtenerPuntosAlumno } = require("../controllers/puntosController");

router.get("/:alumno_id", obtenerPuntosAlumno);

module.exports = router;