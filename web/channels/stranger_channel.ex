defmodule Stranger.StrangerChannel do
  use Phoenix.Channel

  def join("strangers:" <> id, _auth_message, socket) do
    case socket.assigns.stranger_id == id do
      true ->
        Stranger.Pool.add(id)
        {:ok, socket}
      false -> {:error, "Unauthorised"}
    end
  end

  def terminate(_msg, socket) do
    Stranger.Pool.remove(socket.assigns.stranger_id)
  end
end
