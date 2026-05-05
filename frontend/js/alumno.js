const usuario = JSON.parse(localStorage.getItem("usuario"));

if (!usuario || usuario.rol !== "alumno") {
  alert("Acceso no autorizado");
  window.location.href = "login.html";
}

const API_RESULTADOS = "https://caza-libros.onrender.com/api/resultados";
const API_PUNTOS = "https://caza-libros.onrender.com/api/puntos";
const API_EVALUACIONES = "https://caza-libros.onrender.com/api/evaluaciones";
const API_ASIGNACIONES = "https://caza-libros.onrender.com/api/asignaciones";
const API_PROGRESO = "https://caza-libros.onrender.com/api/progreso";

let lecturaSeleccionada = null;
let timeoutGuardado = null;
let ultimoPorcentaje = -1;
let cuestionarioActual = null;
let preguntasActuales = [];
let preguntaIndiceActual = 0;
let respuestasAlumno = [];

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

    if (!lista) return;
    lista.innerHTML = "";

    const lecturas = Array.isArray(data)
      ? data.filter((l) => Number(l.alumno_id) === Number(usuario.id))
      : [];

    if (cantidad) cantidad.textContent = lecturas.length;

    if (!lecturas.length) {
      lista.innerHTML = `
        <div class="estado-vacio">
          <h3> No tienes lecturas asignadas</h3>
          <p>Cuando tu profesor asigne una lectura, aparecerá aquí.</p>
        </div>
      `;
      return;
    }

    lecturas.forEach((l) => {
      const card = document.createElement("div");
      card.className = "card-lectura";

      card.innerHTML = `
        <div class="lectura-card-info">
          <h3> ${l.titulo}</h3>
          <p>${l.autor ? "Autor: " + l.autor : "Autor no registrado"}</p>
        </div>

        <div class="lectura-card-acciones">
          <button type="button" class="btn-leer-card">Leer lectura</button>
          <button type="button" class="btn-evaluar-card">Responder evaluación</button>
        </div>
      `;

      const btnLeer = card.querySelector(".btn-leer-card");
      const btnEvaluar = card.querySelector(".btn-evaluar-card");

      btnLeer.onclick = () => {
        seleccionarLectura({
          id: l.lectura_id,
          titulo: l.titulo,
          autor: l.autor,
          contenido: l.contenido,
          curso_nombre: l.curso_nombre,
          profesor_nombre: l.profesor_nombre,
          profesor_apellido: l.profesor_apellido
        });

        mostrarSeccionAlumno("lector", document.querySelectorAll(".menu-link")[2]);
      };

      btnEvaluar.onclick = () => {
        seleccionarLectura({
          id: l.lectura_id,
          titulo: l.titulo,
          autor: l.autor,
          contenido: l.contenido,
          curso_nombre: l.curso_nombre,
          profesor_nombre: l.profesor_nombre,
          profesor_apellido: l.profesor_apellido
        });

        mostrarSeccionAlumno("progreso", document.querySelectorAll(".menu-link")[3]);
        cargarCuestionariosAlumno();
      };

      lista.appendChild(card);
    });
  } catch (err) {
    console.error(err);
    alert("Error al cargar lecturas");
  }
}

/* =========================
    BARRA DE LECTURA
========================= */

function actualizarBarraLectura(porcentaje) {
  const texto = document.getElementById("porcentajeLecturaTexto");
  const barra = document.getElementById("barraProgresoLectura");

  const valor = Math.max(0, Math.min(100, Number(porcentaje) || 0));

  if (texto) texto.textContent = `${valor}%`;
  if (barra) barra.style.width = `${valor}%`;
}

/* =========================
   SELECCIONAR LECTURA
========================= */
function seleccionarLectura(lectura) {
  lecturaSeleccionada = lectura;
  ultimoPorcentaje = 0;

  const elLecturaTexto = document.getElementById("lecturaSeleccionadaTexto");
  const elLecturaProgreso = document.getElementById("lecturaSeleccionadaProgreso");
  const elTitulo = document.getElementById("tituloLecturaAbierta");
  const elMeta = document.getElementById("metaLecturaAbierta");
  const elContenido = document.getElementById("contenidoLecturaAbierta");
  const wrapper = document.getElementById("contenidoLecturaWrapper");

  if (elLecturaTexto) {
    elLecturaTexto.textContent = `Lectura seleccionada: ${lectura.titulo}`;
  }

  if (elLecturaProgreso) {
    elLecturaProgreso.textContent = `Lectura seleccionada: ${lectura.titulo}`;
  }

  if (elTitulo) elTitulo.textContent = lectura.titulo || "Sin título";
  if (elMeta) elMeta.textContent = `Autor: ${lectura.autor || "-"}`;
  if (elContenido) elContenido.textContent = lectura.contenido || "Sin contenido";

  if (wrapper) {
    wrapper.scrollTop = 0;
    wrapper.removeEventListener("scroll", onScrollLectura);
    wrapper.addEventListener("scroll", onScrollLectura);
  }

  actualizarBarra(0);
  cargarPerfilAlumno();
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

  const val = Math.max(0, Math.min(100, Math.round(porcentaje)));

  if (barra) barra.style.width = `${val}%`;
  if (texto) texto.textContent = `${val}%`;

  ultimoPorcentaje = val;
}

