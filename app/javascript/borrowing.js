document.addEventListener('DOMContentLoaded', () => {
  const equipmentSelect = document.getElementById('equipment-select');
  const stockContainer = document.getElementById('stock-container');
  const stockAvailable = document.getElementById('stock-available');

  // Function to fetch stock for the selected equipment
  async function updateStock() {
    const equipmentId = equipmentSelect.value;

    if (equipmentId) {
      try {
        // Fetch stock information for the selected equipment
        const response = await fetch(`/equipments/${equipmentId}/stock`);
        if (response.ok) {
          const data = await response.json();
          // Update the stock display
          stockAvailable.textContent = `Stock Available: ${data.stock}`;
          stockContainer.style.display = 'block';
        } else {
          stockAvailable.textContent = `Stock Available: 0`;
          stockContainer.style.display = 'block';
        }
      } catch (error) {
        console.error("Error fetching stock:", error);
        stockAvailable.textContent = `Error fetching stock`;
        stockContainer.style.display = 'block';
      }
    } else {
      // Hide the stock container if no equipment is selected
      stockContainer.style.display = 'none';
    }
  }

  // Add an event listener to update stock when equipment is selected
  equipmentSelect.addEventListener('change', updateStock);
});
