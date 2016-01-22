import "phoenix_html"
import {Socket} from "phoenix"

const socket = new Socket("/socket")
socket.connect()

const messages = document.getElementById("messages")
const chatInput = document.getElementById("chat-input")

let id
let myChannel
let currentRoom

const idChannel = socket.channel("id")
idChannel.join()
  .receive("ok", idChannelHandler)

chatInput.addEventListener("keypress", chatInputHandler)

function chatInputHandler(e) {
  if(currentRoom !== undefined && e.keyCode === 13) {
    currentRoom.push("new_message", {body: chatInput.value})
    chatInput.value = ""
  }
}

function idChannelHandler(resp) {
  id = resp.id
  idChannel.leave()

  myChannel = socket.channel(`strangers:${id}`)
  myChannel.join()
    .receive("ok", myChannelHandler)

  joinLobby()
}

function joinLobby() {
  socket.channel("lobby").join()
}

function myChannelHandler() {
  myChannel.on("join_room", resp => {
    const topic = resp.topic
    currentRoom = socket.channel(topic)
    currentRoom.join()
    currentRoom.on("new_message", newMessageHandler)
  })

  myChannel.on("leave_room", resp => {
    const topic = resp.topic
    let room = socket.channels.find(channel => {
      return channel.topic === topic
    })
    room.leave()
    currentRoom = undefined

    if(topic !== "lobby") {
      joinLobby()
    }
  })
}

function newMessageHandler(resp) {
  messages.innerHTML += `<p>${resp.body}</p>`
}
