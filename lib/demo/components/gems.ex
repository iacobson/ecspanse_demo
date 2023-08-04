defmodule Demo.Components.Gems do
  @moduledoc """
  Gems resource.
  Can be used as both available and cost.
  """
  use Ecspanse.Component, state: [name: "Gems", amount: 0], tags: [:resource]
end
