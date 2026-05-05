const usuario = JSON.parse(localStorage.getItem("usuario"));

let usuariosGlobal = [];
let auditoriaGlobal = [];
let graficoActividad = null;
let graficoRoles = null;

if (!usuario || usuario.rol !== "admin") {
  alert("Acceso no autorizado");
  window.location.href = "index.html";
}

async function cargarResumenSistema() {
  try {
    const res = await fetch("https://caza-libros.onrender.com/api/admin/resumen");
    const data = await res.json();

    document.getElementById("cantidadUsuarios").textContent = data.total_usuarios ?? 0;
    document.getElementById("usuariosActivos").textContent = data.total_alumnos ?? 0;
    document.getElementById("nuevosRegistros").textContent = data.nuevos_registros ?? 0;
  } catch (error) {
    console.error("Error al cargar resumen:", error);
  }
}

async function cargarAlertasSistema() {
  try {
    const res = await fetch("https://caza-libros.onrender.com/api/admin/alertas");
    const data = await res.json();

    const lista = document.getElementById("listaAlertas");
    if (!lista) return;

    lista.innerHTML = "";

    if (!Array.isArray(data) || data.length === 0) {
      lista.innerHTML = `<div class="alert-row">No hay alertas registradas</div>`;
      return;
    }

    data.forEach((item) => {
      const div = document.createElement("div");
      div.className = "alert-row";
      div.textContent = item.detalle;
      lista.appendChild(div);
    });
  } catch (error) {
    console.error("Error al cargar alertas:", error);
  }
}

async function cargarUsuarios() {
  try {
    const res = await fetch("https://caza-libros.onrender.com/api/admin/usuarios");
    const data = await res.json();

    usuariosGlobal = Array.isArray(data) ? data : [];
    renderizarUsuarios(usuariosGlobal);
    cargarFiltroCursosAdmin();
    cargarCursosAlumnoAdmin();
  } catch (error) {
    console.error("Error al cargar usuarios:", error);
  }
}

function renderizarUsuarios(listaUsuarios) {
  const tbody = document.getElementById("tablaUsuariosBody");
  if (!tbody) return;

  tbody.innerHTML = "";

  if (!Array.isArray(listaUsuarios) || listaUsuarios.length === 0) {
    tbody.innerHTML = `<tr><td colspan="8">No hay usuarios registrados</td></tr>`;
    return;
  }

  listaUsuarios.forEach((u) => {
    const tr = document.createElement("tr");

    tr.innerHTML = `
      <td>${u.id}</td>
      <td>${u.nombre} ${u.apellido}</td>
      <td>${u.correo}</td>
      <td>${u.rol}</td>
      <td>${u.asignatura || "-"}</td>
      <td>${u.rol === "alumno" ? (u.curso_matriculado || "Sin curso") : (u.curso || "-")}</td>
      <td>${u.es_profesor_jefe ? "Sí" : "No"}</td>
      <td>
      <button type="button" class="btn-table" onclick="editarUsuario(${u.id})">
          Editar
        </button>

        ${
          u.rol === "alumno"
            ? `<button type="button" class="btn-table" style="background:#f59e0b; color:white;" onclick="resetearAlumno(${u.id})">
                Resetear
              </button>`
            : ""
        }

        <button type="button" class="btn-table btn-danger" onclick="eliminarUsuario(${u.id})">
          Eliminar
        </button>
      </td>
    `;

    tbody.appendChild(tr);
  });
}

function cargarFiltroCursosAdmin() {
  const select = document.getElementById("filtroCursoAdmin");
  if (!select) return;

  const cursos = [
    ...new Set(
      usuariosGlobal
        .map((u) => (u.rol === "alumno" ? u.curso_matriculado : u.curso))
        .filter(Boolean)
    )
  ];

  select.innerHTML = `
    <option value="">Todos los cursos</option>
    <option value="sin_curso">Sin curso</option>
  `;

  cursos.forEach((curso) => {
    const option = document.createElement("option");
    option.value = curso;
    option.textContent = curso;
    select.appendChild(option);
  });
}

async function cargarCursosAlumnoAdmin() {
  const select = document.getElementById("cursoAlumnoAdmin");
  if (!select) return;

  try {
    const res = await fetch("https://caza-libros.onrender.com/api/docente-lecturas/cursos");
    const cursos = await res.json();

    select.innerHTML = `<option value="">Seleccionar curso del alumno</option>`;

    cursos.forEach((c) => {
      const option = document.createElement("option");
      option.value = c.id;
      option.textContent = `${c.nombre} - ${c.nivel} (${c.anio})`;
      select.appendChild(option);
    });
  } catch (error) {
    console.error("Error cargando cursos alumno:", error);
    select.innerHTML = `<option value="">No se pudieron cargar cursos</option>`;
  }
}

