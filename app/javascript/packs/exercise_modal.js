document.addEventListener("DOMContentLoaded", () => {
  // モーダル要素とフォームの取得
  const modalEl = document.getElementById("scheduleModal");
  const modal = new bootstrap.Modal(modalEl);
  const scheduleForm = document.getElementById("schedule-form");

  // モーダルが表示されるときにフォームをリセット
  modalEl.addEventListener("show.bs.modal", () => {
    scheduleForm.reset();
    document.getElementById("exercise_name_display").textContent = "";
    document.querySelector("#schedule-form input[name='schedule[exercise_id]']").value = "";
  });

  // 各エクササイズボタンにクリックイベントを設定
  document.querySelectorAll(".btn-success").forEach(button => {
    button.addEventListener("click", (event) => {
      const exerciseId = event.currentTarget.dataset.exerciseId;
      const exerciseName = event.currentTarget.closest('.card').querySelector('h4 a').textContent;

      console.log(`Exercise Name: ${exerciseName}, ID: ${exerciseId}`);

      document.getElementById("exercise_name_display").textContent = exerciseName;
      document.querySelector("#schedule-form input[name='schedule[exercise_id]']").value = exerciseId;

      modal.show();
    });
  });

  // CSRFトークンを取得
  const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

  // フォーム送信時にfetchでPOSTリクエストを送信
  scheduleForm.addEventListener("submit", (event) => {
    event.preventDefault();
    const calendarId = scheduleForm.dataset.calendarId;
    const selectedExerciseId = document.querySelector("#schedule-form input[name='schedule[exercise_id]']").value;
    const selectedReps = document.getElementById("reps").value;
    const selectedSets = document.getElementById("sets").value;
    const selectedDate = document.getElementById("schedule_date").value;
  
    fetch(`/calendars/${calendarId}/schedules`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken
      },
      body: JSON.stringify({
        schedule: {
          exercise_id: selectedExerciseId,
          repetitions: selectedReps,
          sets: selectedSets,
          date: selectedDate
        }
      })
    })
    .then((response) => response.json().then((data) => {
      if (!response.ok && data.status === "error") {
        // エラーメッセージを表示
        alert(data.message);
      } else if (data.status === "success") {
        // 正常に作成された場合はページをリロード
        window.location.reload();
      }
    }))
    .catch((error) => {
      console.error("エラー:", error);
      alert("スケジュールの作成に失敗しました。");
    });
  });  
});