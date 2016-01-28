defmodule Stranger.Channel.Lobby do
  use Phoenix.Channel

  alias Stranger.{Lobby, Room}

  def join("lobby", _msg, socket) do
    Lobby.join(socket.assigns.id, socket.channel_pid)
    try_find_match(socket)
    {:ok, socket}
  end

  def handle_info({:join_room, name}, socket) do
    push socket, "join_room", %{name: name}
    {:noreply, socket}
  end

  defp random_name do
    :crypto.strong_rand_bytes(32) |> Base.encode64()
  end

  defp try_find_match(socket) do
    spawn fn ->
      filtered_strangers =
        Lobby.strangers
        |> Enum.filter(&(&1 != socket.assigns.id))

      if Enum.count(filtered_strangers) > 0 do
        random_stranger = Enum.random(filtered_strangers)

        room_name = "room-#{random_name}"
        {:ok, _} = Room.create(room_name, [socket.assigns.id, random_stranger])

        send(socket.channel_pid, {:join_room, room_name})
        send(Lobby.find(random_stranger), {:join_room, room_name})
      end
    end
  end
end
