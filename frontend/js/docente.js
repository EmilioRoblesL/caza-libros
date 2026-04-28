const usuario = JSON.parse(localStorage.getItem("usuario"));

if (!usuario || usuario.rol !== "docente") {
  alert("Acceso no autorizado");
  window.location.href = "login.html";
}

const API_DOCENTE = "http://localhost:3000/api/docente";
const API_LECTURAS = "http://localhost:3000/api/docente-lecturas";
const API_CUESTIONARIOS = "http://localhost:3000/api/cuestionarios";

let alumnosCursoGlobal = [];
let alumnosPendientesGlobal = [];
let resultadosCursoGlobal = [];
let lecturasDocenteGlobal = [];
let lecturaEditandoId = null;

let graficoDocenteBarras = null;
let graficoDocentePie = null;
let graficoDocenteLineas = null;

let cuestionariosGlobal = [];
let preguntasCuestionarioGlobal = [];
let cuestionarioEditandoId = null;

/* =========================
   UTILIDADES
========================= */
function escaparHTML(valor) {
  return String(valor ?? "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;");
}

function obtenerColorProgreso(porcentaje) {
  if (porcentaje >= 100) return "#2eaf62";
  if (porcentaje >= 50) return "#5b64f5";
  if (porcentaje > 0) return "#f0ad4e";
  return "#d9534f";
}

function formatearFecha(fecha) {
  if (!fecha) return "";
  const d = new Date(fecha);
  if (Number.isNaN(d.getTime())) return "";
  return d.toLocaleDateString();
}

function obtenerFechaISO(fecha) {
  const d = new Date(fecha);
  if (Number.isNaN(d.getTime())) return "";
  return d.toISOString().split("T")[0];
}

function destruirGraficosDocente() {
  if (graficoDocenteBarras) {
    graficoDocenteBarras.destroy();
    graficoDocenteBarras = null;
  }
  if (graficoDocentePie) {
    graficoDocentePie.destroy();
    graficoDocentePie = null;
  }
  if (graficoDocenteLineas) {
    graficoDocenteLineas.destroy();
    graficoDocenteLineas = null;
  }
}

/* =========================
   FORMULARIO AGREGAR ALUMNO
========================= */
function toggleFormulario() {
  const form = document.getElementById("formAgregarAlumno");
  if (!form) return;
  form.classList.toggle("hidden");
}

function limpiarFormularioAlumnoDocente() {
  const nombre = document.getElementById("nuevoAlumnoNombre");
  const apellido = document.getElementById("nuevoAlumnoApellido");
  const correo = document.getElementById("nuevoAlumnoCorreo");
  const mensaje = document.getElementById("mensajeAlumnoDocente");

  if (nombre) nombre.value = "";
  if (apellido) apellido.value = "";
  if (correo) correo.value = "";
  if (mensaje) {
    mensaje.textContent = "";
    mensaje.style.color = "";
  }
}

/* =========================
   CAMBIO DE SECCIONES
========================= */
function mostrarSeccionDocente(seccion, element) {
  const secciones = {
    inicio: document.getElementById("docente-seccion-inicio"),
    lecturas: document.getElementById("docente-seccion-lecturas"),
    cuestionarios: document.getElementById("docente-seccion-cuestionarios"),
    resultados: document.getElementById("docente-seccion-resultados"),
    estadisticas: document.getElementById("docente-seccion-estadisticas")
  };

  Object.values(secciones).forEach((sec) => {
    if (!sec) return;
    sec.classList.remove("admin-section-visible");
    sec.classList.add("admin-section-hidden");
  });

  if (secciones[seccion]) {
    secciones[seccion].classList.remove("admin-section-hidden");
    secciones[seccion].classList.add("admin-section-visible");
  }

  document.querySelectorAll(".menu-link").forEach((link) => {
    link.classList.remove("active");
  });

  if (element) {
    element.classList.add("active");
  }

  if (seccion === "estadisticas") {
    setTimeout(() => {
      renderizarEstadisticasDocente();
    }, 80);
  }
}

