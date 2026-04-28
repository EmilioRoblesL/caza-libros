const express = require("express");
const router = express.Router();
const controller = require("../controllers/docenteLecturaController");

router.get("/cursos", controller.obtenerCursosDisponibles);
router.get("/:docenteId/lecturas", controller.obtenerLecturasDocente);
router.post("/:docenteId/lecturas", controller.crearLecturaYAsignarCurso);
router.put("/:docenteId/lecturas/:lecturaId", controller.actualizarLectura);
router.delete("/:docenteId/lecturas/:lecturaId", controller.eliminarLectura);

module.exports = router;