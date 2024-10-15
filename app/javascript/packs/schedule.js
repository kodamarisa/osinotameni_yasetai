document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".calendar-date").forEach((element) => {
    element.addEventListener("click", (event) => {
      event.preventDefault();
      const date = event.currentTarget.dataset.date;
      const calendarId = event.currentTarget.dataset.calendarId;

      fetch(`/calendars/${calendarId}/schedules?date=${date}`)
        .then((response) => {
          if (!response.ok) {
            throw new Error('Failed to load schedule details.');
          }
          return response.text();
        })
        .then((html) => {
          document.getElementById("schedule-details").innerHTML = html;
          const modal = new bootstrap.Modal(document.getElementById("scheduleModal"));
          modal.show();
        })
        .catch((error) => {
          console.error('Error loading schedule details:', error);
        });
    });
  });

  // 追加ボタンの処理
  document.getElementById("add-schedule-btn")?.addEventListener("click", () => {
    window.location.href = '/exercises'; // エクササイズ一覧へリダイレクト
  });
});