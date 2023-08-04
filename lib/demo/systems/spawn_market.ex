defmodule Demo.Systems.SpawnMarket do
  @moduledoc """
  Creates the market entity from the specs.
  This system runs only once on Ecspanse startup.
  """
  use Ecspanse.System

  @impl true
  def run(_frame) do
    compass_entity =
      %Ecspanse.Entity{} = Ecspanse.Command.spawn_entity!(Demo.Entities.Inventory.new_compass())

    map_entity =
      %Ecspanse.Entity{} = Ecspanse.Command.spawn_entity!(Demo.Entities.Inventory.new_map())

    Ecspanse.Command.spawn_entity!({
      Ecspanse.Entity,
      components: [Demo.Components.Market], children: [compass_entity, map_entity]
    })
  end
end
