document.addEventListener("DOMContentLoaded", () => {
  const modal = document.getElementById("schedule-modal");
  const span = document.getElementsByClassName("close")[0];

  function showModal(html) {
    document.getElementById("schedule-details").innerHTML = html;
    modal.style.display = "block";
    setupFormSubmission();
  }

  document.querySelectorAll(".calendar-date").forEach(element => {
    element.addEventListener("click", (event) => {
      event.preventDefault();
      const date = event.currentTarget.dataset.date;
      const calendarId = event.currentTarget.dataset.calendarId;
      fetch(`/calendars/${calendarId}/schedules/new?date=${date}`, {
        headers: {
          'Accept': 'application/json'
        }
      })
      .then(response => response.json())
      .then(data => showModal(data.html));
    });
  });

  document.querySelectorAll(".edit-schedule").forEach(element => {
    element.addEventListener("click", (event) => {
      event.preventDefault();
      const scheduleId = event.currentTarget.dataset.scheduleId;
      const calendarId = event.currentTarget.dataset.calendarId;
      fetch(`/calendars/${calendarId}/schedules/${scheduleId}/edit`, {
        headers: {
          'Accept': 'application/json'
        }
      })
      .then(response => response.json())
      .then(data => showModal(data.html));
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

  function setupFormSubmission() {
    const form = document.getElementById("schedule_form");
    if (!form) return;
    form.addEventListener("submit", (event) => {
      event.preventDefault();
      const formData = new FormData(form);

      fetch(form.action, {
        method: 'POST',
        body: formData,
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        }
      })
      .then(response => response.json())
      .then(data => {
        if (data.redirect_url) {
          window.location.href = data.redirect_url;
        } else {
          showModal(data.html);
        }
      });
    });
  }
});
