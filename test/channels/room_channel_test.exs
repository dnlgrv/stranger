defmodule Stranger.RoomChannelTest do
  use Stranger.ChannelCase

  alias Stranger.Room

  setup do
    {:ok, socket} = connect(Stranger.StrangerSocket, %{})
    {:ok, %{socket: socket}}
  end

  test "broadcasts messages in that room", %{socket: socket} do
    id = socket.assigns.stranger_id
    Room.create("example", id, nil)
    {:ok, _, socket} = subscribe_and_join(socket, "rooms:example", %{})
    push socket, "new_message", %{"body" => "test message"}
    assert_broadcast "new_message", %{body: "test message", sender: id}
  end

  test "error if room hasn't been created", %{socket: socket} do
    {:error, "Room doesn't exist"} = join(socket, "rooms:missing", %{})
  end

  test "error if the stranger isn't allowed in the room", %{socket: socket} do
    Room.create("example", "id1", "id2")
    {:error, "You're not invited to that room"} = join(socket, "rooms:example", %{})
  end

  test "joining the room if you're allowed", %{socket: socket} do
    id = socket.assigns.stranger_id

    Room.create("example", id, "other")
    {:ok, _, _} = join(socket, "rooms:example")
    Room.delete("example")

    Room.create("example", "other", id)
    {:ok, _, _} = join(socket, "rooms:example")
    Room.delete("example")
  end

  test "leaving the room", %{socket: socket} do
    id = socket.assigns.stranger_id
    {:ok, _, socket} = subscribe_and_join(socket, "strangers:#{id}")

    @endpoint.subscribe(self(), "strangers:id2")

    Room.create("example", id, "id2")
    {:ok, _, socket} = join(socket, "rooms:example")
    Process.unlink(socket.channel_pid)
    close(socket)

    # Both IDs should be told to leave
    assert_broadcast "leave_room", %{topic: "rooms:example"}
    assert_broadcast "leave_room", %{topic: "rooms:example"}

    refute Room.by_name("example")
  end
end
