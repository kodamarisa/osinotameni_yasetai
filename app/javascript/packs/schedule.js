document.addEventListener("DOMContentLoaded", () => {
  const scheduleModalEl = document.getElementById("scheduleModal");
  const scheduleModal = new bootstrap.Modal(scheduleModalEl);
  const scheduleForm = document.getElementById("schedule-form");

  // カレンダーの日付クリックでモーダルを開く
  document.querySelectorAll(".calendar-date").forEach((element) => {
    element.addEventListener("click", (event) => {
      event.preventDefault();
      const date = event.currentTarget.dataset.date;
      const calendarId = event.currentTarget.dataset.calendarId;
      
      fetch(`/calendars/${calendarId}/schedules?date=${date}`)
        .then((response) => {
          if (!response.ok) throw new Error("Failed to load schedule details.");
          return response.text();
        })
        .then((html) => {
          document.getElementById("schedule-details").innerHTML = html;
          scheduleModal.show();

          // 追加ボタンのイベントリスナーを再登録
          const addScheduleBtn = document.getElementById("add-schedule-btn");
          if (addScheduleBtn) {
            addScheduleBtn.addEventListener("click", () => {
              scheduleModal.hide();
              // 筋トレ一覧にリダイレクト
              window.location.href = "/exercises"; 
            });
          }
        })
        .catch((error) => console.error("Error loading schedule details:", error));
    });
  });

  // フォームの送信処理
  if (scheduleForm) {
    scheduleForm.addEventListener("submit", (event) => {
      event.preventDefault(); // デフォルトのフォーム送信をキャンセル
      
      const formData = new FormData(scheduleForm);
      console.log("Submitting Schedule Data:");
      for (let [key, value] of formData.entries()) {
        console.log(`${key}: ${value}`);
      }

      fetch(scheduleForm.action, {
        method: scheduleForm.method,
        body: formData,
        headers: {
          'X-Requested-With': 'XMLHttpRequest' // AJAXリクエストであることを示す
        }
      })
      .then((response) => {
        if (!response.ok) throw new Error("Failed to save schedule.");
        return response.json(); // サーバーからのレスポンスをJSONとして解析
      })
      .then((data) => {
        console.log("Schedule saved successfully:", data);
        scheduleModal.hide();
        // 必要に応じてカレンダーを更新するコードをここに追加
      })
      .catch((error) => console.error("Error saving schedule:", error));
    });
  }

  // モーダルが閉じるときにBackdropを確実に削除
  scheduleModalEl.addEventListener("hidden.bs.modal", () => {
    // モーダルを閉じた後、古いデータを削除
    scheduleForm.reset();
    document.getElementById("exercise_name_display").textContent = "";
    document.querySelector("#schedule-form input[name='schedule[exercise_id]']").value = "";
  
    // モーダルオープン時のクラスやBackdropの削除
    document.body.classList.remove("modal-open");
    const backdrop = document.querySelector(".modal-backdrop");
    if (backdrop) backdrop.remove();
  });  
});