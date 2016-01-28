defmodule Stranger.Channel.Notification do
  @moduledoc false

  use Phoenix.Channel

  alias Stranger.Notification

  def join("notification", _msg, socket) do
    Notification.monitor(socket.channel_pid)
    {:ok, %{online: Notification.count}, socket}
  end
end
