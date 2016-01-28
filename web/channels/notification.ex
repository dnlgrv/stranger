defmodule Stranger.Channel.Notification do
  use Phoenix.Channel

  def join("notification", _msg, socket) do
    Stranger.Monitor.monitor(socket.channel_pid)
    {:ok, %{online: Stranger.Monitor.count}, socket}
  end
end
