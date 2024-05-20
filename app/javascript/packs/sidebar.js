document.addEventListener("DOMContentLoaded", function() {
  const sidebar = document.querySelector(".sidebar");
  const menuToggle = document.querySelector(".menu-toggle");

  if (sidebar && menuToggle) {
    menuToggle.addEventListener("click", function() {
      sidebar.classList.toggle("active");
    });
  }
});