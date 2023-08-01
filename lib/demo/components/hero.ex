defmodule Demo.Components.Hero do
  @moduledoc """
  The Hero component. It holds some state related to the hero.
  """
  use Ecspanse.Component, state: [name: "Hero"]
end
