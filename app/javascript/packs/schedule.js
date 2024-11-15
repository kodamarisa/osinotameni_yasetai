document.addEventListener("DOMContentLoaded", () => {
  const scheduleModalEl = document.getElementById("scheduleModal");
  const editModalEl = document.getElementById("editModal");
  const scheduleForm = document.getElementById("schedule-form");

  const scheduleModal = scheduleModalEl ? new bootstrap.Modal(scheduleModalEl) : null;
  const editModal = editModalEl ? new bootstrap.Modal(editModalEl) : null;

  // 既存のリスナーを削除する関数
  function removeAllListeners(selector, event) {
    document.querySelectorAll(selector).forEach((el) => {
      const clone = el.cloneNode(true); // リスナーを持たないクローンを生成
      el.parentNode.replaceChild(clone, el); // 元の要素を置き換え
    });
  }

  // スケジュールモーダルを開く関数
  function openScheduleModal(date, calendarId) {
    console.log("Calendar ID:", calendarId, "Date:", date); // デバッグログ
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

        // 初期化のためリスナーを一度削除してから再登録
        removeAllListeners(".edit-schedule-btn", "click");
        registerEditButtonListeners();

        registerAddButtonListener(); // 「追加」ボタンのリスナー登録
      })
      .catch((error) => {
        console.error(error);
        alert("スケジュールの読み込みに失敗しました。");
      });
  }

  // 編集ボタンのリスナーを登録する関数
  function registerEditButtonListeners() {
    document.querySelectorAll(".edit-schedule-btn").forEach((button) => {
      button.addEventListener("click", () => {
        const scheduleId = button.dataset.scheduleId;
        const calendarId = button.dataset.calendarId;
        const exerciseId = button.dataset.exerciseId;
        const exerciseName = button.dataset.exerciseName;
        const reps = button.dataset.reps;
        const sets = button.dataset.sets;
        const date = button.dataset.date;

        console.log("Opening edit modal with data:", {
          scheduleId,
          calendarId,
          exerciseId,
          exerciseName,
          reps,
          sets,
          date
        });

        if (!exerciseId || !calendarId) {
          alert("エクササイズIDまたはカレンダーIDが取得できませんでした。");
          return;
        }

        // モーダルのタイトルとフォームの値をセット
        document.getElementById("exercise_name_display").textContent = exerciseName;
        document.getElementById("schedule_exercise_id").value = exerciseId;
        document.getElementById("schedule_date").value = date;
        document.getElementById("reps").value = reps;
        document.getElementById("sets").value = sets;

        // フォームのactionを更新
        scheduleForm.action = `/calendars/${calendarId}/schedules/${scheduleId}`;

        scheduleModal?.hide();  // スケジュールモーダルを非表示
        editModal?.show();  // 編集モーダルを表示
      });
    });
  }

  // 「追加」ボタンのリスナー登録
  function registerAddButtonListener() {
    const addScheduleBtn = document.getElementById("add-schedule-btn");
    if (addScheduleBtn) {
      addScheduleBtn.addEventListener("click", () => {
        scheduleModal?.hide();
        window.location.href = "/exercises";
      });
    }
  }

    // CSRFトークンを取得
    const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

    // 削除ボタンのリスナーを登録する関数
    function registerDeleteButtonListeners() {
      document.querySelectorAll(".delete-schedule-btn").forEach((button) => {
        button.addEventListener("click", () => {
          const scheduleId = button.dataset.scheduleId;
          const calendarId = button.dataset.calendarId;
  
          if (!scheduleId || !calendarId) {
            alert("スケジュールIDまたはカレンダーIDが取得できませんでした。");
            return;
          }
  
          // 削除の確認
          if (!confirm("本当に削除しますか？")) return;
  
          // 非同期で削除リクエストを送信
          fetch(`/calendars/${calendarId}/schedules/${scheduleId}`, {
            method: "DELETE",
            headers: {
              "X-Requested-With": "XMLHttpRequest",
              "X-CSRF-Token": csrfToken // CSRFトークンを追加
            }
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
  
    // スケジュールモーダルを開く際に削除ボタンのリスナーも登録
    function openScheduleModal(date, calendarId) {
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
  
          // 編集・削除ボタンのリスナー登録
          removeAllListeners(".edit-schedule-btn", "click");
          registerEditButtonListeners();
          registerDeleteButtonListeners(); // 削除ボタンのリスナー登録
  
          registerAddButtonListener();
        })
        .catch((error) => {
          console.error(error);
          alert("スケジュールの読み込みに失敗しました。");
        });
    }

  // モーダルのクリーンアップ関数
  function cleanupModal() {
    document.getElementById("exercise_name_display").textContent = "";
    const exerciseIdField = document.querySelector("#schedule-form input[name='schedule[exercise_id]']");
    document.body.classList.remove("modal-open");
    const backdrop = document.querySelector(".modal-backdrop");
    if (backdrop) backdrop.remove();
  }

  // カレンダーの日付クリック時のイベント登録
  document.querySelectorAll(".calendar-date").forEach((element) => {
    element.addEventListener("click", (event) => {
      event.preventDefault();
      const date = element.dataset.date;
      const calendarId = element.dataset.calendarId;

      if (!calendarId) {
        console.error("Calendar ID is missing");
        alert("カレンダーIDが取得できませんでした。");
        return;
      }

      console.log("Opening Schedule Modal - Calendar ID:", calendarId, "Date:", date); // デバッグログ
      openScheduleModal(date, calendarId);
    });
  });

  // フォーム送信時の処理
  if (scheduleForm) {
    scheduleForm.addEventListener("submit", (event) => {
      event.preventDefault();
      const formData = new FormData(scheduleForm);

      fetch(scheduleForm.action, {
        method: scheduleForm.method,
        body: formData,
        headers: { 'X-Requested-With': 'XMLHttpRequest' }
    })
    .then((response) => {
        if (!response.ok) throw new Error("保存に失敗しました。");
        return response.text(); // まずはテキストとして取得して確認
    })
    .then((text) => {
        console.log("レスポンス内容:", text); // レスポンスを確認
        // JSONに変換する必要がある場合は、ここでJSON.parseを使用
        const jsonData = JSON.parse(text); // もしresponseがJSONの場合
        return jsonData;
    })
    .then(() => {
        editModal?.hide();
        alert("スケジュールが保存されました。");
    })
    .catch((error) => console.error("エラー:", error));    
    });
  }

  // モーダル閉じたときのクリーンアップ処理
  if (scheduleModalEl) {
    scheduleModalEl.addEventListener('hidden.bs.modal', cleanupModal);
  }
});