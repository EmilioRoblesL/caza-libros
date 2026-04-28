const express = require("express");
const router = express.Router();

const asignacionController = require("../controllers/asignacionController");

router.post("/", asignacionController.crearAsignacion);
router.get("/", asignacionController.obtenerAsignaciones);

module.exports = router;