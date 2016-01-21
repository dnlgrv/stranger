defmodule Stranger.StrangerChannelTest do
  use Stranger.ChannelCase

  setup do
    {:ok, socket} = connect(Stranger.StrangerSocket, %{})
    {:ok, %{socket: socket}}
  end

  test "only allows the stranger with a matching ID to join", %{socket: socket} do
    id = socket.assigns.stranger_id

    assert {:ok, _, socket} = join(socket, "strangers:" <> id, %{})
    assert {:error, "Unauthorised"} = join(socket, "strangers:invalid", %{})
  end
end
