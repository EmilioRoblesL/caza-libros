const express = require("express");
const router = express.Router();
const { responderEvaluacion } = require("../controllers/evaluacionController");

router.post("/responder", responderEvaluacion);

module.exports = router;