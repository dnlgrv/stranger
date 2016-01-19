defmodule Stranger.ConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      import Stranger.Router.Helpers

      # The default endpoint for testing
      @endpoint Stranger.Endpoint
    end
  end

  setup do
    {:ok, conn: Phoenix.ConnTest.conn()}
  end
end
