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

  def terminate(_msg, socket) do
    {room_name, id1, id2} = Room.by_stranger(socket.assigns.stranger_id)
    Enum.each([id1, id2], &(leave_room(&1, room_name)))
    Room.delete(room_name)
  end

  defp leave_room(id, room_name) do
    Stranger.Endpoint.broadcast "strangers:#{id}",
                                "leave_room",
                                %{topic: "rooms:#{room_name}"}
  end
end
