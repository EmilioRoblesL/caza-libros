const express = require("express");
const router = express.Router();
const {
  obtenerUsuarios,
  obtenerResumenSistema,
  obtenerAlertasSistema,
  crearUsuarioAdmin,
  actualizarUsuarioAdmin,
  eliminarUsuarioAdmin,
  obtenerActividadSemanal,
  obtenerAuditoriaSistema,
  obtenerReportesSistema,
  exportarAuditoriaCSV,
  respaldarSistema,
  verificarSeguridadSistema
} = require("../controllers/adminController");

router.get("/usuarios", obtenerUsuarios);
router.get("/resumen", obtenerResumenSistema);
router.get("/alertas", obtenerAlertasSistema);
router.get("/actividad", obtenerActividadSemanal);
router.get("/auditoria", obtenerAuditoriaSistema);
router.get("/reportes", obtenerReportesSistema);
router.get("/auditoria/exportar", exportarAuditoriaCSV);
router.get("/backup", respaldarSistema);
router.get("/seguridad/verificar", verificarSeguridadSistema);




router.post("/usuarios", crearUsuarioAdmin);
router.put("/usuarios/:id", actualizarUsuarioAdmin);
router.delete("/usuarios/:id", eliminarUsuarioAdmin);


module.exports = router;