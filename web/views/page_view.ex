defmodule Stranger.PageView do
  @moduledoc false

  use Stranger.Web, :view

  def render("wrapper_class_index.html", _assigns) do
    "wrapper--chat"
  end
end
