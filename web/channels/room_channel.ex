defmodule Stranger.RoomChannel do
  use Phoenix.Channel

  alias Stranger.Room

  def join("rooms:" <> name, _join_message, socket) do
    id = socket.assigns.stranger_id

    case Room.by_name(name) do
      nil -> {:error, "Room doesn't exist"}
      {_, ^id, _} -> {:ok, socket}
      {_, _, ^id} -> {:ok, socket}
      _ -> {:error, "You're not invited to that room"}
    end
  end

  def handle_in("new_message", %{"body" => body}, socket) do
    broadcast! socket, "new_message", %{body: body}
    {:noreply, socket}
  end

  def terminate(_msg, _socket) do
    # Close the room and notify the clients to leave
  end
end
