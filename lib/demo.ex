defmodule Demo do
  @moduledoc """
  The system setup module.
  """
  use Ecspanse

  alias Demo.Systems

  @impl Ecspanse
  def setup(data) do
    data
    |> Ecspanse.add_startup_system(Systems.SpawnHero)
    |> Ecspanse.add_startup_system(Systems.SpawnMarket)
    |> Ecspanse.add_system(Systems.RestoreEnergy, run_if: [{__MODULE__, :energy_not_max}])
    |> Ecspanse.add_system(Systems.MoveHero, run_after: [Systems.RestoreEnergy])
    |> Ecspanse.add_system(Systems.MaybeFindResources)
    |> Ecspanse.add_frame_end_system(Systems.PurchaseMarketItem)
    |> Ecspanse.add_frame_end_system(Ecspanse.System.Timer)
    |> Ecspanse.add_frame_end_system(Ecspanse.System.TrackFPS)
  end

  def energy_not_max do
    # not the most efficient way to do this, as this will run every frame
    # but it's a good example of how to use the `run_if` option

    # it would be more efficient to check for the max energy in the RestoreEnergy system
    # that runs only once every 3 seconds

    Ecspanse.Query.select({Demo.Components.Energy}, with: [Demo.Components.Hero])
    |> Ecspanse.Query.one()
    |> case do
      {%Demo.Components.Energy{current: current, max: max}} ->
        current < max

      _ ->
        false
    end
  end
end
