const usuario = JSON.parse(localStorage.getItem("usuario"));

if (!usuario || usuario.rol !== "alumno") {
  alert("Acceso no autorizado");
  window.location.href = "login.html";
}

const API_RESULTADOS = "http://localhost:3000/api/resultados";
const API_PUNTOS = "http://localhost:3000/api/puntos";
const API_EVALUACIONES = "http://localhost:3000/api/evaluaciones";
const API_ASIGNACIONES = "http://localhost:3000/api/asignaciones";
const API_PROGRESO = "http://localhost:3000/api/progreso";

let lecturaSeleccionada = null;
let timeoutGuardado = null;
let ultimoPorcentaje = -1;

/* =========================
   NAVEGACIÓN
========================= */
function mostrarSeccionAlumno(seccion, element) {
  const secciones = {
    inicio: document.getElementById("alumno-seccion-inicio"),
    lecturas: document.getElementById("alumno-seccion-lecturas"),
    lector: document.getElementById("alumno-seccion-lector"),
    progreso: document.getElementById("alumno-seccion-progreso"),
    resultados: document.getElementById("alumno-seccion-resultados"),
    puntos: document.getElementById("alumno-seccion-puntos")
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

  if (element) element.classList.add("active");
}

/* =========================
   BIENVENIDA
========================= */
function cargarBienvenidaAlumno() {
  const el = document.getElementById("bienvenidaAlumno");
  if (el) {
    el.textContent = `Bienvenido/a, ${usuario.nombre || ""} ${usuario.apellido || ""}`;
  }
}

/* =========================
   LECTURAS
========================= */
async function cargarLecturasAsignadas() {
  try {
    const res = await fetch(API_ASIGNACIONES);
    const data = await res.json();

    const lista = document.getElementById("listaLecturas");
    const cantidad = document.getElementById("cantidadLecturas");
    const cursoInfo = document.getElementById("cursoAlumnoInfo");

    if (!lista) return;
    lista.innerHTML = "";

    const lecturas = Array.isArray(data)
      ? data.filter((l) => Number(l.alumno_id) === Number(usuario.id))
      : [];

    if (cantidad) cantidad.textContent = lecturas.length;
        if (!lecturas.length) {
      lista.innerHTML = "<li>No tienes lecturas asignadas</li>";
      return;
    }

    const primera = lecturas[0];
    if (cursoInfo) {
      cursoInfo.textContent =
        `Curso: ${primera.curso_nombre || "Sin curso"} | Profesor jefe: ${primera.profesor_nombre || ""} ${primera.profesor_apellido || ""}`;
    }

    lecturas.forEach((l) => {
      const li = document.createElement("li");
      const btn = document.createElement("button");

      btn.textContent = `${l.titulo}${l.autor ? " - " + l.autor : ""}`;

      btn.onclick = () =>
        seleccionarLectura({
          id: l.lectura_id,
          titulo: l.titulo,
          autor: l.autor,
          contenido: l.contenido,
          curso_nombre: l.curso_nombre,
          profesor_nombre: l.profesor_nombre,
          profesor_apellido: l.profesor_apellido
        });

      li.appendChild(btn);
      lista.appendChild(li);
    });
  } catch (err) {
    console.error(err);
    alert("Error al cargar lecturas");
  }
}

/* =========================
   SELECCIONAR LECTURA
========================= */
function seleccionarLectura(lectura) {
  lecturaSeleccionada = lectura;
  ultimoPorcentaje = -1;

  const elLecturaTexto = document.getElementById("lecturaSeleccionadaTexto");
  const elLecturaProgreso = document.getElementById("lecturaSeleccionadaProgreso");
  const elTitulo = document.getElementById("tituloLecturaAbierta");
  const elMeta = document.getElementById("metaLecturaAbierta");
  const elContenido = document.getElementById("contenidoLecturaAbierta");
  const elCurso = document.getElementById("cursoAlumnoInfo");
  const wrapper = document.getElementById("contenidoLecturaWrapper");
  const inputLector = document.getElementById("porcentajeProgresoLector");

  if (elLecturaTexto) {
    elLecturaTexto.textContent = `Lectura seleccionada: ${lectura.titulo}`;
  }

  if (elLecturaProgreso) {
    elLecturaProgreso.textContent = `Lectura seleccionada: ${lectura.titulo}`;
  }

  if (elTitulo) elTitulo.textContent = lectura.titulo || "Sin título";
  if (elMeta) elMeta.textContent = `Autor: ${lectura.autor || "-"}`;
  if (elContenido) elContenido.textContent = lectura.contenido || "Sin contenido";
  if (elCurso) {
    elCurso.textContent = `Curso: ${lectura.curso_nombre || "Sin curso"} | Profesor jefe: ${lectura.profesor_nombre || ""} ${lectura.profesor_apellido || ""}`;
  }

  if (wrapper) {
    wrapper.scrollTop = 0;
    wrapper.removeEventListener("scroll", onScrollLectura);
    wrapper.addEventListener("scroll", onScrollLectura);
  }

  if (inputLector) inputLector.value = 0;

  actualizarBarra(0);
  cargarProgresoAlumno();

  const links = document.querySelectorAll(".menu-link");
  mostrarSeccionAlumno("lector", links[2] || null);
}

/* =========================
   SCROLL → PROGRESO
========================= */
function onScrollLectura() {
  const wrapper = document.getElementById("contenidoLecturaWrapper");
  if (!wrapper) return;

  const total = wrapper.scrollHeight - wrapper.clientHeight;

  if (total <= 0) {
    actualizarBarra(100);
    autoGuardar(100);
    return;
  }

  const porcentaje = (wrapper.scrollTop / total) * 100;
  actualizarBarra(porcentaje);
  autoGuardar(porcentaje);
}

/* =========================
   UI PROGRESO
========================= */
function actualizarBarra(porcentaje) {
  const barra = document.getElementById("barraProgresoLectura");
  const texto = document.getElementById("porcentajeLecturaTexto");
  const input = document.getElementById("porcentajeProgresoLector");

  const val = Math.max(0, Math.min(100, Math.round(porcentaje)));

  if (barra) barra.style.width = `${val}%`;
  if (texto) texto.textContent = `${val}%`;
  if (input) input.value = val;
}

/* =========================
   AUTO GUARDADO
========================= */
function autoGuardar(porcentaje) {
  const val = Math.max(0, Math.min(100, Math.round(porcentaje)));

  if (val === ultimoPorcentaje) return;

  clearTimeout(timeoutGuardado);

  timeoutGuardado = setTimeout(() => {
    guardarAutomatico(val);
  }, 1000);
}

async function guardarAutomatico(porcentaje) {
  if (!lecturaSeleccionada) return;

  try {
    const res = await fetch(API_PROGRESO, {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        alumno_id: usuario.id,
        lectura_id: lecturaSeleccionada.id,
        porcentaje_avance: porcentaje
      })
    });

    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      throw new Error(data.message || "No se pudo guardar el progreso");
    }

    ultimoPorcentaje = porcentaje;
    cargarProgresoAlumno();
  } catch (e) {
    console.error("Error guardado auto:", e);
  }
}

