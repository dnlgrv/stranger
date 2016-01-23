defmodule Stranger.IDChannelTest do
  use Stranger.ChannelCase

  setup do
    {:ok, socket} = connect(Stranger.StrangerSocket, %{})
    {:ok, %{id: id}, socket} = subscribe_and_join(socket, "id", %{})

    on_exit fn ->
      Stranger.Stats.reset()
    end

    {:ok, %{socket: socket, id: id}}
  end

  test "joining replies with your socket ID", %{socket: socket, id: id} do
    assert id == socket.assigns.stranger_id
  end

  test "joining increases the connections stat" do
    assert Stranger.Stats.all == %{
      "connections" => 1
    }
  end

  test "leaving decreases the connections stat", %{socket: socket} do
    Process.unlink(socket.channel_pid)
    close(socket)
    assert Stranger.Stats.all == %{
      "connections" => 0
    }
  end

  test "broadcasts a stats message", %{socket: socket} do
    assert_broadcast "stats", %{"connections" => 1}
    Process.unlink(socket.channel_pid)
    close(socket)
    assert_broadcast "stats", %{"connections" => 0}
  end
end
