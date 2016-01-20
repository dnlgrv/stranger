defmodule Stranger.StrangerSocketTest do
  use Stranger.ChannelCase

  test "connecting assigns a random ID" do
    {:ok, socket} = connect(Stranger.StrangerSocket, %{})
    assert socket.assigns[:stranger_id]

    {:ok, other_socket} = connect(Stranger.StrangerSocket, %{})
    assert other_socket.assigns[:stranger_id] !=
           socket.assigns[:stranger_id]
  end
end
