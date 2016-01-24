defmodule Stranger.PageView do
  use Stranger.Web, :view

  def render("wrapper_class_index.html", _assigns) do
    "wrapper--chat"
  end
end
