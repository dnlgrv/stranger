defmodule Stranger.Channel.Room do
  use Phoenix.Channel

  alias Stranger.Room

  def join("room:" <> name, _msg, socket) do
    case Room.join(name, socket.assigns.id, socket.channel_pid) do
      {:ok, pid} ->
        {:ok, socket}
      {:error, _reason} ->
        {:error, %{}}
    end
  end
end