function abrirFormularioNuevoUsuario() {
  document.getElementById("formUsuarioContainer").classList.remove("hidden");
  document.getElementById("tituloFormularioUsuario").textContent = "Nuevo usuario";

  document.getElementById("usuarioId").value = "";
  document.getElementById("nombreUsuario").value = "";
  document.getElementById("apellidoUsuario").value = "";
  document.getElementById("correoUsuario").value = "";
  document.getElementById("passwordUsuario").value = "";
  document.getElementById("passwordUsuario").style.display = "block";
  document.getElementById("rolUsuario").value = "alumno";

  document.getElementById("asignaturaUsuario").value = "";
  document.getElementById("cursoUsuario").value = "";
  document.getElementById("jefeUsuario").checked = false;

  document.getElementById("camposDocente").classList.add("hidden");
  document.getElementById("camposAlumno").classList.remove("hidden");
  document.getElementById("cursoAlumnoAdmin").value = "";
}

function cerrarFormularioUsuario() {
  document.getElementById("formUsuarioContainer").classList.add("hidden");
}

function editarUsuario(id) {
  const usuarioEditar = usuariosGlobal.find((u) => Number(u.id) === Number(id));
  if (!usuarioEditar) return;

  document.getElementById("formUsuarioContainer").classList.remove("hidden");
  document.getElementById("tituloFormularioUsuario").textContent = "Editar usuario";

  document.getElementById("usuarioId").value = usuarioEditar.id;
  document.getElementById("nombreUsuario").value = usuarioEditar.nombre || "";
  document.getElementById("apellidoUsuario").value = usuarioEditar.apellido || "";
  document.getElementById("correoUsuario").value = usuarioEditar.correo || "";
  document.getElementById("rolUsuario").value = usuarioEditar.rol || "alumno";

  document.getElementById("passwordUsuario").value = "";
  document.getElementById("passwordUsuario").style.display = "none";

  document.getElementById("asignaturaUsuario").value = usuarioEditar.asignatura || "";
  document.getElementById("cursoUsuario").value = usuarioEditar.curso || "";
  document.getElementById("jefeUsuario").checked = usuarioEditar.es_profesor_jefe || false;

  const camposDocente = document.getElementById("camposDocente");
  const camposAlumno = document.getElementById("camposAlumno");
  const selectCursoAlumno = document.getElementById("cursoAlumnoAdmin");

  if (usuarioEditar.rol === "docente") {
    camposDocente.classList.remove("hidden");
    camposAlumno.classList.add("hidden");
  } else if (usuarioEditar.rol === "alumno") {
    camposAlumno.classList.remove("hidden");
    camposDocente.classList.add("hidden");

    if (selectCursoAlumno) {
      setTimeout(() => {
    selectCursoAlumno.value = usuarioEditar.curso_id || "";
      }, 200);
    }
  } else {
    camposAlumno.classList.add("hidden");
    camposDocente.classList.add("hidden");
  }
}

async function guardarUsuario() {
  const id = document.getElementById("usuarioId").value;
  const nombre = document.getElementById("nombreUsuario").value.trim();
  const apellido = document.getElementById("apellidoUsuario").value.trim();
  const correo = document.getElementById("correoUsuario").value.trim();
  const password = document.getElementById("passwordUsuario").value;
  const rol = document.getElementById("rolUsuario").value;

  const asignatura = document.getElementById("asignaturaUsuario").value.trim();
  const curso = document.getElementById("cursoUsuario").value.trim();
  const es_profesor_jefe = document.getElementById("jefeUsuario").checked;
  const curso_id = document.getElementById("cursoAlumnoAdmin")?.value || null;

  try {
    let response;

    const bodyData = {
      nombre,
      apellido,
      correo,
      rol,
      asignatura,
      curso,
      es_profesor_jefe,
      curso_id
    };

    if (!id) {
      bodyData.password = password;
    }

    if (id) {
      response = await fetch(`https://caza-libros.onrender.com/api/admin/usuarios/${id}`, {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(bodyData)
      });
    } else {
      response = await fetch("https://caza-libros.onrender.com/api/admin/usuarios", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(bodyData)
      });
    }

    const data = await response.json();

    if (!response.ok) {
      alert(data.message || "No se pudo guardar el usuario");
      return;
    }

    cerrarFormularioUsuario();

    await cargarUsuarios();
    await cargarResumenSistema();
    await cargarAlertasSistema();
    await cargarAuditoria();
    await cargarResumenReportes();
    await cargarGraficoActividad();
    await cargarGraficoRoles();
  } catch (error) {
    console.error("Error al guardar usuario:", error);
  }
}

