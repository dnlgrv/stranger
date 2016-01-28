defmodule Stranger.LayoutView do
  @moduledoc false

  use Stranger.Web, :view

  def ga_tracking_code do
    Application.get_env(:stranger, :ga_tracking_code)
  end
end
