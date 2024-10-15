document.addEventListener("DOMContentLoaded", () => {
  // エクササイズボタンの取得
  document.querySelectorAll(".btn-success").forEach(button => {
    button.addEventListener("click", (event) => {
      const exerciseId = event.currentTarget.dataset.exerciseId; // エクササイズIDを取得
      const exerciseName = event.currentTarget.closest('.card').querySelector('h4 a').textContent; // エクササイズ名を取得
      const modal = new bootstrap.Modal(document.getElementById("scheduleModal"));

      // エクササイズ名をモーダル内に表示
      document.getElementById("exercise_name_display").textContent = exerciseName; 
      modal.show(); // モーダルを表示
    });
  });
 });