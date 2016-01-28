import "phoenix_html"
import Chat from "./chat"

const chatEl = document.querySelector("[data-init='chat']")

if(document.querySelector("[data-init='chat']")) {
  if(localStorage.getItem("agreed")) {
    startChat()
  } else {
    showWelcome()
  }
}

function startChat() {
  const chat = new Chat(chatEl, window.stranger.id)
  chat.start()
}

function showWelcome() {
  const el = document.querySelector(".welcome")
  el.classList.add("welcome--show")

  const startButton = el.querySelector("[data-click='start']")
  startButton.addEventListener("click", e => {
    el.classList.remove("welcome--show")
    localStorage.setItem("agreed", true)
    startChat()
  })
}
