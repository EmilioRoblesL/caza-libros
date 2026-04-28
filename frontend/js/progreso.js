async function guardarProgreso() {
  const data = {
    alumno_id: 2,
    lectura_id: 1,
    porcentaje_avance: 50,
    ultima_pagina: 5
  };

  try {
    const response = await fetch("http://localhost:3000/api/progreso", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify(data)
    });

    const result = await response.json();
    console.log(result);
    alert("Progreso guardado ✅");

  } catch (error) {
    console.error(error);
    alert("Error al guardar ❌");
  }
}