document.addEventListener("DOMContentLoaded", () => {
  // モーダルとフォームの要素を取得
  console.log("JavaScript loaded. Initializing schedule modal.");

  const scheduleModalEl = document.getElementById("scheduleModal");
  const editModalEl = document.getElementById("editModal");

  if (!scheduleModalEl || !editModalEl) {
    console.error("Modal elements are missing. scheduleModalEl:", scheduleModalEl, "editModalEl:", editModalEl);
    return;
  }

  const scheduleModal = new bootstrap.Modal(scheduleModalEl);
  const editModal = new bootstrap.Modal(editModalEl);

  console.log("Modals initialized. scheduleModal:", scheduleModal, "editModal:", editModal);

  // フォーム送信に関するコード
  const scheduleForm = document.getElementById("schedule-form");
  if (scheduleForm) {
    scheduleForm.addEventListener("submit", (event) => {
      event.preventDefault(); // デフォルトの送信動作を防ぐ

      const formData = new FormData(scheduleForm);
      const actionUrl = scheduleForm.action;

      fetch(actionUrl, {
        method: "PATCH", // 更新用のHTTPメソッド
        body: formData,
        headers: {
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
        },
      })
        .then((response) => response.json())
        .then((data) => {
          if (data.status === "success") {
            console.log("Update successful:", data);
            // カレンダーにリダイレクト
            window.location.href = `/calendars/${data.schedule.calendar_id}`;
          } else {
            console.error("Update failed:", data.errors);
            alert("更新に失敗しました: " + data.errors.join(", "));
          }
        })
        .catch((error) => {
          console.error("Error:", error);
          alert("エラーが発生しました。");
        });
    });
  }

  // ヘルパー関数
  // 既存のリスナーを削除する
  function removeAllListeners(selector, event) {
    document.querySelectorAll(selector).forEach((el) => {
      const clone = el.cloneNode(true);
      el.parentNode.replaceChild(clone, el);
    });
  }

  // モーダル閉じたときのクリーンアップ処理
  function cleanupModal() {
    document.getElementById("exercise_name_display").textContent = "";
    document.body.classList.remove("modal-open");
    const backdrop = document.querySelector(".modal-backdrop");
    if (backdrop) backdrop.remove();
  }

  // リスナー登録関数
  // 「Add to Schedule」ボタンのリスナーを登録
  function registerAddToScheduleButtonListeners() {
    document.querySelectorAll('[data-bs-target="#scheduleModal"]').forEach((button) => {
      button.addEventListener("click", (event) => {
        const exerciseId = button.getAttribute("data-exercise_id");
        const exerciseName = button.getAttribute("data-exercise_name");
        const calendarId = button.getAttribute("data-calendar_id"); // カレンダーIDを取得
        console.log("calendarId:", calendarId);

        document.getElementById("exercise_name_display").textContent = exerciseName;
        document.getElementById("schedule_exercise_id").value = exerciseId;
        document.getElementById("schedule_calendar_id").value = calendarId; 
        // カレンダーIDをフォームにセット
        document.getElementById("schedule-form").action = `/calendars/${calendarId}/schedules`;
      });
    });
  }

  // 編集ボタンのリスナーを登録
  function registerEditButtonListeners() {
    document.querySelectorAll(".edit-schedule-btn").forEach((button) => {
      button.addEventListener("click", () => {
        const calendarId = button.dataset.calendarId;
        const scheduleId = button.dataset.scheduleId;

        console.log("Edit button clicked. calendarId:", calendarId, "scheduleId:", scheduleId);
  
        // `edit` アクションを呼び出す
        fetch(`/calendars/${calendarId}/schedules/${scheduleId}/edit`, {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
          },
        })
          .then((response) => {
            console.log("Fetch response status:", response.status);
            if (!response.ok) {
              return response.json().then(data => {
                alert(data.error);  // エラーメッセージを表示
                throw new Error("Failed to fetch schedule data.");
              });
            }
            return response.json();
          })
          .then((data) => {
            console.log("Fetched data:", data);  // データが正しいか確認
            // モーダルの内容を設定
            document.getElementById("schedule_id").value = scheduleId;
            document.getElementById("exercise_name_display").textContent = data.exercise_name;
            document.getElementById("schedule_exercise_id").value = data.exercise_id;
            document.getElementById("schedule_date").value = data.date;
            document.getElementById("repetitions").value = data.repetitions;
            document.getElementById("sets").value = data.sets;

  
            // フォームのアクションを設定
            const scheduleForm = document.getElementById("schedule-form");
            if (scheduleForm) {
              scheduleForm.action = `/calendars/${calendarId}/schedules/${scheduleId}`;
              console.log("Updated form action:", scheduleForm.action);
            } else {
              console.error("schedule-form element not found. Ensure the modal is initialized properly.");
            }
          })
          .catch((error) => {
            console.error(error);
            alert("スケジュールの取得に失敗しました。");
          });
      });
    });
  }

  // 削除ボタンのリスナーを登録
  function registerDeleteButtonListeners() {
    const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

    document.querySelectorAll(".delete-schedule-btn").forEach((button) => {
      button.addEventListener("click", () => {
        const scheduleId = button.dataset.scheduleId;
        const calendarId = button.dataset.calendarId;

        if (!confirm("本当に削除しますか？")) return;

        fetch(`/calendars/${calendarId}/schedules/${scheduleId}`, {
          method: "DELETE",
          headers: {
            "X-Requested-With": "XMLHttpRequest",
            "X-CSRF-Token": csrfToken,
          },
        })
          .then((response) => {
            if (!response.ok) throw new Error("削除に失敗しました。");
            document.getElementById(`schedule-item-${scheduleId}`).remove();
            alert("スケジュールが削除されました。");
          })
          .catch((error) => {
            console.error("削除エラー:", error);
            alert("スケジュールの削除に失敗しました。");
          });
      });
    });
  }

  // 「追加」ボタンのリスナーを登録
  function registerAddButtonListener() {
    const addScheduleBtn = document.getElementById("add-schedule-btn");
    if (addScheduleBtn) {
      addScheduleBtn.addEventListener("click", () => {
        scheduleModal?.hide();
        window.location.href = "/exercises";
      });
    }
  }

  // モーダル関連の関数
  // スケジュールモーダルを開く
  function openScheduleModal(date, calendarId) {
    if (!calendarId || !date) {
      alert("カレンダーIDまたは日付が指定されていません。");
      return;
    }

    fetch(`/calendars/${calendarId}/schedules?date=${date}`, {
      headers: { "X-Requested-With": "XMLHttpRequest" },
    })
      .then((response) => {
        if (!response.ok) throw new Error("スケジュールの取得に失敗しました。");
        return response.text();
      })
      .then((html) => {
        document.getElementById("schedule-details").innerHTML = html;
        scheduleModal?.show();

        // ボタンリスナーの再登録
        removeAllListeners(".edit-schedule-btn", "click");
        registerEditButtonListeners();
        registerDeleteButtonListeners();
        registerAddButtonListener();
        registerAddToScheduleButtonListeners();
      })
      .catch((error) => {
        console.error(error);
        alert("スケジュールの読み込みに失敗しました。");
      });
  }

  // 初期化処理
  // カレンダーの日付クリック時のイベント登録
  document.querySelectorAll(".calendar-date").forEach((element) => {
    element.addEventListener("click", (event) => {
      event.preventDefault();
      const date = element.dataset.date;
      const calendarId = element.dataset.calendarId;

      if (!calendarId) {
        alert("カレンダーIDが取得できませんでした。");
        return;
      }

      openScheduleModal(date, calendarId);
    });
  });

  // モーダル閉じたときのクリーンアップ処理
  if (scheduleModalEl) {
    scheduleModalEl.addEventListener("hidden.bs.modal", cleanupModal);
  }
});