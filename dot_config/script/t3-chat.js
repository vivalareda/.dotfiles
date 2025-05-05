document.addEventListener("keydown", function (e) {
  if (
    e.metaKey &&
    !e.ctrlKey &&
    !e.altKey &&
    !e.shiftKey &&
    e.key.toLowerCase() === "n"
  ) {
    e.preventDefault();
    const newChatEvent = new KeyboardEvent("keydown", {
      key: "o",
      metaKey: true,
      shiftKey: true,
    });
    document.dispatchEvent(newChatEvent);
  }
});

document.addEventListener("keydown", function (e) {
  if (e.key === "Tab" && !e.metaKey && !e.ctrlKey && !e.altKey && !e.shiftKey) {
    e.preventDefault();

    const chatInput = document.querySelector("#chat-input");
    chatInput.focus();
  }
});
