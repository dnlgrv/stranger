defmodule Stranger.Channel.LobbyTest do
  use Stranger.ChannelCase

  alias Stranger.Lobby

  @id "my-test-id"

  setup do
    {:ok, socket} = connect(Stranger.Socket, %{"id" => @id})
    {:ok, %{socket: socket}}
  end

  test "joining the lobby", %{socket: socket} do
    {:ok, _, socket} = join(socket, "lobby")
    assert Lobby.find(@id) == socket.channel_pid
  end

  test "leaving the lobby", %{socket: socket} do
    {:ok, _, socket} = join(socket, "lobby")
    Process.unlink(socket.channel_pid)
    ref = leave(socket)
    assert_reply ref, :ok
    refute Lobby.find(@id)
  end
end