async function cargarPanelDocente() {
  try {
    const res = await fetch(`${API_DOCENTE}/panel/${usuario.id}`);
    const data = await res.json();

    if (!res.ok) {
      throw new Error(data.message || "No se pudo cargar el panel");
    }

    alumnosCursoGlobal = Array.isArray(data.alumnos) ? data.alumnos : [];
    alumnosPendientesGlobal = Array.isArray(data.alumnos_pendientes) ? data.alumnos_pendientes : [];
    resultadosCursoGlobal = Array.isArray(data.resultados) ? data.resultados : [];

    const nombreDocente = document.getElementById("nombreDocente");
    if (nombreDocente) {
      nombreDocente.textContent = `${usuario.nombre || ""} ${usuario.apellido || ""}`.trim();
    }

    const cursoNombre = `${data.curso.nombre} - ${data.curso.nivel} (${data.curso.anio})`;

    const cursoDocenteInfo = document.getElementById("cursoDocenteInfo");
    if (cursoDocenteInfo) {
      cursoDocenteInfo.textContent = `Profesor jefe del curso: ${cursoNombre}`;
    }

    const cursoDocenteNombre = document.getElementById("cursoDocenteNombre");
    if (cursoDocenteNombre) {
      cursoDocenteNombre.textContent = cursoNombre;
    }

    const cantidadAlumnos = document.getElementById("cantidadAlumnos");
    if (cantidadAlumnos) {
      const pendientes = Math.max((data.total_esperado || 0) - (data.total_registrados || 0), 0);
      cantidadAlumnos.innerHTML = `
        <span>${data.total_registrados} de ${data.total_esperado}</span>
        <small style="display:block; margin-top:8px; font-size:14px; font-weight:600; color:#4f5c75;">
          Faltan ${pendientes} alumnos por registrarse
        </small>
      `;
    }

    const cantidadResultados = document.getElementById("cantidadResultados");
    if (cantidadResultados) {
      cantidadResultados.textContent = resultadosCursoGlobal.length;
    }

    const resumenCursoDocente = document.getElementById("resumenCursoDocente");
    if (resumenCursoDocente) {
      resumenCursoDocente.textContent =
        `${data.total_registrados} alumnos registrados de ${data.total_esperado}. Pendientes por registrarse: ${data.total_pendientes || 0}`;
    }

    const filtroCurso = document.getElementById("filtroCurso");
    if (filtroCurso) {
      filtroCurso.value = cursoNombre;
    }

    renderizarTablaAlumnosCurso(alumnosCursoGlobal);
    renderizarTablaPendientes(alumnosPendientesGlobal);
    renderizarResultadosInicio(resultadosCursoGlobal);
    renderizarResultadosResumen(resultadosCursoGlobal);
    renderizarEstadisticasDocente();
  } catch (error) {
    console.error("Error al cargar panel docente:", error);

    const resumenCursoDocente = document.getElementById("resumenCursoDocente");
    if (resumenCursoDocente) {
      resumenCursoDocente.textContent = error.message || "No fue posible cargar la información del curso.";
    }

    const tablaAlumnos = document.getElementById("tablaAlumnosCursoBody");
    if (tablaAlumnos) {
      tablaAlumnos.innerHTML = `<tr><td colspan="7">No fue posible cargar los alumnos</td></tr>`;
    }

    const tablaPendientes = document.getElementById("tablaPendientesBody");
    if (tablaPendientes) {
      tablaPendientes.innerHTML = `<tr><td colspan="6">No fue posible cargar los pendientes</td></tr>`;
    }

    const tablaResultados = document.getElementById("tablaResultadosBody");
    if (tablaResultados) {
      tablaResultados.innerHTML = `<tr><td colspan="5">No fue posible cargar los resultados</td></tr>`;
    }

    const tablaResumen = document.getElementById("tablaResultadosResumenBody");
    if (tablaResumen) {
      tablaResumen.innerHTML = `<tr><td colspan="5">No fue posible cargar el resumen</td></tr>`;
    }

    destruirGraficosDocente();
  }
}

