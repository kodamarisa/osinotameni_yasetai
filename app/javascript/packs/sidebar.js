document.addEventListener("DOMContentLoaded", function() {
  const menuToggle = document.querySelector(".navbar-toggle");
  const sidebar = document.querySelector(".sidebar");
  const header = document.querySelector("header");

  if (sidebar && menuToggle) {
    menuToggle.addEventListener("click", function() {
      sidebar.classList.toggle("active");
      menuToggle.classList.toggle("show");

      // サイドバーが開いたときにヘッダーを下げる
      if (sidebar.classList.contains("active")) {
        header.style.transform = "translateY(" + sidebar.offsetHeight + "px)";
      } else {
        header.style.transform = "translateY(0)";
      }
    });

    // サイドバー内のリンクがクリックされたときにサイドバーを閉じる
    sidebar.querySelectorAll("a").forEach(link => {
      link.addEventListener("click", function() {
        sidebar.classList.remove("active");
        menuToggle.classList.remove("show");
        header.style.transform = "translateY(0)";
      });
    });
  }
});
