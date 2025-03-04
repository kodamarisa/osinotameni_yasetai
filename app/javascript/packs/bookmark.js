document.addEventListener("turbolinks:load", () => {
  document.querySelectorAll('.bookmark-toggle').forEach(button => {
    const icon = button.querySelector('i');

    // 初期状態で data-bookmarked に基づいてアイコンの状態を設定
    console.log("Initial Bookmark State:", button.dataset.bookmarked);
    if (button.dataset.bookmarked === 'true') {
      icon.classList.replace('far', 'fas');
    } else {
      icon.classList.replace('fas', 'far');
    }

    button.addEventListener("ajax:success", (event) => {
      const [data] = event.detail;
      const buttonIcon = button.querySelector('i');
      console.log("Bookmark toggle response:", data);

      if (data.status === 'created') {
        buttonIcon.classList.replace('far', 'fas');
        button.dataset.method = 'delete';
        button.dataset.bookmarked = 'true';
      } else if (data.status === 'deleted') {
        buttonIcon.classList.replace('fas', 'far');
        button.dataset.method = 'post';
        button.dataset.bookmarked = 'false';
      } else if (data.status === 'already_bookmarked') {
        buttonIcon.classList.replace('far', 'fas');
        button.dataset.method = 'delete';
      }
    });

    button.addEventListener("ajax:error", () => {
      alert("An error occurred while toggling the bookmark.");
    });
  });
});