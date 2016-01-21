defmodule Stranger.LobbyTest do
  use ExUnit.Case, async: true

  alias Stranger.Lobby

  test "adding and removing from the lobby" do
    Lobby.add("123")
    assert Lobby.all() == ["123"]
    Lobby.remove("123")
    assert Lobby.all() == []
  end
end