async function eliminarUsuario(id) {
  if (usuario && Number(usuario.id) === Number(id)) {
    alert("No puedes eliminar tu propio usuario");
    return;
  }

  const confirmar = confirm("¿Seguro que deseas eliminar este usuario?");
  if (!confirmar) return;

  try {
    const response = await fetch(`https://caza-libros.onrender.com/api/admin/usuarios/${id}`, {
      method: "DELETE"
    });

    const data = await response.json();

    if (!response.ok) {
      alert(data.message || "No se pudo eliminar el usuario");
      return;
    }

    await cargarUsuarios();
    await cargarResumenSistema();
    await cargarAlertasSistema();
    await cargarAuditoria();
    await cargarResumenReportes();
    await cargarGraficoActividad();
    await cargarGraficoRoles();
  } catch (error) {
    console.error("Error al eliminar usuario:", error);
  }
}

function filtrarUsuarios() {
  const input = document.getElementById("buscadorUsuarios");
  const filtroCurso = document.getElementById("filtroCursoAdmin")?.value || "";

  if (!input) return;

  const texto = input.value.toLowerCase().trim();

  const filtrados = usuariosGlobal.filter((u) => {
    const nombreCompleto = `${u.nombre} ${u.apellido}`.toLowerCase();

    const cursoReal = u.rol === "alumno"
      ? (u.curso_matriculado || "")
      : (u.curso || "");

    const cumpleCurso =
      filtroCurso === "" ||
      (filtroCurso === "sin_curso" && !cursoReal) ||
      cursoReal === filtroCurso;

    return (
      (
        nombreCompleto.includes(texto) ||
        u.correo.toLowerCase().includes(texto) ||
        u.rol.toLowerCase().includes(texto) ||
        (u.asignatura || "").toLowerCase().includes(texto) ||
        cursoReal.toLowerCase().includes(texto)
      ) &&
      cumpleCurso
    );
  });

  renderizarUsuarios(filtrados);
}

async function cargarAuditoria() {
  try {
    const res = await fetch("https://caza-libros.onrender.com/api/admin/auditoria");
    const data = await res.json();

    auditoriaGlobal = Array.isArray(data) ? data : [];
    renderizarAuditoria(auditoriaGlobal);
  } catch (error) {
    console.error("Error al cargar auditoría:", error);
  }
}

function renderizarAuditoria(lista) {
  const tbody = document.getElementById("tablaAuditoriaBody");
  if (!tbody) return;

  tbody.innerHTML = "";

  if (!Array.isArray(lista) || lista.length === 0) {
    tbody.innerHTML = `<tr><td colspan="5">No hay registros de auditoría</td></tr>`;
    return;
  }

  lista.forEach((item) => {
    const fechaObj = item.fecha_hora ? new Date(item.fecha_hora) : null;
    const fecha = fechaObj ? fechaObj.toLocaleDateString() : "-";
    const hora = fechaObj ? fechaObj.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" }) : "-";
    const nombreUsuario = item.nombre ? `${item.nombre} ${item.apellido || ""}`.trim() : "Sistema";

    const tr = document.createElement("tr");

    tr.innerHTML = `
      <td>${nombreUsuario}</td>
      <td>${item.tipo_evento || "-"}</td>
      <td>${fecha}</td>
      <td>${hora}</td>
      <td>${item.detalle || "-"}</td>
    `;

    tbody.appendChild(tr);
  });
}

function filtrarAuditoria() {
  const inputUsuario = document.getElementById("filtroAuditoriaUsuario");
  const inputAccion = document.getElementById("filtroAuditoriaAccion");
  const inputFecha = document.getElementById("filtroAuditoriaFecha");

  if (!inputUsuario || !inputAccion || !inputFecha) return;

  const filtroUsuario = inputUsuario.value.toLowerCase().trim();
  const filtroAccion = inputAccion.value.toLowerCase().trim();
  const filtroFecha = inputFecha.value;

  const filtrados = auditoriaGlobal.filter((item) => {
    const nombreUsuario = item.nombre ? `${item.nombre} ${item.apellido || ""}`.toLowerCase() : "sistema";
    const accion = (item.tipo_evento || "").toLowerCase();
    const fecha = item.fecha_hora ? new Date(item.fecha_hora).toISOString().split("T")[0] : "";

    return (
      nombreUsuario.includes(filtroUsuario) &&
      accion.includes(filtroAccion) &&
      (filtroFecha === "" || fecha === filtroFecha)
    );
  });

  renderizarAuditoria(filtrados);
}

