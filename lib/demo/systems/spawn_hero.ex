defmodule Demo.Systems.SpawnHero do
  @moduledoc """
  Creates the hero entity from the specs.
  This system runs only once on Ecspanse startup.
  """
  use Ecspanse.System

  @impl true
  def run(_frame) do
    hero_entity = %Ecspanse.Entity{} = Ecspanse.Command.spawn_entity!(Demo.Entities.Hero.new())

    potion_entity_1 =
      %Ecspanse.Entity{} = Ecspanse.Command.spawn_entity!(Demo.Entities.Inventory.new_potion())

    potion_entity_2 =
      %Ecspanse.Entity{} = Ecspanse.Command.spawn_entity!(Demo.Entities.Inventory.new_potion())

    boots_entity =
      %Ecspanse.Entity{} = Ecspanse.Command.spawn_entity!(Demo.Entities.Inventory.new_boots())

    Ecspanse.Command.add_children!([
      {hero_entity, [potion_entity_1, potion_entity_2, boots_entity]}
    ])
  end
end