/* =========================
   CREAR PENDIENTE
========================= */
async function registrarAlumnoDesdeDocente() {
  const nombre = document.getElementById("nuevoAlumnoNombre")?.value.trim();
  const apellido = document.getElementById("nuevoAlumnoApellido")?.value.trim();
  const correo = document.getElementById("nuevoAlumnoCorreo")?.value.trim();
  const mensaje = document.getElementById("mensajeAlumnoDocente");

  if (!nombre || !apellido || !correo) {
    if (mensaje) {
      mensaje.textContent = "Completa nombre, apellido y correo";
      mensaje.style.color = "red";
    }
    return;
  }

  try {
    const res = await fetch(`${API_DOCENTE}/panel/${usuario.id}/alumnos-pendientes`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ nombre, apellido, correo })
    });

    const data = await res.json();

    if (!res.ok) {
      throw new Error(data.message || "No se pudo agregar el alumno");
    }

    if (mensaje) {
      mensaje.textContent = "Alumno agregado correctamente";
      mensaje.style.color = "green";
    }

    limpiarFormularioAlumnoDocente();
    await cargarPanelDocente();

    const form = document.getElementById("formAgregarAlumno");
    if (form) {
      form.classList.add("hidden");
    }
  } catch (error) {
    console.error("Error al agregar alumno pendiente:", error);
    if (mensaje) {
      mensaje.textContent = error.message || "Error al agregar alumno";
      mensaje.style.color = "red";
    }
  }
}

/* =========================
   TABLA ALUMNOS REGISTRADOS
========================= */
function renderizarTablaAlumnosCurso(alumnos) {
  const tbody = document.getElementById("tablaAlumnosCursoBody");
  if (!tbody) return;

  tbody.innerHTML = "";

  if (!Array.isArray(alumnos) || alumnos.length === 0) {
    tbody.innerHTML = `<tr><td colspan="7">Sin alumnos</td></tr>`;
    return;
  }

  alumnos.forEach((a, index) => {
    const progreso = Number(a.porcentaje_avance || 0);
    const tr = document.createElement("tr");

    tr.innerHTML = `
      <td>${index + 1}</td>
      <td>${escaparHTML(a.nombre_completo)}</td>
      <td>${escaparHTML(a.correo)}</td>
      <td>${progreso}%</td>
      <td>
        <div class="docente-progress-wrap">
          <div 
            class="docente-progress-bar"
            style="width:${progreso}%; background:${obtenerColorProgreso(progreso)};">
          </div>
        </div>
      </td>
      <td>${escaparHTML(a.estado_lectura)}</td>
      <td>
        <button type="button" class="btn-table" onclick="editarAlumno(${a.id}, ${JSON.stringify(a.nombre)}, ${JSON.stringify(a.apellido)}, ${JSON.stringify(a.correo)})">Editar</button>
        <button type="button" class="btn-table btn-danger" onclick="eliminarAlumno(${a.id})">Eliminar</button>
      </td>
    `;

    tbody.appendChild(tr);
  });
}

/* =========================
   TABLA PENDIENTES
========================= */
function renderizarTablaPendientes(pendientes) {
  const tbody = document.getElementById("tablaPendientesBody");
  if (!tbody) return;

  tbody.innerHTML = "";

  if (!Array.isArray(pendientes) || pendientes.length === 0) {
    tbody.innerHTML = `<tr><td colspan="6">No hay alumnos pendientes</td></tr>`;
    return;
  }

  pendientes.forEach((p, index) => {
    const nombreCompleto = `${p.nombre || ""} ${p.apellido || ""}`.trim();
    const tr = document.createElement("tr");

    tr.innerHTML = `
      <td>${index + 1}</td>
      <td>${escaparHTML(nombreCompleto)}</td>
      <td>${escaparHTML(p.correo)}</td>
      <td>${escaparHTML(p.estado || "pendiente")}</td>
      <td>${formatearFecha(p.creado_en)}</td>
      <td>
        <button type="button" class="btn-table" onclick="editarPendiente(${p.id}, ${JSON.stringify(p.nombre)}, ${JSON.stringify(p.apellido)}, ${JSON.stringify(p.correo)})">Editar</button>
        <button type="button" class="btn-table btn-danger" onclick="eliminarPendiente(${p.id})">Eliminar</button>
      </td>
    `;

    tbody.appendChild(tr);
  });
}

/* =========================
   EDITAR ALUMNO REGISTRADO
========================= */
function editarAlumno(id, nombre, apellido, correo) {
  document.getElementById("editarAlumnoId").value = id;
  document.getElementById("editarAlumnoNombre").value = nombre;
  document.getElementById("editarAlumnoApellido").value = apellido;
  document.getElementById("editarAlumnoCorreo").value = correo;

  const form = document.getElementById("formEditarAlumnoContainer");
  if (form) {
    form.classList.remove("hidden");
    window.scrollTo({ top: 0, behavior: "smooth" });
  }
}

