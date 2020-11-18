defmodule LofterWeb.HomeView do
  use LofterWeb, :view

  def render("index", assigns) do; end

  def timely_greeting() do
    cond do
      Enum.member?(0..4, Time.utc_now().hour) ->
        "You could probably get a few more hours of sleep?"
      Enum.member?(5..6, Time.utc_now().hour) ->
        "Early bird gets the worm."
      Enum.member?(7..11, Time.utc_now().hour) ->
        "Good morning."
      Enum.member?(12..15, Time.utc_now().hour) ->
        "Good afternoon."
      Enum.member?(16..19, Time.utc_now().hour) ->
        "Good evening."
      Enum.member?(20..23, Time.utc_now().hour) ->
        "Get some sleep for tomorrow."
    end
  end
end