function actualizarBarraLectura(porcentaje) {
  actualizarBarra(porcentaje);
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
    alert("Selecciona una lectura primero");
    return;
  }

  const porcentaje = Math.max(0, Math.min(100, Number(ultimoPorcentaje) || 100));

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

    await cargarProgresoAlumno();
    await cargarCuestionariosAlumno();

    alert("Progreso guardado correctamente");

    const links = document.querySelectorAll(".menu-link");
    mostrarSeccionAlumno("progreso", links[3] || null);
  } catch (e) {
    console.error(e);
    alert("Error al guardar progreso");
  }
}

/* =========================
   VER PROGRESO GUARDADO
========================= */
async function cargarProgresoAlumno() {
  try {
    const res = await fetch(`${API_PROGRESO}/alumno/${usuario.id}`);
    const progresos = await res.json();

    const resResultados = await fetch(`${API_RESULTADOS}/${usuario.id}`);
    const resultados = await resResultados.json();

    const lista = document.getElementById("listaProgresoAlumno");
    if (!lista) return;

    lista.innerHTML = "";

    if (!Array.isArray(progresos) || progresos.length === 0) {
      lista.innerHTML = "<li>No hay progreso guardado</li>";
      return;
    }

    progresos.forEach((p) => {
      const resultado = Array.isArray(resultados)
        ? resultados.find((r) => Number(r.lectura_id) === Number(p.lectura_id))
        : null;

      const li = document.createElement("li");

      li.innerHTML = `
        <strong>${p.titulo}</strong> - leído al ${p.porcentaje_avance}% 
        ${resultado 
          ? `- Evaluación respondida: ${resultado.aprobado ? "20.00 puntos ✔" : "0 puntos ✘"}`
          : `- Evaluación pendiente`
        }
      `;

      lista.appendChild(li);
    });

    if (lecturaSeleccionada) {
      const progresoLectura = progresos.find(
        (p) => Number(p.lectura_id) === Number(lecturaSeleccionada.id)
      );

      if (progresoLectura) {
        const porcentaje = Number(progresoLectura.porcentaje_avance || 0);
        ultimoPorcentaje = Math.round(porcentaje);
        actualizarBarra(porcentaje);

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
    const res = await fetch(`https://caza-libros.onrender.com/api/resultados/${usuario.id}`);
    const data = await res.json();

    const lista = document.getElementById("listaResultados");
    if (!lista) return;

    lista.innerHTML = "";

    if (!data.length) {
      lista.innerHTML = "<li>No tienes resultados aún.</li>";
      return;
    }

    data.forEach((r) => {
      const li = document.createElement("li");

      const puntos = r.aprobado ? "20.00 puntos" : "0 puntos";
      const estado = r.aprobado ? "Aprobado ✔" : "Reprobado ✘";

      li.innerHTML = `
        <div style="margin-bottom:6px;">
          <strong>${r.titulo}</strong>
        </div>
        <div>
          Puntaje obtenido: ${puntos}
        </div>
        <div>
          Resultado: <strong>${estado}</strong>
        </div>
      `;

      li.style.marginBottom = "12px";
      li.style.padding = "10px";
      li.style.background = "#f8faff";
      li.style.border = "1px solid #dbe2f0";
      li.style.borderRadius = "8px";

      lista.appendChild(li);
    });

  } catch (error) {
    console.error(error);
    alert("Error al cargar resultados");
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
    const res = await fetch(`https://caza-libros.onrender.com/api/evaluaciones/alumno/${usuario.id}/cuestionarios`);
    const cuestionarios = await res.json();

    const resResultados = await fetch(`${API_RESULTADOS}/${usuario.id}`);
    const resultados = await resResultados.json();

    const lista = document.getElementById("listaCuestionariosAlumno");
    const contenedor = document.getElementById("contenedorCuestionarioAlumno");

    if (!lista) return;

    lista.innerHTML = "";
    if (contenedor) contenedor.innerHTML = "";

    const lecturasRespondidas = Array.isArray(resultados)
      ? resultados.map((r) => Number(r.lectura_id))
      : [];

    const cuestionariosPendientes = Array.isArray(cuestionarios)
      ? cuestionarios.filter((c) => !lecturasRespondidas.includes(Number(c.lectura_id)))
      : [];

    if (!cuestionariosPendientes.length) {
      lista.innerHTML = `
        <li>
          No tienes evaluaciones pendientes por responder.
        </li>
      `;
      return;
    }

    cuestionariosPendientes.forEach((c) => {
      const li = document.createElement("li");

      li.innerHTML = `
        <strong>${c.cuestionario_titulo}</strong><br>
        Lectura: ${c.lectura_titulo}<br>
        <button type="button" onclick="abrirCuestionario(${c.cuestionario_id})">
          Responder cuestionario
        </button>
      `;

      lista.appendChild(li);
    });

  } catch (error) {
    console.error("Error al cargar cuestionarios:", error);
  }
}

/* =========================
abrir cuestionario para responder
========================= */

async function abrirCuestionario(id) {
  try {
    const res = await fetch(`https://caza-libros.onrender.com/api/cuestionarios/${id}`);
    const data = await res.json();

    if (!res.ok) {
      throw new Error(data.message || "No se pudo cargar el cuestionario");
    }

    cuestionarioActual = data.cuestionario;
    preguntasActuales = data.preguntas || [];
    preguntaIndiceActual = 0;
    respuestasAlumno = [];

    if (!preguntasActuales.length) {
      alert("Este cuestionario no tiene preguntas.");
      return;
    }

    mostrarPreguntaActual();

  } catch (error) {
    console.error("Error al abrir cuestionario:", error);
    alert("Error al abrir cuestionario");
  }
}

/* =========================
mostrar pregunta actual y opciones para responder
========================= */

function mostrarPreguntaActual() {
  const contenedor = document.getElementById("contenedorCuestionarioAlumno");
  if (!contenedor) return;

  const pregunta = preguntasActuales[preguntaIndiceActual];
  const total = preguntasActuales.length;
  const numero = preguntaIndiceActual + 1;
  const progreso = Math.round((numero / total) * 100);

  contenedor.innerHTML = `
    <div class="quiz-layout">
      <div class="quiz-card">
        <h3>Lectura</h3>
        <p>${lecturaSeleccionada?.contenido 
          ? lecturaSeleccionada.contenido.substring(0, 220) + "..." 
          : "Lectura seleccionada: " + (lecturaSeleccionada?.titulo || "Sin lectura")}
        </p>
      </div>

      <div class="quiz-card">
        <h3>Pregunta</h3>
        <p class="quiz-pregunta">${pregunta.enunciado}</p>

        <div class="quiz-opciones">
          ${(pregunta.opciones || []).map((op) => `
            <label class="quiz-opcion">
              <input type="radio" name="pregunta_actual" value="${op.id}">
              <span>${op.texto}</span>
            </label>
          `).join("")}
        </div>
      </div>

      <div class="quiz-footer">
        <div class="quiz-progress-wrap">
          <span>Progreso:</span>
          <div class="quiz-progress">
            <div class="quiz-progress-fill" style="width:${progreso}%"></div>
          </div>
        </div>

        ${
          preguntaIndiceActual < total - 1
            ? `<button type="button" class="quiz-btn-next" onclick="siguientePregunta()">Siguiente</button>`
            : `<button type="button" class="quiz-btn-next" onclick="finalizarCuestionario()">Enviar</button>`
        }
      </div>
    </div>
  `;
}

function siguientePregunta() {
  const seleccionada = document.querySelector('input[name="pregunta_actual"]:checked');

  if (!seleccionada) {
    alert("Debes seleccionar una alternativa antes de continuar.");
    return;
  }

  const pregunta = preguntasActuales[preguntaIndiceActual];

  respuestasAlumno[preguntaIndiceActual] = {
    pregunta_id: pregunta.id,
    opcion_id: Number(seleccionada.value)
  };

  preguntaIndiceActual++;
  mostrarPreguntaActual();
}

function preguntaAnterior() {
  if (preguntaIndiceActual > 0) {
    preguntaIndiceActual--;
    mostrarPreguntaActual();
  }
}

async function finalizarCuestionario() {
  const seleccionada = document.querySelector('input[name="pregunta_actual"]:checked');

  if (!seleccionada) {
    alert("Debes seleccionar una alternativa antes de enviar.");
    return;
  }

  const pregunta = preguntasActuales[preguntaIndiceActual];

  respuestasAlumno[preguntaIndiceActual] = {
    pregunta_id: pregunta.id,
    opcion_id: Number(seleccionada.value)
  };

  if (respuestasAlumno.length < preguntasActuales.length) {
    alert("Debes responder todas las preguntas.");
    return;
  }

  await enviarRespuestas(
    cuestionarioActual.id,
    cuestionarioActual.lectura_id,
    respuestasAlumno
  );
}

/* =========================
   cargar respuestas y enviar al backend
========================= */
async function enviarRespuestas(cuestionarioId, lecturaId, respuestas) {
  try {
    const res = await fetch("https://caza-libros.onrender.com/api/evaluaciones/responder", {
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
      alert(data.message || "No se pudo enviar la evaluación");
      return;
    }

    alert(
      `Evaluación enviada correctamente.\nPuntaje: ${data.puntaje} - ${data.aprobado ? "Aprobado" : "Reprobado"}\nPuntos obtenidos: ${data.puntos_ganados || 0}`
    );

    const contenedor = document.getElementById("contenedorCuestionarioAlumno");
    if (contenedor) contenedor.innerHTML = "";

    await cargarCuestionariosAlumno();
    await cargarResultados();
    await cargarPuntos();
    await cargarProgresoAlumno();

    mostrarSeccionAlumno("resultados", document.querySelectorAll(".menu-link")[4]);

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
    const res = await fetch(`https://caza-libros.onrender.com/api/alumnos/${usuario.id}/perfil`);
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