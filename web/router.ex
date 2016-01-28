defmodule Stranger.Router do
  @moduledoc false

  use Stranger.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", Stranger do
    pipe_through :browser

    get "/", PageController, :index
    get "/agreement", PageController, :agreement
  end
end
