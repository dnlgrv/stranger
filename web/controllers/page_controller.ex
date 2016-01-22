defmodule Stranger.PageController do
  use Stranger.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def agreement(conn, _params) do
    render conn, "agreement.html"
  end
end
