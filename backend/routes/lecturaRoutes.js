const express = require("express");
const router = express.Router();
const {
  crearLectura,
  obtenerLecturas,
} = require("../controllers/lecturaController");

router.post("/", crearLectura);
router.get("/", obtenerLecturas);

module.exports = router;