async function guardarEdicionAlumno() {
  const id = document.getElementById("editarAlumnoId")?.value;
  const nombre = document.getElementById("editarAlumnoNombre")?.value.trim();
  const apellido = document.getElementById("editarAlumnoApellido")?.value.trim();
  const correo = document.getElementById("editarAlumnoCorreo")?.value.trim();
  const mensaje = document.getElementById("mensajeEditarAlumno");

  if (!id || !nombre || !apellido || !correo) {
    if (mensaje) {
      mensaje.textContent = "Completa todos los campos";
      mensaje.style.color = "red";
    }
    return;
  }

  try {
    const res = await fetch(`${API_DOCENTE}/panel/${usuario.id}/alumnos/${id}`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ nombre, apellido, correo })
    });

    const data = await res.json();

    if (!res.ok) {
      throw new Error(data.message || "No se pudo actualizar el alumno");
    }

    if (mensaje) {
      mensaje.textContent = "Alumno actualizado correctamente";
      mensaje.style.color = "green";
    }

    cerrarEdicionAlumno();
    await cargarPanelDocente();
  } catch (error) {
    console.error("Error al editar alumno:", error);
    if (mensaje) {
      mensaje.textContent = error.message;
      mensaje.style.color = "red";
    }
  }
}

function cerrarEdicionAlumno() {
  const form = document.getElementById("formEditarAlumnoContainer");
  const mensaje = document.getElementById("mensajeEditarAlumno");

  if (form) form.classList.add("hidden");
  if (mensaje) {
    mensaje.textContent = "";
    mensaje.style.color = "";
  }
}

/* =========================
   ELIMINAR ALUMNO REGISTRADO
========================= */
async function eliminarAlumno(id) {
  const confirmar = confirm("¿Eliminar alumno del curso?");
  if (!confirmar) return;

  try {
    const res = await fetch(`${API_DOCENTE}/panel/${usuario.id}/alumnos/${id}`, {
      method: "DELETE"
    });

    const data = await res.json();

    if (!res.ok) {
      throw new Error(data.message || "No se pudo eliminar el alumno");
    }

    await cargarPanelDocente();
  } catch (error) {
    console.error("Error al eliminar alumno:", error);
    alert(error.message);
  }
}

/* =========================
   EDITAR PENDIENTE
========================= */
function editarPendiente(id, nombre, apellido, correo) {
  document.getElementById("editarPendienteId").value = id;
  document.getElementById("editarPendienteNombre").value = nombre;
  document.getElementById("editarPendienteApellido").value = apellido;
  document.getElementById("editarPendienteCorreo").value = correo;

  const form = document.getElementById("formEditarPendienteContainer");
  if (form) {
    form.classList.remove("hidden");
    window.scrollTo({ top: 0, behavior: "smooth" });
  }
}

async function guardarEdicionPendiente() {
  const id = document.getElementById("editarPendienteId")?.value;
  const nombre = document.getElementById("editarPendienteNombre")?.value.trim();
  const apellido = document.getElementById("editarPendienteApellido")?.value.trim();
  const correo = document.getElementById("editarPendienteCorreo")?.value.trim();
  const mensaje = document.getElementById("mensajeEditarPendiente");

  if (!id || !nombre || !apellido || !correo) {
    if (mensaje) {
      mensaje.textContent = "Completa todos los campos";
      mensaje.style.color = "red";
    }
    return;
  }

  try {
    const res = await fetch(`${API_DOCENTE}/panel/${usuario.id}/alumnos-pendientes/${id}`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ nombre, apellido, correo })
    });

    const data = await res.json();

    if (!res.ok) {
      throw new Error(data.message || "No se pudo actualizar el pendiente");
    }

    if (mensaje) {
      mensaje.textContent = "Pendiente actualizado correctamente";
      mensaje.style.color = "green";
    }

    cerrarEdicionPendiente();
    await cargarPanelDocente();
  } catch (error) {
    console.error("Error al editar pendiente:", error);
    if (mensaje) {
      mensaje.textContent = error.message;
      mensaje.style.color = "red";
    }
  }
}

