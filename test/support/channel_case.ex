defmodule Stranger.ChannelCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with channels
      use Phoenix.ChannelTest

      # The default endpoint for testing
      @endpoint Stranger.Endpoint
    end
  end

  setup do
    on_exit fn ->
      # Clean up the pool after each test run
      Enum.each(Stranger.Pool.all(), &Stranger.Pool.remove/1)
    end

    :ok
  end
end
