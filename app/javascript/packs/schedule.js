document.addEventListener("DOMContentLoaded", () => {
  const modal = document.getElementById("scheduleModal");
  const span = document.getElementsByClassName("close")[0];

  document.querySelectorAll(".calendar-date").forEach(element => {
    element.addEventListener("click", (event) => {
      event.preventDefault();
      const date = event.currentTarget.dataset.date;
      const calendarId = event.currentTarget.dataset.calendarId;
      fetch(`/calendars/${calendarId}/schedules/new?date=${date}`) // ルーティングに合わせてURLを変更
        .then(response => response.text())
        .then(html => {
          document.getElementById("schedule-details").innerHTML = html;
          modal.style.display = "block";
        });
    });
  });

  span.onclick = function() {
    modal.style.display = "none";
  }

  window.onclick = function(event) {
    if (event.target == modal) {
      modal.style.display = "none";
    }
  }
});
