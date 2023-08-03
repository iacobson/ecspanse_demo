defmodule Demo.Components.EnergyTimer do
  @moduledoc """
  The special timer component that keeps track of the hero's energy regeneration.
  It emits an `EnergyTimerFinished` event when the timer is complete.
  The default duration is 3000ms.
  """
  use Ecspanse.Component.Timer,
    state: [duration: 3000, event: Demo.Events.EnergyTimerFinished, mode: :repeat]
end
