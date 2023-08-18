defmodule Demo.Components.Gold do
  @moduledoc """
  Gold resourceg, defined from the generic resource component.
  Can be used as both available and cost.
  """
  use Demo.Components.Resource,
    state: [id: :gold, name: "Gold", amount: 0],
    tags: [:resource]
end
