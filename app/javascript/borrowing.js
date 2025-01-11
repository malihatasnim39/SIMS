document.addEventListener("DOMContentLoaded", () => {
    const bells = document.querySelectorAll(".alert-icon");
  
    bells.forEach((bell) => {
      bell.addEventListener("click", () => {
        alert("Overdue notification acknowledged!");
        bell.parentElement.style.display = "none"; // Hide card
      });
    });

    document.addEventListener("DOMContentLoaded", () => {
      const backBtns = document.querySelectorAll(".back-btn");
    
      backBtns.forEach((btn) => {
        btn.addEventListener("click", () => {
          history.back();
        });
      });
    });
    
  
    const searchInput = document.getElementById("search");
    const records = document.querySelectorAll(".record-card");
  
    searchInput.addEventListener("input", (event) => {
      const query = event.target.value.toLowerCase();
      records.forEach((record) => {
        const text = record.innerText.toLowerCase();
        record.style.display = text.includes(query) ? "block" : "none";
      });
    });
  });
  