import {Socket} from "phoenix"

class Chat {
  constructor() {
    this.socket = new Socket("/socket")
    this.socket.connect()

    this.messages = document.querySelector(".chat__messages")
    this.chatInput = document.querySelector(".chat__text-field")
    this.stats = document.querySelector(".chat__stats")

    this.id = undefined
    this.myChannel = undefined
    this.currentRoom = undefined

    this.idChannel = this.socket.channel("id")
    this.idChannel.join()
      .receive("ok", this.idChannelHandler.bind(this))

    this.chatInput.addEventListener("keypress", this.chatInputHandler.bind(this))
  }

  chatInputHandler(e) {
    if(this.currentRoom !== undefined &&
        e.keyCode === 13 && this.chatInput.value !== "") {
      this.currentRoom.push("new_message", {body: this.chatInput.value})
      this.chatInput.value = ""
    }
  }

  idChannelHandler(resp) {
    this.id = resp.id
    this.idChannel.on("stats", this.statsHandler.bind(this))

    this.myChannel = this.socket.channel(`strangers:${this.id}`)
    this.myChannel.join()
      .receive("ok", this.myChannelHandler.bind(this))

    this.joinLobby()
  }

  joinLobby() {
    this.socket.channel("lobby").join()
    this.systemMessage("Finding a stranger to chat with...")
  }

  clear() {
    this.messages.innerHTML = ""
  }

  myChannelHandler() {
    this.myChannel.on("join_room", resp => {
      this.clear()
      this.systemMessage("You're now chatting with a stranger")
      this.strangerMessage("Hello stranger", false)
      this.strangerMessage("Hello stranger", true)

      const topic = resp.topic
      this.currentRoom = this.socket.channel(topic)
      this.currentRoom.join()
      this.currentRoom.on("new_message", resp => {
        this.strangerMessage(resp.body, resp.sender !== this.id)
      })
    })

    this.myChannel.on("leave_room", resp => {
      const topic = resp.topic
      let room = this.socket.channels.find(channel => {
        return channel.topic === topic
      })
      room.leave()
      this.currentRoom = undefined

      if(topic !== "lobby") {
        this.clear()
        this.systemMessage("Stranger left the chat")
        this.joinLobby()
      }
    })
  }

  statsHandler(resp) {
    let noun = "stranger"

    if(resp.connections !== 1) {
      noun += "s"
    }

    this.stats.innerHTML = `${resp.connections} ${noun} online`
  }

  newMessage(message, messageClass) {
    this.messages.innerHTML += `<div class="message ${messageClass}">
<time class="message__time">${new Date().toLocaleTimeString()}</time>
<p class="message__content">${message}</p>
</div>`
    this.messages.scrollTop = this.messages.scrollHeight
  }

  strangerMessage(message, received) {
    if(received) {
      this.newMessage(message, "message--received")
    } else {
      this.newMessage(message, "message--sent")
    }
  }

  systemMessage(message) {
    this.newMessage(message, "message--system")
  }
}

export default Chat