async function cargarResumenReportes() {
  try {
    const res = await fetch("https://caza-libros.onrender.com/api/admin/reportes");
    const data = await res.json();

    document.getElementById("reporteUsuariosActivos").textContent = data.total_usuarios ?? 0;
    document.getElementById("reporteLecturasCompletadas").textContent = data.total_lecturas_completadas ?? 0;
    document.getElementById("reporteCuestionarios").textContent = data.total_cuestionarios ?? 0;
    document.getElementById("reporteRendimiento").textContent = `${Math.round(data.rendimiento_general ?? 0)}%`;
  } catch (error) {
    console.error("Error al cargar reportes:", error);
  }
}

async function cargarGraficoActividad() {
  try {
    const res = await fetch("https://caza-libros.onrender.com/api/admin/actividad");
    const data = await res.json();

    const labels = data.map((d) => d.fecha || "Sin fecha");
    const valores = data.map((d) => Number(d.total_eventos) || 0);

    const canvas = document.getElementById("graficoActividad");
    if (!canvas) return;

    const ctx = canvas.getContext("2d");

    if (graficoActividad) {
      graficoActividad.destroy();
    }

    graficoActividad = new Chart(ctx, {
      type: "line",
      data: {
        labels,
        datasets: [
          {
            label: "Eventos del sistema",
            data: valores,
            tension: 0.4,
            fill: true,
            backgroundColor: "rgba(91, 100, 245, 0.18)",
            borderColor: "#5b64f5",
            borderWidth: 3,
            pointRadius: 4
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false
      }
    });
  } catch (error) {
    console.error("Error gráfico actividad:", error);
  }
}

async function cargarGraficoRoles() {
  try {
    const res = await fetch("https://caza-libros.onrender.com/api/admin/usuarios");
    const data = await res.json();

    const conteo = { alumno: 0, docente: 0, admin: 0 };

    data.forEach((u) => {
      if (conteo[u.rol] !== undefined) {
        conteo[u.rol]++;
      }
    });

    const canvas = document.getElementById("graficoRoles");
    if (!canvas) return;

    const ctx = canvas.getContext("2d");

    if (graficoRoles) {
      graficoRoles.destroy();
    }

    graficoRoles = new Chart(ctx, {
      type: "pie",
      data: {
        labels: ["Alumnos", "Docentes", "Administradores"],
        datasets: [
          {
            data: [conteo.alumno, conteo.docente, conteo.admin],
            backgroundColor: ["#5b64f5", "#8fa1c7", "#4e56b5"]
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false
      }
    });
  } catch (error) {
    console.error("Error gráfico roles:", error);
  }
}

function exportarAuditoria() {
  window.open("https://caza-libros.onrender.com/api/admin/auditoria/exportar", "_blank");
}

function respaldarSistema() {
  const estado = document.getElementById("estadoRespaldo");

  if (estado) {
    estado.textContent = "Generando respaldo...";
  }

  window.open("https://caza-libros.onrender.com/api/admin/backup", "_blank");

  setTimeout(() => {
    if (estado) {
      estado.textContent = "Respaldo descargado correctamente.";
    }
  }, 1000);
}

async function verificarSeguridad() {
  const estado = document.getElementById("estadoSeguridad");
  const detalle = document.getElementById("detalleSeguridad");

  try {
    if (estado) {
      estado.textContent = "Verificando...";
    }

    const res = await fetch("https://caza-libros.onrender.com/api/admin/seguridad/verificar");
    const data = await res.json();

    if (!res.ok) {
      throw new Error(data.message || "No se pudo verificar la seguridad");
    }

    if (estado) {
      estado.textContent = `${data.estado} (${data.total_problemas} observación/es)`;
    }

    if (detalle) {
      detalle.classList.remove("hidden");
      detalle.innerHTML = `
        <h3>Resultado de verificación</h3>
        <p><strong>Estado:</strong> ${data.estado}</p>
        <p><strong>Total de problemas detectados:</strong> ${data.total_problemas}</p>
        <ul>
          <li>Correos duplicados: ${data.detalle.correos_duplicados.length}</li>
          <li>Usuarios sin rol: ${data.detalle.usuarios_sin_rol.length}</li>
          <li>Intentos huérfanos: ${data.detalle.intentos_huerfanos.length}</li>
          <li>Eventos huérfanos: ${data.detalle.eventos_huerfanos.length}</li>
        </ul>
      `;
    }
  } catch (error) {
    console.error("Error al verificar seguridad:", error);

    if (estado) {
      estado.textContent = "Error al verificar seguridad";
    }

    if (detalle) {
      detalle.classList.remove("hidden");
      detalle.innerHTML = `<p>No fue posible completar la verificación.</p>`;
    }
  }
}

function logout() {
  localStorage.removeItem("usuario");
  window.location.href = "login.html";
}

function mostrarSeccion(seccion, element) {
  const secciones = {
    panel: document.getElementById("seccion-panel"),
    usuarios: document.getElementById("seccion-usuarios"),
    auditoria: document.getElementById("seccion-auditoria"),
    reportes: document.getElementById("seccion-reportes"),
    seguridad: document.getElementById("seccion-seguridad")
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

  if (seccion === "reportes") {
    cargarGraficoActividad();
    cargarGraficoRoles();
    cargarResumenReportes();
  }
}

async function resetearAlumno(id) {
  const confirmar = confirm("¿Seguro que quieres borrar TODO el progreso, puntos y evaluaciones de este alumno?");
  if (!confirmar) return;

  try {
    const res = await fetch(`https://caza-libros.onrender.com/api/admin/usuarios/${id}/reset`, {
      method: "DELETE"
    });

    const data = await res.json();

    if (!res.ok) {
      alert(data.message || "No se pudo resetear el alumno");
      return;
    }

    alert("Alumno reseteado correctamente");

    await cargarUsuarios();
    await cargarResumenSistema();
    await cargarAuditoria();
    await cargarResumenReportes();
  } catch (error) {
    console.error(error);
    alert("Error al resetear alumno");
  }
}

document.addEventListener("DOMContentLoaded", () => {
  const nombreAdmin = document.getElementById("nombreAdmin");

  if (nombreAdmin && usuario) {
    nombreAdmin.textContent = usuario.nombre;
  }

  const buscador = document.getElementById("buscadorUsuarios");
  if (buscador) {
    buscador.addEventListener("input", filtrarUsuarios);
  }

  const filtroCurso = document.getElementById("filtroCursoAdmin");
  if (filtroCurso) {
    filtroCurso.addEventListener("change", filtrarUsuarios);
  }

  const filtroUsuario = document.getElementById("filtroAuditoriaUsuario");
  const filtroAccion = document.getElementById("filtroAuditoriaAccion");
  const filtroFecha = document.getElementById("filtroAuditoriaFecha");

  if (filtroUsuario) filtroUsuario.addEventListener("input", filtrarAuditoria);
  if (filtroAccion) filtroAccion.addEventListener("input", filtrarAuditoria);
  if (filtroFecha) filtroFecha.addEventListener("input", filtrarAuditoria);

  const rolUsuario = document.getElementById("rolUsuario");
  if (rolUsuario) {
    rolUsuario.addEventListener("change", function () {
      const camposDocente = document.getElementById("camposDocente");
      const camposAlumno = document.getElementById("camposAlumno");

      if (this.value === "docente") {
        camposDocente.classList.remove("hidden");
        camposAlumno.classList.add("hidden");
      } else if (this.value === "alumno") {
        camposAlumno.classList.remove("hidden");
        camposDocente.classList.add("hidden");

        document.getElementById("asignaturaUsuario").value = "";
        document.getElementById("cursoUsuario").value = "";
        document.getElementById("jefeUsuario").checked = false;
      } else {
        camposAlumno.classList.add("hidden");
        camposDocente.classList.add("hidden");

        document.getElementById("asignaturaUsuario").value = "";
        document.getElementById("cursoUsuario").value = "";
        document.getElementById("jefeUsuario").checked = false;
        document.getElementById("cursoAlumnoAdmin").value = "";
      }
    });
  }

  cargarResumenSistema();
  cargarAlertasSistema();
  cargarCursosAlumnoAdmin();
  cargarUsuarios();
  cargarAuditoria();
  cargarResumenReportes();
  
  mostrarSeccion("panel", document.querySelector(".menu-link.active"));
});