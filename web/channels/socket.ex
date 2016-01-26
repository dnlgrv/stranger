defmodule Stranger.Socket do
  use Phoenix.Socket

  ## Channels
  channel "lobby", Stranger.Channel.Lobby

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket

  def connect(%{"id" => id}, socket) do
    {:ok, assign(socket, :id, id)}
  end

  def id(socket) do
    "socket:#{socket.assigns.id}"
  end
end
