const recuperarForm = document.getElementById("recuperarForm");
const mensaje = document.getElementById("mensaje");

recuperarForm?.addEventListener("submit", async (e) => {
  e.preventDefault();

  const correo = document.getElementById("correo").value.trim();

  try {
    const response = await fetch("http://localhost:3000/api/auth/forgot-password", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ correo })
    });

    const data = await response.json();

    if (!response.ok) {
      mensaje.textContent = data.message || "Error al enviar correo";
      return;
    }

    mensaje.style.color = "green";
    mensaje.textContent = data.message;
  } catch (error) {
    console.error(error);
    mensaje.textContent = "Error de conexión con el servidor";
  }
});