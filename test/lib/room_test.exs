defmodule Stranger.RoomTest do
  use ExUnit.Case

  alias Stranger.Room

  @id "my-test-id"

  setup do
    room = :crypto.strong_rand_bytes(32) |> Base.encode64()
    {:ok, %{room: room}}
  end

  test "joining a room", %{room: room} do
    {:ok, pid} = Room.create(room, [@id])
    assert {:ok, ^pid} = Room.join(room, @id, self)

    assert {:error, "Room does not exist"} = Room.join("bad-room", @id, self)
    assert {:error, "ID not allowed to join room"} = Room.join(room, "bad-id", self)
  end

  test "closes room when a 'joined' stranger goes down", %{room: room} do
    {:ok, pid} = Room.create(room, [@id])
    ref = Process.monitor(pid)

    spawn fn ->
      Room.join(room, @id, self)
    end

    assert_receive {:DOWN, ^ref, :process, ^pid, :normal}
  end
end
