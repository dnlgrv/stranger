defmodule Stranger.RoomChannel do
  use Phoenix.Channel

  def join(_, _join_message, socket) do
    # Validate that the strangers can join this room
    {:ok, socket}
  end

  def handle_in("new_message", %{"body" => body}, socket) do
    broadcast! socket, "new_message", %{body: body}
    {:noreply, socket}
  end

  def terminate(_msg, _socket) do
    # Close the room and notify the clients to leave
  end
end