/* =========================
   PROGRESO MANUAL
========================= */
async function guardarProgreso() {
  if (!lecturaSeleccionada) {
    alert("Selecciona una lectura primero");
    return;
  }

  const input = document.getElementById("porcentajeProgreso");
  const porcentaje = Number(input?.value);

  if (Number.isNaN(porcentaje) || porcentaje < 0 || porcentaje > 100) {
    alert("Porcentaje inválido");
    return;
  }

  try {
    const res = await fetch(API_PROGRESO, {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        alumno_id: usuario.id,
        lectura_id: lecturaSeleccionada.id,
        porcentaje_avance: porcentaje
      })
    });

    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      throw new Error(data.message || "No se pudo guardar el progreso");
    }

    ultimoPorcentaje = Math.round(porcentaje);
    alert("Progreso guardado");
    cargarProgresoAlumno();
  } catch (error) {
    console.error(error);
    alert("Error al guardar progreso");
  }
}

async function guardarProgresoDesdeLector() {
  if (!lecturaSeleccionada) {
    alert("Selecciona una lectura");
    return;
  }

  const input = document.getElementById("porcentajeProgresoLector");
  const porcentaje = Number(input?.value);

  if (Number.isNaN(porcentaje) || porcentaje < 0 || porcentaje > 100) {
    alert("Porcentaje inválido");
    return;
  }

  try {
    const res = await fetch(API_PROGRESO, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        alumno_id: usuario.id,
        lectura_id: lecturaSeleccionada.id,
        porcentaje_avance: porcentaje
      })
    });

    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      throw new Error(data.message || "No se pudo guardar el progreso");
    }

    ultimoPorcentaje = Math.round(porcentaje);
    actualizarBarra(porcentaje);
    cargarProgresoAlumno();

    alert("Guardado ✔");
  } catch (e) {
    console.error(e);
    alert("Error al guardar");
  }
}

