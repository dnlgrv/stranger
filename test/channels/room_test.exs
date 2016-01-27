defmodule Stranger.Channel.RoomTest do
  use Stranger.ChannelCase

  alias Stranger.Room

  @id "my-test-id"
  @room "example"

  setup do
    on_exit fn ->
      case :global.whereis_name({:room, @room}) do
        :undefined -> :ok
        pid -> GenServer.stop(pid)
      end
    end

    {:ok, room} = Room.create(@room, [@id])
    {:ok, socket} = connect(Stranger.Socket, %{"id" => @id})
    {:ok, %{socket: socket, room: room}}
  end

  test "joining a room", %{socket: socket} do
    assert {:ok, _, _socket} = join(socket, "room:" <> @room)
  end

  test "failing to join a room", %{socket: socket} do
    assert {:error, _} = join(socket, "room:invalid")
    assert {:error, _} = join(socket, "room:other")
  end

  test "leaving the room kills the room", %{socket: socket, room: room} do
    room_ref = Process.monitor(room)

    {:ok, _, socket} = join(socket, "room:" <> @room)
    Process.unlink(socket.channel_pid)

    ref = leave(socket)
    assert_reply ref, :ok

    assert_receive {:DOWN, ^room_ref, :process, ^room, _}
  end
end
