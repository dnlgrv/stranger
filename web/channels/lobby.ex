defmodule Stranger.Channel.Lobby do
  use Phoenix.Channel

  alias Stranger.Lobby

  def join("lobby", _msg, socket) do
    Lobby.join(socket.assigns.id, socket.channel_pid)
    {:ok, socket}
  end
end
