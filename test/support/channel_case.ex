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
      # Clean up lobby and rooms
      Enum.each(Stranger.Lobby.all(), &Stranger.Lobby.remove/1)
      Enum.each(Stranger.Room.all(), &Stranger.Room.delete/1)
    end

    :ok
  end
end
