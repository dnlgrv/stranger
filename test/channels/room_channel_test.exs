defmodule Stranger.RoomChannelTest do
  use Stranger.ChannelCase

  setup do
    {:ok, socket} = connect(Stranger.StrangerSocket, %{})
    {:ok, _, socket} = subscribe_and_join(socket, "rooms:example", %{})
    {:ok, %{socket: socket}}
  end

  test "broadcasts messages in that room", %{socket: socket} do
    push socket, "new_message", %{"body" => "test message"}
    assert_broadcast "new_message", %{body: "test message"}
  end
end
