defmodule Stranger.PageController do
  @moduledoc false

  use Stranger.Web, :controller

  @id_length Application.get_env(:stranger, :id_length)

  def index(conn, _params) do
    render conn, "index.html", id: random_id()
  end

  def agreement(conn, _params) do
    render conn, "agreement.html"
  end

  defp random_id do
    :crypto.strong_rand_bytes(@id_length) |> Base.encode64()
  end
end
