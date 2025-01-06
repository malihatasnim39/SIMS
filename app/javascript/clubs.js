document.addEventListener("DOMContentLoaded", () => {
  const modal = document.getElementById("clubModal");
  const modalContent = document.getElementById("modalClubDetails");
  const closeBtn = document.querySelector(".modal .close");

  document.querySelectorAll(".club").forEach((club) => {
    club.addEventListener("click", () => {
      const clubId = club.getAttribute("data-club-id");
      fetch(`/clubs/${clubId}`)
        .then((response) => response.text())
        .then((html) => {
          modalContent.innerHTML = html;
          modal.style.display = "block";
        });
    });
  });

  closeBtn.addEventListener("click", () => {
    modal.style.display = "none";
  });

  window.addEventListener("click", (event) => {
    if (event.target == modal) {
      modal.style.display = "none";
    }
  });
});
