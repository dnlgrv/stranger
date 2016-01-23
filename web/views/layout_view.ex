defmodule Stranger.LayoutView do
  use Stranger.Web, :view

  def ga_tracking_code do
    Application.get_env(:stranger, :ga_tracking_code)
  end
end
