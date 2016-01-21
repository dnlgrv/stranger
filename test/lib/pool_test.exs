defmodule Stranger.PoolTest do
  use ExUnit.Case, async: true

  alias Stranger.Pool

  test "adding and removing from the pool" do
    Pool.add("123")
    assert Pool.all() == ["123"]
    Pool.remove("123")
    assert Pool.all() == []
  end
end