/* =========================
   VER PROGRESO GUARDADO
========================= */
async function cargarProgresoAlumno() {
  try {
    const res = await fetch(`${API_PROGRESO}/alumno/${usuario.id}`);
    const data = await res.json();

    const lista = document.getElementById("listaProgresoAlumno");
    if (!lista) return;

    lista.innerHTML = "";

    if (!Array.isArray(data) || data.length === 0) {
      lista.innerHTML = "<li>No hay progreso guardado</li>";
      return;
    }

    data.forEach((p) => {
      const li = document.createElement("li");
      li.textContent = `${p.titulo} - ${p.porcentaje_avance}%`;
      lista.appendChild(li);
    });

    if (lecturaSeleccionada) {
      const progresoLectura = data.find(
        (p) => Number(p.lectura_id) === Number(lecturaSeleccionada.id)
      );

      if (progresoLectura) {
        const porcentaje = Number(progresoLectura.porcentaje_avance || 0);
        ultimoPorcentaje = Math.round(porcentaje);
        actualizarBarra(porcentaje);

        const inputLector = document.getElementById("porcentajeProgresoLector");
        if (inputLector) inputLector.value = porcentaje;

        const inputManual = document.getElementById("porcentajeProgreso");
        if (inputManual) inputManual.value = porcentaje;
      }
    }
  } catch (error) {
    console.error("Error al cargar progreso:", error);
  }
}

/* =========================
   RESULTADOS
========================= */
async function cargarResultados() {
  try {
    const res = await fetch(`${API_RESULTADOS}/${usuario.id}`);
    const data = await res.json();

    const lista = document.getElementById("listaResultados");
    const cantidad = document.getElementById("cantidadResultadosAlumno");

    if (!lista) return;
    lista.innerHTML = "";

    if (cantidad) cantidad.textContent = Array.isArray(data) ? data.length : 0;

    if (!Array.isArray(data) || !data.length) {
      lista.innerHTML = "<li>No hay resultados</li>";
      return;
    }

    data.forEach((r) => {
      const li = document.createElement("li");
      li.textContent = `${r.titulo} - ${r.puntaje} pts - ${r.aprobado ? "✔" : "✘"}`;
      lista.appendChild(li);
    });
  } catch (e) {
    console.error(e);
  }
}

/* =========================
   PUNTOS
========================= */
async function cargarPuntos() {
  try {
    const res = await fetch(`${API_PUNTOS}/${usuario.id}`);
    const data = await res.json();

    const lista = document.getElementById("listaPuntos");
    const total = document.getElementById("totalPuntos");
    const totalCard = document.getElementById("totalPuntosCard");

    if (total) total.textContent = `Total puntos: ${data.total_puntos || 0}`;
    if (totalCard) totalCard.textContent = data.total_puntos || 0;

    if (!lista) return;
    lista.innerHTML = "";

    if (!data.movimientos?.length) {
      lista.innerHTML = "<li>No hay puntos</li>";
      return;
    }

    data.movimientos.forEach((m) => {
      const li = document.createElement("li");
      li.textContent = `${m.motivo} (${m.delta})`;
      lista.appendChild(li);
    });
  } catch (e) {
    console.error(e);
  }
}

/* =========================
   EVALUACIÓN
========================= */
async function responderEvaluacion() {
  if (!lecturaSeleccionada) {
    alert("Selecciona una lectura primero");
    return;
  }

  try {
    const res = await fetch(`${API_EVALUACIONES}/responder`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        alumno_id: usuario.id,
        lectura_id: lecturaSeleccionada.id,
        respuestas: [
          { pregunta_id: 1, opcion_id: 2 },
          { pregunta_id: 2, opcion_id: 3 }
        ]
      })
    });

    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      throw new Error(data.message || "Error al enviar evaluación");
    }

    alert("Evaluación enviada");
    cargarResultados();
    cargarPuntos();
  } catch (e) {
    console.error(e);
    alert("Error al enviar evaluación");
  }
}

/* =========================
   cargar cuestionarios para responder
========================= */

