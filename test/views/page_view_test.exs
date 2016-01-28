defmodule Stranger.PageViewTest do
  use Stranger.ConnCase, async: true

  test "render wrapper_class_index.html" do
    assert Stranger.PageView.render("wrapper_class_index.html") == "wrapper--chat"
  end
end
