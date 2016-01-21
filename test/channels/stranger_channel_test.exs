defmodule Stranger.StrangerChannelTest do
  use Stranger.ChannelCase

  setup do
    {:ok, socket} = connect(Stranger.StrangerSocket, %{})
    {:ok, %{socket: socket}}
  end

  test "only allows the stranger with a matching ID to enter", %{socket: socket} do
    id = socket.assigns.stranger_id

    assert {:ok, _, socket} = join(socket, "strangers:" <> id, %{})
    assert {:error, "Unauthorised"} = join(socket, "strangers:invalid", %{})
  end

  test "joining adds the stranger to the pool", %{socket: socket} do
    join(socket, "strangers:" <> socket.assigns.stranger_id, %{})
    assert Stranger.Pool.all() == [socket.assigns.stranger_id]
  end

  test "leaving removes the stranger from the pool", %{socket: socket} do
    {:ok, _, socket} = join(socket, "strangers:" <> socket.assigns.stranger_id, %{})
    Process.unlink(socket.channel_pid)
    close(socket)

    assert Stranger.Pool.all() == []
  end
end