function cerrarEdicionPendiente() {
  const form = document.getElementById("formEditarPendienteContainer");
  const mensaje = document.getElementById("mensajeEditarPendiente");

  if (form) form.classList.add("hidden");
  if (mensaje) {
    mensaje.textContent = "";
    mensaje.style.color = "";
  }
}

/* =========================
   ELIMINAR PENDIENTE
========================= */
async function eliminarPendiente(id) {
  const confirmar = confirm("¿Eliminar alumno pendiente?");
  if (!confirmar) return;

  try {
    const res = await fetch(`${API_DOCENTE}/panel/${usuario.id}/alumnos-pendientes/${id}`, {
      method: "DELETE"
    });

    const data = await res.json();

    if (!res.ok) {
      throw new Error(data.message || "No se pudo eliminar el pendiente");
    }

    await cargarPanelDocente();
  } catch (error) {
    console.error("Error al eliminar pendiente:", error);
    alert(error.message);
  }
}

/* =========================
   RESULTADOS
========================= */
function renderizarResultadosInicio(resultados) {
  const tbody = document.getElementById("tablaResultadosBody");
  if (!tbody) return;

  tbody.innerHTML = "";

  if (!Array.isArray(resultados) || resultados.length === 0) {
    tbody.innerHTML = `<tr><td colspan="5">No hay resultados registrados</td></tr>`;
    return;
  }

  resultados.forEach((r) => {
    const tr = document.createElement("tr");
    tr.innerHTML = `
      <td>${escaparHTML(`${r.nombre} ${r.apellido}`)}</td>
      <td>${escaparHTML(r.titulo)}</td>
      <td>${escaparHTML(r.puntaje)}</td>
      <td>${r.aprobado ? "Aprobado" : "Reprobado"}</td>
      <td>${formatearFecha(r.creado_en)}</td>
    `;
    tbody.appendChild(tr);
  });
}

function renderizarResultadosResumen(resultados) {
  const tbody = document.getElementById("tablaResultadosResumenBody");
  if (!tbody) return;

  tbody.innerHTML = "";

  if (!Array.isArray(resultados) || resultados.length === 0) {
    tbody.innerHTML = `<tr><td colspan="5">No hay resultados disponibles</td></tr>`;
    return;
  }

  resultados.forEach((r) => {
    const tr = document.createElement("tr");
    tr.innerHTML = `
      <td>${escaparHTML(`${r.nombre} ${r.apellido}`)}</td>
      <td>${escaparHTML(r.titulo)}</td>
      <td>${escaparHTML(r.puntaje)}</td>
      <td>${r.aprobado ? "Aprobado" : "Reprobado"}</td>
      <td>${formatearFecha(r.creado_en)}</td>
    `;
    tbody.appendChild(tr);
  });
}

