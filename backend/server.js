const express = require("express");
const cors = require("cors");
const pool = require("./config/db");

const authRoutes = require("./routes/authRoutes");
const lecturaRoutes = require("./routes/lecturaRoutes");
const asignacionRoutes = require("./routes/asignacionRoutes");
const evaluacionRoutes = require("./routes/evaluacionRoutes");
const progresoRoutes = require("./routes/progresoRoutes");
const puntosRoutes = require("./routes/puntosRoutes");
const resultadosRoutes = require("./routes/resultadosRoutes");
const docenteRoutes = require("./routes/docenteRoutes");
const adminRoutes = require("./routes/adminRoutes");
const docenteLecturaRoutes = require("./routes/docenteLecturaRoutes");
const cuestionarioRoutes = require("./routes/cuestionarioRoutes");
const alumnoRoutes = require("./routes/alumnoRoutes");

const app = express();

app.use(cors());
app.use(express.json({ limit: "10mb" }));
app.use(express.urlencoded({ extended: true, limit: "10mb" }));

app.get("/", (req, res) => {
  res.send("API CazaLibros funcionando correctamente");
});

app.get("/test-db", async (req, res) => {
  try {
    const result = await pool.query("SELECT NOW()");
    res.json(result.rows);
  } catch (error) {
    console.error(error);
    res.status(500).send("Error conectando a DB");
  }
});

/* =========================
   RUTAS
========================= */
app.use("/api/auth", authRoutes);
app.use("/api/lecturas", lecturaRoutes);
app.use("/api/asignaciones", asignacionRoutes);
app.use("/api/evaluaciones", evaluacionRoutes);
app.use("/api/progreso", progresoRoutes);
app.use("/api/puntos", puntosRoutes);
app.use("/api/resultados", resultadosRoutes);
app.use("/api/docente", docenteRoutes);
app.use("/api/admin", adminRoutes);
app.use("/api/docente-lecturas", docenteLecturaRoutes);
app.use("/api/cuestionarios", cuestionarioRoutes);
app.use("/api/alumnos", alumnoRoutes);

/* =========================
   ERROR HANDLER
========================= */
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    message: "Error interno del servidor"
  });
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});