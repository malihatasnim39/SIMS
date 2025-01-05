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
  
  document.addEventListener('DOMContentLoaded', () => {
    const equipmentSelect = document.getElementById('equipment-select');
    const clubSelect = document.getElementById('club-select');
    const stockContainer = document.getElementById('stock-container');
    const stockAvailable = document.getElementById('stock-available');
  
    async function updateStock() {
      const equipmentId = equipmentSelect.value;
      const clubId = clubSelect.value;
  
      if (equipmentId && clubId) {
        // Fetch stock information dynamically
        const response = await fetch(`/equipments/${equipmentId}/club/${clubId}/stock`);
        if (response.ok) {
          const data = await response.json();
          stockAvailable.textContent = `Stock Available: ${data.stock}`;
          stockContainer.style.display = 'block';
        } else {
          stockAvailable.textContent = `Stock Available: 0`;
          stockContainer.style.display = 'block';
        }
      } else {
        stockContainer.style.display = 'none';
      }
    }
  
    // Enable or disable the equipment select based on club selection
    clubSelect.addEventListener('change', () => {
      if (clubSelect.value) {
        equipmentSelect.disabled = false; // Enable equipment dropdown
        updateStock(); // Update stock availability
      } else {
        equipmentSelect.disabled = true; // Disable equipment dropdown
        equipmentSelect.value = ""; // Reset equipment dropdown
        stockContainer.style.display = "none"; // Hide stock information
      }
    });
  
    // Trigger stock update when equipment changes
    equipmentSelect.addEventListener('change', updateStock);
  });
  