/* =========================
   ESTADÍSTICAS
========================= */
function renderizarEstadisticasDocente() {
  if (typeof Chart === "undefined") return;

  const canvasBarras = document.getElementById("graficoDocenteBarras");
  const canvasPie = document.getElementById("graficoDocentePie");
  const canvasLineas = document.getElementById("graficoDocenteLineas");

  if (!canvasBarras || !canvasPie || !canvasLineas) return;

  destruirGraficosDocente();

  /* ---- BARRAS: promedio por alumno ---- */
  const mapaResultados = {};

  alumnosCursoGlobal.forEach((a) => {
    mapaResultados[a.id] = {
      nombre: a.nombre_completo,
      total: 0,
      cantidad: 0
    };
  });

  resultadosCursoGlobal.forEach((r) => {
    if (!mapaResultados[r.alumno_id]) {
      mapaResultados[r.alumno_id] = {
        nombre: `${r.nombre} ${r.apellido}`,
        total: 0,
        cantidad: 0
      };
    }

    mapaResultados[r.alumno_id].total += Number(r.puntaje || 0);
    mapaResultados[r.alumno_id].cantidad += 1;
  });

  const barrasLabels = Object.values(mapaResultados).map((x) => x.nombre);
  const barrasData = Object.values(mapaResultados).map((x) =>
    x.cantidad > 0 ? Number((x.total / x.cantidad).toFixed(2)) : 0
  );

  graficoDocenteBarras = new Chart(canvasBarras, {
    type: "bar",
    data: {
      labels: barrasLabels,
      datasets: [
        {
          label: "Promedio de puntaje",
          data: barrasData,
          borderWidth: 1
        }
      ]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          display: true
        }
      },
      scales: {
        y: {
          beginAtZero: true,
          max: 100
        }
      }
    }
  });

  /* ---- PIE: estados de lectura ---- */
  const completados = alumnosCursoGlobal.filter((a) => Number(a.porcentaje_avance || 0) >= 100).length;
  const enProgreso = alumnosCursoGlobal.filter((a) => {
    const p = Number(a.porcentaje_avance || 0);
    return p > 0 && p < 100;
  }).length;
  const sinIniciar = alumnosCursoGlobal.filter((a) => Number(a.porcentaje_avance || 0) === 0).length;

  graficoDocentePie = new Chart(canvasPie, {
    type: "pie",
    data: {
      labels: ["Completado", "En progreso", "Sin iniciar"],
      datasets: [
        {
          data: [completados, enProgreso, sinIniciar]
        }
      ]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false
    }
  });

  /* ---- LÍNEAS: resultados por día ---- */
  const mapaDias = {};
  resultadosCursoGlobal.forEach((r) => {
    const fecha = obtenerFechaISO(r.creado_en);
    if (!fecha) return;
    mapaDias[fecha] = (mapaDias[fecha] || 0) + 1;
  });

  const lineasLabels = Object.keys(mapaDias).sort();
  const lineasData = lineasLabels.map((f) => mapaDias[f]);

  graficoDocenteLineas = new Chart(canvasLineas, {
    type: "line",
    data: {
      labels: lineasLabels.length ? lineasLabels : ["Sin datos"],
      datasets: [
        {
          label: "Evaluaciones registradas",
          data: lineasLabels.length ? lineasData : [0],
          tension: 0.3,
          fill: false
        }
      ]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false
    }
  });
}

/* =========================
   FILTROS RESULTADOS
========================= */
function configurarFiltrosResultados() {
  const filtroEstudiante = document.getElementById("filtroEstudiante");
  const filtroFechaResultado = document.getElementById("filtroFechaResultado");

  if (filtroEstudiante) {
    filtroEstudiante.addEventListener("input", aplicarFiltrosResultados);
  }

  if (filtroFechaResultado) {
    filtroFechaResultado.addEventListener("change", aplicarFiltrosResultados);
  }
}

function aplicarFiltrosResultados() {
  const filtroEstudiante = document.getElementById("filtroEstudiante")?.value.toLowerCase().trim() || "";
  const filtroFecha = document.getElementById("filtroFechaResultado")?.value || "";

  let filtrados = [...resultadosCursoGlobal];

  if (filtroEstudiante) {
    filtrados = filtrados.filter((r) =>
      `${r.nombre} ${r.apellido}`.toLowerCase().includes(filtroEstudiante)
    );
  }

  if (filtroFecha) {
    filtrados = filtrados.filter((r) => {
      const fecha = obtenerFechaISO(r.creado_en);
      return fecha === filtroFecha;
    });
  }

  renderizarResultadosResumen(filtrados);
}

/* =========================
   EXPORTAR RESULTADOS
========================= */
function exportarReporteDocente() {
  if (!Array.isArray(resultadosCursoGlobal) || resultadosCursoGlobal.length === 0) {
    alert("No hay datos para exportar");
    return;
  }

  let csv = "Alumno,Lectura,Puntaje,Estado,Fecha\n";

  resultadosCursoGlobal.forEach((r) => {
    csv += `"${r.nombre} ${r.apellido}","${r.titulo}",${r.puntaje},"${r.aprobado ? "Aprobado" : "Reprobado"}","${formatearFecha(r.creado_en)}"\n`;
  });

  const blob = new Blob([csv], { type: "text/csv;charset=utf-8;" });
  const link = document.createElement("a");
  link.href = URL.createObjectURL(blob);
  link.download = "reporte_docente.csv";
  link.click();
}

