defmodule Stranger.StatsTest do
  use ExUnit.Case, async: true

  alias Stranger.Stats

  setup do
    on_exit fn ->
      Stats.reset
    end

    :ok
  end

  test "incrementing a key" do
    Stats.increment("connections")
    Stats.increment("connections")

    assert Stats.all == %{
      "connections" => 2
    }
  end

  test "decrementing a key" do
    Stats.increment("connections")
    Stats.increment("connections")
    Stats.decrement("connections")

    assert Stats.all == %{
      "connections" => 1
    }
  end
end
