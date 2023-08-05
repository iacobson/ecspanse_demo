defmodule Demo.API do
  @moduledoc """
  Module to facilitate the frontent interaction with the game.
  """

  @spec fetch_hero_details() :: {:ok, map()} | {:error, :not_found}
  def fetch_hero_details do
    Ecspanse.Query.select(
      {Ecspanse.Entity, Demo.Components.Hero, Demo.Components.Energy, Demo.Components.Position}
    )
    |> Ecspanse.Query.one()
    |> case do
      {hero_entity, hero, energy, position} ->
        %{
          name: hero.name,
          energy: energy.current,
          max_energy: energy.max,
          pos_x: position.x,
          pos_y: position.y,
          resources: list_hero_resources(hero_entity),
          inventory: list_hero_inventory(hero_entity)
        }

      _ ->
        {:error, :not_found}
    end
  end

  @spec move_hero(direction :: :up | :down | :left | :right) :: :ok
  def move_hero(direction) do
    Ecspanse.event({Demo.Events.MoveHero, direction: direction})
  end

  defp list_hero_resources(hero_entity) do
    hero_entity
    |> Ecspanse.Query.list_tagged_components_for_entity([:resource, :available])
    |> Enum.map(&%{name: &1.name, amount: &1.amount})
  end

  defp list_hero_inventory(hero_entity) do
    hero_entity
    |> Demo.Entities.Inventory.list_inventory_components()
    |> Enum.map(&%{name: &1.name})
  end

  @spec fetch_market_items() :: {:ok, list(map())} | {:error, :not_found}
  def fetch_market_items do
    with {:ok, market_entity} <- fetch_market_entity() do
      list_market_items(market_entity)
    end
  end

  defp list_market_items(market_entity) do
    market_entity
    |> Demo.Entities.Inventory.list_inventory_components()
    |> Enum.map(fn item_component ->
      item_entity = Ecspanse.Query.get_component_entity(item_component)

      %{entity_id: item_entity.id, name: item_component.name, cost: item_cost(item_entity)}
    end)
  end

  defp item_cost(item_entity) do
    item_entity
    |> Ecspanse.Query.list_tagged_components_for_entity([:resource, :cost])
    |> Enum.map(&%{name: &1.name, amount: &1.amount})
  end

  @spec can_purchase_market_item?(item_entity_id :: Ecspanse.Entity.id()) :: :ok
  def can_purchase_market_item?(item_entity_id) do
    with {:ok, item_entity} <- Ecspanse.Query.fetch_entity(item_entity_id),
         {:ok, market_entity} <- fetch_market_entity(),
         {:ok, hero_entity} <- Demo.Entities.Hero.fetch(),
         true <- Ecspanse.Query.is_child_of?(parent: market_entity, child: item_entity) do
      hero_available_resources_components =
        Ecspanse.Query.list_tagged_components_for_entity(hero_entity, [:resource, :available])

      item_cost_components =
        Ecspanse.Query.list_tagged_components_for_entity(item_entity, [:resource, :cost])

      has_enough_resources?(hero_available_resources_components, item_cost_components)
    else
      _ -> false
    end
  end

  @spec purchase_market_item(item_entity_id :: Ecspanse.Entity.id()) :: :ok
  def purchase_market_item(item_entity_id) do
    Ecspanse.event({Demo.Events.PurchaseMarketItem, item_entity_id: item_entity_id})
  end

  defp fetch_market_entity do
    Ecspanse.Query.select({Ecspanse.Entity}, with: [Demo.Components.Market])
    |> Ecspanse.Query.one()
    |> case do
      {market_entity} -> {:ok, market_entity}
      _ -> {:error, :not_found}
    end
  end

  defp has_enough_resources?(available_resources, cost_resources) do
    Enum.all?(cost_resources, fn cost_resource ->
      Enum.any?(available_resources, fn available_resource ->
        available_resource.id == cost_resource.id &&
          available_resource.amount >= cost_resource.amount
      end)
    end)
  end
end
