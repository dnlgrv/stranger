defmodule Stranger.Channel.Room do
  use Phoenix.Channel

  alias Stranger.Room

  def join("room:" <> name, _msg, socket) do
    case Room.join(name, socket.assigns.id, socket.channel_pid) do
      {:ok, pid} ->
        Process.link(pid)
        {:ok, socket}
      {:error, _reason} ->
        {:error, %{}}
    end
  end

  def handle_in("message", %{"body" => body}, socket) do
    broadcast_message(body, socket)
  end

  defp broadcast_message("", socket), do: {:noreply, socket}
  defp broadcast_message(msg, socket) do
    msg = HtmlSanitizeEx.strip_tags(msg)
    broadcast! socket, "message", %{body: msg, sender: socket.assigns.id}
    {:noreply, socket}
  end
end
