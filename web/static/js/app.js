import "phoenix_html"
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {id: window.stranger.id}})
socket.connect()

let lobby = socket.channel("lobby", {})
lobby.join()
  .receive("ok", resp => {
    lobby.on("join_room", resp => {
      console.log(resp)
    })
  })

// import Chat from "./chat"

// if(document.querySelector("[data-init='chat']")) {
//   if(localStorage.getItem("agreed")) {
//     new Chat()
//   } else {
//     showWelcome()
//   }
// }
//
// function showWelcome() {
//   const el = document.querySelector(".welcome")
//   el.classList.add("welcome--show")
//
//   const startButton = el.querySelector("[data-click='start']")
//   startButton.addEventListener("click", e => {
//     el.classList.remove("welcome--show")
//     localStorage.setItem("agreed", true)
//     new Chat()
//   })
// }
