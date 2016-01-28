defmodule Stranger.LobbyTest do
  use ExUnit.Case

  alias Stranger.Lobby

  @id "my-test-id"

  setup do
    on_exit fn ->
      Enum.each(Lobby.strangers, &Lobby.leave/1)
    end

    :ok
  end

  test "joining the lobby" do
    pid = test_pid

    assert Lobby.join(@id, pid) == :ok
    assert Lobby.find(@id) == pid
  end

  test "leaving the lobby by id" do
    Lobby.join(@id, test_pid)
    assert Lobby.leave(@id) == :ok
    refute Lobby.find(@id)
  end

  test "all strangers" do
    Lobby.join(@id, test_pid)
    Lobby.join("another-id", test_pid)
    assert Lobby.strangers == ["another-id", @id]
  end

  test "leaves the lobby when pid goes down" do
    pid = spawn fn ->
      receive do
        {:join, from} ->
          Lobby.join(@id, self)
          send(from, :joined) # process dies
      end
    end

    send(pid, {:join, self})
    receive do
      :joined ->
        refute Lobby.find(@id)
    end
  end

  defp test_pid do
    spawn fn ->
      receive do
      end
    end
  end
end
