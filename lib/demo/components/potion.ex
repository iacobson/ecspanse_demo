defmodule Demo.Components.Potion do
  @moduledoc """
  Potion component
  """
  use Ecspanse.Component, state: [name: "Potion"], tags: [:inventory]
end
