defmodule Stranger.RoomTest do
  use ExUnit.Case

  alias Stranger.Room

  @id "my-test-id"
  @room "example"

  test "joining a room" do
    {:ok, pid} = Room.create(@room, [@id])
    assert {:ok, ^pid} = Room.join(@room, @id)

    assert {:error, "Room does not exist"} = Room.join("bad-room", @id)
    assert {:error, "ID not allowed to join room"} = Room.join(@room, "bad-id")
  end
end
