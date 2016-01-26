defmodule Stranger.SocketTest do
  use Stranger.ChannelCase

  test "assigns ID to the socket" do
    {:ok, socket} = connect(Stranger.Socket, %{"id" => "my-id"})
    assert socket.assigns.id == "my-id"
  end
end
