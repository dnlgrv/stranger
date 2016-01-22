import {Socket} from "phoenix"

const socket = new Socket("/socket")
socket.connect()

const messages = document.querySelector(".chat__messages")
const chatInput = document.querySelector(".chat__text-field")

let id
let myChannel
let currentRoom

const idChannel = socket.channel("id")
idChannel.join()
  .receive("ok", idChannelHandler)

chatInput.addEventListener("keypress", chatInputHandler)

function chatInputHandler(e) {
  if(currentRoom !== undefined && e.keyCode === 13 && chatInput.value !== "") {
    currentRoom.push("new_message", {body: chatInput.value})
    chatInput.value = ""
  }
}

function clear() {
  messages.innerHTML = ""
}

function idChannelHandler(resp) {
  id = resp.id

  myChannel = socket.channel(`strangers:${id}`)
  myChannel.join()
    .receive("ok", myChannelHandler)

  joinLobby()
}

function joinLobby() {
  socket.channel("lobby").join()
  systemMessage("Finding a stranger to chat with...")
}

function myChannelHandler() {
  myChannel.on("join_room", resp => {
    clear()
    systemMessage("You're now chatting with a stranger")
    strangerMessage("Hello stranger", false)
    strangerMessage("Hello stranger", true)

    const topic = resp.topic
    currentRoom = socket.channel(topic)
    currentRoom.join()
    currentRoom.on("new_message", resp => {
      strangerMessage(resp.body, resp.sender !== id)
    })
  })

  myChannel.on("leave_room", resp => {
    const topic = resp.topic
    let room = socket.channels.find(channel => {
      return channel.topic === topic
    })
    room.leave()
    currentRoom = undefined

    if(topic !== "lobby") {
      clear()
      systemMessage("Stranger left the chat")
      joinLobby()
    }
  })
}

function newMessage(message, messageClass) {
  messages.innerHTML += `<div class="message ${messageClass}">
<time class="message__time">${new Date().toLocaleTimeString()}</time>
<p class="message__content">${message}</p>
</div>`
  messages.scrollTop = messages.scrollHeight
}

function strangerMessage(message, received) {
  if(received) {
    newMessage(message, "message--received")
  } else {
    newMessage(message, "message--sent")
  }
}

function systemMessage(message) {
  newMessage(message, "message--system")
}