async function cargarCuestionariosAlumno() {
  try {
    const res = await fetch(`http://localhost:3000/api/evaluaciones/alumno/${usuario.id}/cuestionarios`);
    const cuestionarios = await res.json();

    const lista = document.getElementById("listaCuestionariosAlumno");
    lista.innerHTML = "";

    if (!cuestionarios.length) {
      lista.innerHTML = "<li>No tienes evaluaciones asignadas</li>";
      return;
    }

    cuestionarios.forEach(c => {
      const li = document.createElement("li");
      li.innerHTML = `
        <strong>${c.cuestionario_titulo}</strong><br>
        Lectura: ${c.lectura_titulo}<br>
        <button onclick="abrirCuestionario(${c.cuestionario_id})">
          Responder cuestionario
        </button>
      `;
      lista.appendChild(li);
    });

  } catch (error) {
    console.error(error);
  }
}

/* =========================
abrir cuestionario para responder
========================= */

async function abrirCuestionario(id) {
  try {
    const res = await fetch(`http://localhost:3000/api/cuestionarios/${id}`);
    const data = await res.json();

    if (!res.ok) {
      throw new Error(data.message || "No se pudo cargar el cuestionario");
    }

    const cuestionario = data.cuestionario;
    const preguntas = data.preguntas || [];

    const contenedor = document.getElementById("contenedorCuestionarioAlumno");

    contenedor.innerHTML = `
      <h3>${cuestionario.titulo}</h3>
      <form id="formResponder"></form>
      <button type="button" onclick="enviarRespuestas(${cuestionario.id}, ${cuestionario.lectura_id})">
        Enviar respuestas
      </button>
    `;

    const form = document.getElementById("formResponder");

    preguntas.forEach((p) => {
      const div = document.createElement("div");
      div.style.marginBottom = "20px";

      div.innerHTML = `
        <p><strong>${p.enunciado}</strong></p>
        ${(p.opciones || []).map(op => `
          <label>
            <input type="radio" name="pregunta_${p.id}" value="${op.id}">
            ${op.texto}
          </label><br>
        `).join("")}
      `;

      form.appendChild(div);
    });

  } catch (error) {
    console.error("Error al abrir cuestionario:", error);
    alert("Error al abrir cuestionario");
  }
}

/* =========================
   cargar respuestas y enviar al backend
========================= */
async function enviarRespuestas(cuestionarioId, lecturaId) {
  try {
    const inputs = document.querySelectorAll("#formResponder input:checked");

    if (!inputs.length) {
      alert("Debes responder al menos una pregunta");
      return;
    }

    const respuestas = [];

    inputs.forEach(i => {
      const pregunta_id = parseInt(i.name.split("_")[1]);
      const opcion_id = parseInt(i.value);

      respuestas.push({ pregunta_id, opcion_id });
    });

    const res = await fetch("http://localhost:3000/api/evaluaciones/responder", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        alumno_id: usuario.id,
        lectura_id: lecturaId,
        respuestas
      })
    });

    const data = await res.json();

    if (!res.ok) {
      throw new Error(data.message);
    }

    alert(`Puntaje: ${data.puntaje} - ${data.aprobado ? "Aprobado" : "Reprobado"}`);

    cargarResultados();
    cargarPuntos();

  } catch (error) {
    console.error(error);
    alert("Error al enviar respuestas");
  }
}

/* =========================
    PERFIL ALUMNO
========================= */

async function cargarPerfilAlumno() {
  try {
    const res = await fetch(`http://localhost:3000/api/alumnos/${usuario.id}/perfil`);
    const data = await res.json();

    const cursoInfo = document.getElementById("cursoAlumnoInfo");
    if (!cursoInfo) return;

    const cursoTexto = data.curso
      ? `${data.curso} - ${data.nivel} (${data.anio})`
      : "Sin curso";

    const docenteTexto = data.docente_nombre
      ? `${data.docente_nombre} ${data.docente_apellido}`
      : "Sin profesor jefe";

    cursoInfo.textContent = `Curso: ${cursoTexto} | Profesor jefe: ${docenteTexto}`;
  } catch (error) {
    console.error("Error perfil alumno:", error);
  }
}

/* =========================
   INIT
========================= */
document.addEventListener("DOMContentLoaded", () => {
  cargarBienvenidaAlumno();
  cargarLecturasAsignadas();
  cargarCuestionariosAlumno();
  cargarResultados();
  cargarPuntos();
  cargarProgresoAlumno();
  cargarPerfilAlumno();
});

/* =========================
   LOGOUT
========================= */
function logout() {
  localStorage.removeItem("usuario");
  window.location.href = "login.html";
}