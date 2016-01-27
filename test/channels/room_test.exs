defmodule Stranger.Channel.RoomTest do
  use Stranger.ChannelCase

  alias Stranger.Room

  @id "my-test-id"

  setup do
    room = :crypto.strong_rand_bytes(32) |> Base.encode64()
    {:ok, room_pid} = Room.create(room, [@id])
    {:ok, socket} = connect(Stranger.Socket, %{"id" => @id})
    {:ok, %{socket: socket, room: room, room_pid: room_pid}}
  end

  test "failing to join a room", %{socket: socket} do
    assert {:error, _} = join(socket, "room:invalid")
    assert {:error, _} = join(socket, "room:other")
  end

  test "leaving the room kills the room", %{socket: socket, room: room, room_pid: room_pid} do
    room_ref = Process.monitor(room_pid)

    {:ok, _, socket} = join(socket, "room:" <> room)
    Process.unlink(socket.channel_pid)

    ref = leave(socket)
    assert_reply ref, :ok

    assert_receive {:DOWN, ^room_ref, :process, ^room_pid, _}
  end

  test "sending and receiving messages", %{socket: socket, room: room} do
    {:ok, _, socket} = subscribe_and_join(socket, "room:" <> room)
    push socket, "message", %{"body" => "test message"}
    assert_broadcast "message", %{body: "test message",
                                  sender: @id}
  end

  test "removes any HTML tags, leaving text", %{socket: socket, room: room} do
    {:ok, _, socket} = subscribe_and_join(socket, "room:" <> room)
    push socket, "message", %{"body" => "<strong>test message</strong>"}
    assert_broadcast "message", %{body: "test message"}
  end

  test "doesn't broadcast empty messages", %{socket: socket, room: room} do
    {:ok, _, socket} = subscribe_and_join(socket, "room:" <> room)
    push socket, "message", %{"body" => ""}
    refute_broadcast "message", %{body: ""}
  end
end
