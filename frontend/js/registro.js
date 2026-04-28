const registroForm = document.getElementById("registroForm");
const mensaje = document.getElementById("mensaje");
const radiosRol = document.querySelectorAll('input[name="rol"]');
const camposDocente = document.getElementById("camposDocente");

function actualizarCamposDocente() {
  const rolSeleccionado = document.querySelector('input[name="rol"]:checked')?.value;

  if (rolSeleccionado === "docente") {
    camposDocente?.classList.remove("hidden");
  } else {
    camposDocente?.classList.add("hidden");

    const asignatura = document.getElementById("asignatura");
    const curso = document.getElementById("curso");
    const jefe = document.getElementById("jefe");

    if (asignatura) asignatura.value = "";
    if (curso) curso.value = "";
    if (jefe) jefe.checked = false;
  }
}

radiosRol.forEach((radio) => {
  radio.addEventListener("change", actualizarCamposDocente);
});

registroForm?.addEventListener("submit", async (e) => {
  e.preventDefault();

  const nombre = document.getElementById("nombre").value.trim();
  const apellido = document.getElementById("apellido").value.trim();
  const correo = document.getElementById("correo").value.trim();
  const password = document.getElementById("password").value;
  const confirmPassword = document.getElementById("confirmPassword").value;
  const rol = document.querySelector('input[name="rol"]:checked')?.value;

  const asignatura = document.getElementById("asignatura")?.value.trim() || null;
  const curso = document.getElementById("curso")?.value.trim() || null;
  const es_profesor_jefe = document.getElementById("jefe")?.checked || false;

  if (password !== confirmPassword) {
    mensaje.style.color = "red";
    mensaje.textContent = "Las contraseñas no coinciden";
    return;
  }

  if (!rol) {
    mensaje.style.color = "red";
    mensaje.textContent = "Debes seleccionar un rol";
    return;
  }

  if (rol === "docente" && (!asignatura || !curso)) {
    mensaje.style.color = "red";
    mensaje.textContent = "Debes completar asignatura y curso para el docente";
    return;
  }

  try {
    const response = await fetch("http://localhost:3000/api/auth/register", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        nombre,
        apellido,
        correo,
        password,
        rol,
        asignatura,
        curso,
        es_profesor_jefe
      })
    });

    const data = await response.json();

    if (!response.ok) {
      mensaje.style.color = "red";
      mensaje.textContent = data.message || "Error al registrar";
      return;
    }

    mensaje.style.color = "green";
    mensaje.textContent = "Registro exitoso, redirigiendo al login...";

    registroForm.reset();
    actualizarCamposDocente();

    setTimeout(() => {
      window.location.href = "login.html";
    }, 1500);
  } catch (error) {
    console.error(error);
    mensaje.style.color = "red";
    mensaje.textContent = "Error de conexión con el servidor";
  }
});

actualizarCamposDocente();