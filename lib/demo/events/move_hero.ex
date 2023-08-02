defmodule Demo.Events.MoveHero do
  @moduledoc """
  Event requesting to change the hero's position.
  """
  use Ecspanse.Event, fields: [:direction]
end
