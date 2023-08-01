defmodule Demo.Components.Energy do
  @moduledoc """
  The Hero Energy component.
  """
  use Ecspanse.Component, state: [current: 50, max: 100]
end
