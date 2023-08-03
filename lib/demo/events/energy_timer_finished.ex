defmodule Demo.Events.EnergyTimerFinished do
  @moduledoc """
  Timer event
  The energy timer has reached zero.
  """
  use Ecspanse.Event.Timer
end
