defmodule Stranger.LobbyChannelTest do
  use Stranger.ChannelCase

  alias Stranger.Lobby

  setup do
    {:ok, socket} = connect(Stranger.StrangerSocket, %{})
    {:ok, %{socket: socket}}
  end

  test "joining adds the stranger to the lobby", %{socket: socket} do
    join(socket, "lobby")
    assert Lobby.all() == [socket.assigns.stranger_id]
  end

  test "leaving removes the stranger from the lobby", %{socket: socket} do
    {:ok, _, socket} = join(socket, "lobby")
    Process.unlink(socket.channel_pid)
    close(socket)

    assert Lobby.all() == []
  end
end
