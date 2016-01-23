defmodule Stranger.IDChannel do
  use Phoenix.Channel

  alias Stranger.Stats

  def join("id", _params, socket) do
    Stats.increment("connections")
    send(self(), :broadcast_stats)
    {:ok, %{id: socket.assigns.stranger_id}, socket}
  end

  def handle_info(:broadcast_stats, socket) do
    broadcast_stats()
    {:noreply, socket}
  end

  def terminate(_msg, _socket) do
    Stats.decrement("connections")
    broadcast_stats()
  end

  defp broadcast_stats do
    Stranger.Endpoint.broadcast! "id", "stats", Stats.all
  end
end
