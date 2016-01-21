defmodule Stranger.IDChannel do
  use Phoenix.Channel

  def join("id", _params, socket) do
    {:ok, %{id: socket.assigns.stranger_id}, socket}
  end
end