/* =========================
   LECTURAS - CURSOS
========================= */
async function cargarCursosLectura() {
  const select = document.getElementById("selectCursoLectura");
  if (!select) return;

  try {
    const res = await fetch(`${API_LECTURAS}/cursos`);
    const cursos = await res.json();

    select.innerHTML = `<option value="">Seleccionar curso</option>`;

    if (!res.ok) {
      throw new Error(cursos.message || "No se pudieron cargar los cursos");
    }

    cursos.forEach((curso) => {
      const option = document.createElement("option");
      option.value = curso.id;
      option.textContent = `${curso.nombre} - ${curso.profesor_nombre || ""} ${curso.profesor_apellido || ""}`.trim();
      select.appendChild(option);
    });
  } catch (error) {
    console.error("Error cargando cursos para lectura:", error);
    select.innerHTML = `<option value="">No se pudieron cargar cursos</option>`;
  }
}

/* =========================
   LECTURAS - CREAR / ACTUALIZAR
========================= */
async function guardarLectura() {
  const curso_id = document.getElementById("selectCursoLectura")?.value;
  const titulo = document.getElementById("tituloLectura")?.value.trim();
  const autor = document.getElementById("autorLectura")?.value.trim();
  const nivel = document.getElementById("nivelLectura")?.value.trim();
  const contenido = document.getElementById("textoLectura")?.value.trim();
  const mensaje = document.getElementById("mensajeLecturaDocente");

  if (!titulo || !nivel || !contenido) {
    if (mensaje) {
      mensaje.textContent = "Debes completar todos los campos";
      mensaje.style.color = "red";
    } else {
      alert("Debes completar todos los campos");
    }
    return;
  }

  if (!lecturaEditandoId && !curso_id) {
    if (mensaje) {
      mensaje.textContent = "Debes seleccionar un curso";
      mensaje.style.color = "red";
    } else {
      alert("Debes seleccionar un curso");
    }
    return;
  }

  try {
    let res;
    let data;

    if (lecturaEditandoId) {
      res = await fetch(`${API_LECTURAS}/${usuario.id}/lecturas/${lecturaEditandoId}`, {
        method: "PUT",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify({
          titulo,
          autor,
          nivel_dificultad: nivel,
          contenido
        })
      });

      data = await res.json();

      if (!res.ok) {
        throw new Error(data.message || "No se pudo actualizar la lectura");
      }

      if (mensaje) {
        mensaje.textContent = "Lectura actualizada correctamente";
        mensaje.style.color = "green";
      }
    } else {
      res = await fetch(`${API_LECTURAS}/${usuario.id}/lecturas`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify({
          titulo,
          autor,
          nivel_dificultad: nivel,
          contenido,
          curso_id
        })
      });

      data = await res.json();

      if (!res.ok) {
        throw new Error(data.message || "No se pudo crear la lectura");
      }

      if (mensaje) {
        mensaje.textContent = `Lectura creada y asignada a ${data.total_asignados} alumnos`;
        mensaje.style.color = "green";
      }
    }

    limpiarFormularioLectura();
    await cargarLecturasDocente();
    await cargarPanelDocente();
  } catch (error) {
    console.error("Error al guardar lectura:", error);
    if (mensaje) {
      mensaje.textContent = error.message;
      mensaje.style.color = "red";
    } else {
      alert(error.message);
    }
  }
}

function limpiarFormularioLectura() {
  const selectCurso = document.getElementById("selectCursoLectura");
  const titulo = document.getElementById("tituloLectura");
  const autor = document.getElementById("autorLectura");
  const nivel = document.getElementById("nivelLectura");
  const categoria = document.getElementById("categoriaLectura");
  const texto = document.getElementById("textoLectura");
  const mensaje = document.getElementById("mensajeLecturaDocente");

  if (selectCurso) selectCurso.value = "";
  if (titulo) titulo.value = "";
  if (autor) autor.value = "";
  if (nivel) nivel.value = "";
  if (categoria) categoria.value = "";
  if (texto) texto.value = "";
  if (mensaje) {
    mensaje.textContent = "";
    mensaje.style.color = "";
  }

  lecturaEditandoId = null;
}

/* =========================
   LECTURAS - LISTAR
========================= */
async function cargarLecturasDocente() {
  const tbody = document.getElementById("tablaLecturasBody");
  if (!tbody) return;

  try {
    const res = await fetch(`${API_LECTURAS}/${usuario.id}/lecturas`);
    const data = await res.json();

    if (!res.ok) {
      throw new Error(data.message || "No se pudieron cargar las lecturas");
    }

    lecturasDocenteGlobal = Array.isArray(data) ? data : [];
    renderizarTablaLecturas(lecturasDocenteGlobal);
  } catch (error) {
    console.error("Error al cargar lecturas:", error);
    tbody.innerHTML = `<tr><td colspan="6">No se pudieron cargar las lecturas</td></tr>`;
  }
}

