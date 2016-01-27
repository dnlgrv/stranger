defmodule Stranger.RoomTest do
  use ExUnit.Case

  alias Stranger.Room

  @id "my-test-id"
  @room "example"

  test "joining a room" do
    {:ok, pid} = Room.create(@room, [@id])
    assert {:ok, ^pid} = Room.join(@room, @id, test_pid)

    assert {:error, "Room does not exist"} = Room.join("bad-room", @id, test_pid)
    assert {:error, "ID not allowed to join room"} = Room.join(@room, "bad-id", test_pid)

    :global.whereis_name({:room, @room})
    |> GenServer.stop()
  end

  test "closes room when a 'joined' stranger goes down" do
    {:ok, pid} = Room.create(@room, [@id])
    ref = Process.monitor(pid)

    spawn fn ->
      Room.join(@room, @id, self)
    end

    assert_receive {:DOWN, ^ref, :process, ^pid, :normal}
  end

  defp test_pid do
    spawn fn ->
      receive do
      end
    end
  end
end
