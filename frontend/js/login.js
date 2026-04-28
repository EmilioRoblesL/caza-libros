const usuarioGuardado = JSON.parse(localStorage.getItem("usuario"));

if (usuarioGuardado) {
  if (usuarioGuardado.rol === "alumno") {
    window.location.href = "alumno.html";
  } else if (usuarioGuardado.rol === "docente") {
    window.location.href = "docente.html";
  } else if (usuarioGuardado.rol === "admin") {
    window.location.href = "admin.html";
  }
}

const loginForm = document.getElementById("loginForm");
const mensaje = document.getElementById("mensaje");

loginForm?.addEventListener("submit", async (e) => {
  e.preventDefault();

  const correo = document.getElementById("correo").value.trim();
  const password = document.getElementById("password").value;

  try {
    const response = await fetch("http://localhost:3000/api/auth/login", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ correo, password })
    });

    const data = await response.json();

    if (!response.ok) {
      mensaje.style.color = "red";
      mensaje.textContent = data.message || "Error al iniciar sesión";
      return;
    }

    localStorage.setItem("usuario", JSON.stringify(data.usuario));

    mensaje.style.color = "green";
    mensaje.textContent = "Inicio de sesión correcto";

    setTimeout(() => {
      if (data.usuario.rol === "alumno") {
        window.location.href = "alumno.html";
      } else if (data.usuario.rol === "docente") {
        window.location.href = "docente.html";
      } else if (data.usuario.rol === "admin") {
        window.location.href = "admin.html";
      } else {
        mensaje.style.color = "red";
        mensaje.textContent = "Rol no reconocido";
      }
    }, 800);

  } catch (error) {
    console.error(error);
    mensaje.style.color = "red";
    mensaje.textContent = "Error de conexión con el servidor";
  }
});