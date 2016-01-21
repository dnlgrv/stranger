defmodule Stranger.StrangerSocket do
  use Phoenix.Socket

  @id_length 64

  ## Channels
  channel "id", Stranger.IDChannel
  channel "strangers:*", Stranger.StrangerChannel
  channel "lobby", Stranger.LobbyChannel
  channel "rooms:*", Stranger.RoomChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket

  def connect(_params, socket) do
    {:ok, assign(socket, :stranger_id, random_id())}
  end

  def id(socket) do
    "stranger_socket:#{socket.assigns.stranger_id}"
  end

  defp random_id do
    @id_length
    |> :crypto.strong_rand_bytes()
    |> Base.encode64()
  end
end
