defmodule Stranger.LobbyChannel do
  @moduledoc ~S"""
  Any strangers in this channel are currently available to be paired with
  another stranger.
  """

  use Phoenix.Channel

  def join("lobby", _join_msg, socket) do
    Stranger.Lobby.add(socket.assigns.stranger_id)
    {:ok, socket}
  end

  def terminate(_msg, socket) do
    Stranger.Lobby.remove(socket.assigns.stranger_id)
  end
end
