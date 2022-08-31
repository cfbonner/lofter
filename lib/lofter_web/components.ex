defmodule LofterWeb.Components do
  defmacro __using__(_) do
    quote do
      alias PetalComponents.Heroicons

      import LofterWeb.Components.{
        Tile,
      }
    end
  end
end