function renderizarTablaLecturas(lecturas) {
  const tbody = document.getElementById("tablaLecturasBody");
  if (!tbody) return;

  tbody.innerHTML = "";

  if (!Array.isArray(lecturas) || lecturas.length === 0) {
    tbody.innerHTML = `<tr><td colspan="6">No hay lecturas registradas</td></tr>`;
    return;
  }

  lecturas.forEach((l) => {
    const tr = document.createElement("tr");
    tr.innerHTML = `
      <td>${escaparHTML(l.titulo)}</td>
      <td>${escaparHTML(l.autor)}</td>
      <td>${escaparHTML(l.nivel_dificultad)}</td>
      <td>No definida</td>
      <td>${escaparHTML(l.total_asignaciones)}</td>
      <td>
        <button type="button" class="btn-table" onclick="editarLectura(${l.id})">Editar</button>
        <button type="button" class="btn-table btn-danger" onclick="eliminarLectura(${l.id})">Eliminar</button>
      </td>
    `;
    tbody.appendChild(tr);
  });
}

function editarLectura(id) {
  const lectura = lecturasDocenteGlobal.find((l) => Number(l.id) === Number(id));
  if (!lectura) return;

  const titulo = document.getElementById("tituloLectura");
  const autor = document.getElementById("autorLectura");
  const nivel = document.getElementById("nivelLectura");
  const categoria = document.getElementById("categoriaLectura");
  const texto = document.getElementById("textoLectura");
  const mensaje = document.getElementById("mensajeLecturaDocente");

  if (titulo) titulo.value = lectura.titulo || "";
  if (autor) autor.value = lectura.autor || "";
  if (nivel) nivel.value = lectura.nivel_dificultad || "";
  if (categoria) categoria.value = "";
  if (texto) texto.value = lectura.contenido || "";

  lecturaEditandoId = lectura.id;

  if (mensaje) {
    mensaje.textContent = `Editando lectura: ${lectura.titulo}`;
    mensaje.style.color = "#2b4c7e";
  }

  mostrarSeccionDocente("lecturas", document.querySelectorAll(".menu-link")[1] || null);
  window.scrollTo({ top: 0, behavior: "smooth" });
}

async function eliminarLectura(id) {
  const confirmar = confirm("¿Eliminar esta lectura?");
  if (!confirmar) return;

  try {
    const res = await fetch(`${API_LECTURAS}/${usuario.id}/lecturas/${id}`, {
      method: "DELETE"
    });

    const data = await res.json();

    if (!res.ok) {
      throw new Error(data.message || "No se pudo eliminar la lectura");
    }

    await cargarLecturasDocente();
    await cargarPanelDocente();
  } catch (error) {
    console.error("Error al eliminar lectura:", error);
    alert(error.message);
  }
}

/* =========================
   FUNCIONES PLACEHOLDER
========================= */
function guardarPregunta() {
  alert("Función de guardar pregunta pendiente de conexión con backend.");
}

function limpiarFormularioPregunta() {
  const lectura = document.getElementById("lecturaRelacionada");
  const tipo = document.getElementById("tipoPregunta");
  const texto = document.getElementById("textoPregunta");
  const r1 = document.getElementById("respuesta1");
  const r2 = document.getElementById("respuesta2");
  const r3 = document.getElementById("respuesta3");

  if (lectura) lectura.value = "";
  if (tipo) tipo.value = "opcion_multiple";
  if (texto) texto.value = "";
  if (r1) r1.value = "";
  if (r2) r2.value = "";
  if (r3) r3.value = "";
}

/* =========================
   LOGOUT
========================= */
function logout() {
  localStorage.removeItem("usuario");
  window.location.href = "login.html";
}

/* =========================
   INIT
========================= */
document.addEventListener("DOMContentLoaded", () => {
  configurarFiltrosResultados();
  cargarPanelDocente();
  cargarCursosLectura();
  cargarLecturasDocente();
  mostrarSeccionDocente("inicio", document.querySelector(".menu-link.active"));
});