defmodule Stranger.Channel.NotificationTest do
  use Stranger.ChannelCase

  setup do
    @endpoint.subscribe(self, "notification")
    :ok
  end

  test "returns the number of connections in the reply" do
    {:ok, socket} = connect(Stranger.Socket, %{"id" => "another-id"})

    assert {:ok, %{online: 1}, _socket} = join(socket, "notification")
  end

  test "connecting broadcasts a notification" do
    {:ok, socket} = connect(Stranger.Socket, %{"id" => "another-id"})
    join(socket, "notification")

    assert_broadcast "stats", %{online: 1}
  end

  test "leaving broadcasts a notification" do
    {:ok, socket} = connect(Stranger.Socket, %{"id" => "another-id"})
    {:ok, _, socket} = join(socket, "notification")

    assert_broadcast "stats", %{online: 1}

    Process.unlink(socket.channel_pid)
    ref = leave(socket)
    assert_reply ref, :ok

    assert_broadcast "stats", %{online: 0}
  end
end
