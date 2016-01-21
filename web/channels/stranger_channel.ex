defmodule Stranger.StrangerChannel do
  use Phoenix.Channel

  def join("strangers:" <> id, _auth_message, socket) do
    case socket.assigns.stranger_id == id do
      true -> {:ok, socket}
      false -> {:error, "Unauthorised"}
    end
  end
end
