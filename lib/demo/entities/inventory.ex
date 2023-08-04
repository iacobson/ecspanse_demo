defmodule Demo.Entities.Inventory do
  @moduledoc """
  Constructor for inventory entities
  """
  alias Demo.Components

  @spec new_boots() :: Ecspanse.Entity.entity_spec()
  def new_boots do
    {Ecspanse.Entity, components: [Components.Boots, {Components.Gold, [amount: 3], [:cost]}]}
  end

  @spec new_compass() :: Ecspanse.Entity.entity_spec()
  def new_compass do
    {Ecspanse.Entity,
     components: [
       Components.Compass,
       {Components.Gold, [amount: 3], [:cost]},
       {Components.Gems, [amount: 2], [:cost]}
     ]}
  end

  @spec new_map() :: Ecspanse.Entity.entity_spec()
  def new_map do
    {Ecspanse.Entity, components: [Components.Map, {Components.Gold, [amount: 2], [:cost]}]}
  end

  @spec new_potion() :: Ecspanse.Entity.entity_spec()
  def new_potion do
    {Ecspanse.Entity, components: [Components.Potion, {Components.Gold, [amount: 1], [:cost]}]}
  end

  @spec list_inventory_components(Ecspanse.Entity.t()) :: [component :: struct()]
  def list_inventory_components(parent) do
    Ecspanse.Query.list_tagged_components_for_children(parent, [:inventory])
  end
end
