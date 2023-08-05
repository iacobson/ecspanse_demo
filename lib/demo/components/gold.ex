defmodule Demo.Components.Gold do
  @moduledoc """
  Gold resource.
  Can be used as both available and cost.
  """
  use Ecspanse.Component, state: [id: :gold, name: "Gold", amount: 0], tags: [:resource]
end
