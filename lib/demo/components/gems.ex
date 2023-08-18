defmodule Demo.Components.Gems do
  @moduledoc """
  Gems resource defined from the generic resource component.
  Can be used as both available and cost.
  """
  use Demo.Components.Resource,
    state: [id: :gems, name: "Gems", amount: 0],
    tags: [:resource]
end
