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
});
