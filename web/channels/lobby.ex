defmodule Stranger.Channel.Lobby do
  use Phoenix.Channel

  alias Stranger.Lobby

  def join("lobby", _msg, socket) do
    Lobby.join(socket.assigns.id, socket.channel_pid)
    try_find_match(socket)
    {:ok, socket}
  end

  def handle_info({:join_room, id}, socket) do
    push socket, "join_room", %{id: id}
    {:noreply, socket}
  end

  defp try_find_match(socket) do
    spawn fn ->
      filtered_strangers =
        Lobby.strangers
        |> Enum.filter(&(&1 != socket.assigns.id))

      if Enum.count(filtered_strangers) > 0 do
        random_stranger =
          filtered_strangers
          |> Enum.random()
          |> Lobby.find()

        send(socket.channel_pid, {:join_room, "some-room"})
        send(random_stranger, {:join_room, "some-room"})
      end
    end
  end
end
