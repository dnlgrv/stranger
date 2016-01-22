defmodule Stranger.IDChannelTest do
  use Stranger.ChannelCase

  test "joining replies with your socket ID" do
    {:ok, socket} = connect(Stranger.StrangerSocket, %{})
    {:ok, %{id: id}, socket} = join(socket, "id", %{})

    assert id == socket.assigns.stranger_id
  end
end
