defmodule Stranger.LobbyChannelTest do
  use Stranger.ChannelCase

  alias Stranger.Pool

  setup do
    on_exit fn ->
      Enum.each(Pool.all(), &Pool.remove/1)
    end

    {:ok, socket} = connect(Stranger.StrangerSocket, %{})
    {:ok, %{socket: socket}}
  end

  test "joining adds the stranger to the pool", %{socket: socket} do
    join(socket, "lobby")
    assert Pool.all() == [socket.assigns.stranger_id]
  end

  test "leaving removes the stranger from the pool", %{socket: socket} do
    {:ok, _, socket} = join(socket, "lobby")
    Process.unlink(socket.channel_pid)
    close(socket)

    assert Pool.all() == []
  end
end
