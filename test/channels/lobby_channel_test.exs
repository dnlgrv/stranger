defmodule Stranger.LobbyChannelTest do
  use Stranger.ChannelCase

  alias Stranger.Lobby

  setup do
    {:ok, socket} = connect(Stranger.StrangerSocket, %{})
    {:ok, _, socket} =
      socket
      |> subscribe_and_join("strangers:#{socket.assigns.stranger_id}")

    {:ok, %{socket: socket}}
  end

  test "finding a stranger to talk to", %{socket: socket} do
    {:ok, socket2} = connect(Stranger.StrangerSocket, %{})
    {:ok, _, socket2} =
      socket2
      |> subscribe_and_join("strangers:#{socket2.assigns.stranger_id}")

    Process.unlink(socket.channel_pid)
    Process.unlink(socket2.channel_pid)

    join(socket2, "lobby") # no one else in the lobby yet
    join(socket, "lobby") # match with the socket2 stranger

    assert_broadcast "leave_room", %{topic: "lobby"}
    assert_broadcast "leave_room", %{topic: "lobby"}

    assert_broadcast "join_room", %{topic: "rooms:" <> room}
    assert_broadcast "join_room", %{topic: "rooms:" <> ^room}

    close(socket)
    close(socket2)
  end

  test "joining adds the stranger to the lobby", %{socket: socket} do
    join(socket, "lobby")
    assert Lobby.all == [socket.assigns.stranger_id]
  end

  test "leaving removes the stranger from the lobby", %{socket: socket} do
    {:ok, _, socket} = join(socket, "lobby")
    Process.unlink(socket.channel_pid)
    close(socket)

    assert Lobby.all == []
  end
end
