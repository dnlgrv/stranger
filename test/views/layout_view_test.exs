defmodule Stranger.LayoutViewTest do
  use Stranger.ConnCase, async: true

  test "ga_tracking_code" do
    assert Stranger.LayoutView.ga_tracking_code == "test"
  end
end
