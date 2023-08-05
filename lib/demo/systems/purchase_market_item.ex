defmodule Demo.Systems.PurchaseMarketItem do
  @moduledoc """
  The hero can purchase items form the market if:
  - the item exists in the market
  - the hero has enough resources
  """

  use Ecspanse.System,
    event_subscriptions: [Demo.Events.PurchaseMarketItem]

  @impl true
  def run(%Demo.Events.PurchaseMarketItem{item_entity_id: item_entity_id}, _frame) do
    with {:ok, item_entity} <- Ecspanse.Query.fetch_entity(item_entity_id),
         {:ok, market_entity} <- fetch_market_entity(),
         {:ok, hero_entity} <- Demo.Entities.Hero.fetch(),
         true <- Ecspanse.Query.is_child_of?(parent: market_entity, child: item_entity),
         hero_available_resources_components =
           Ecspanse.Query.list_tagged_components_for_entity(hero_entity, [:resource, :available]),
         item_cost_components =
           Ecspanse.Query.list_tagged_components_for_entity(item_entity, [:resource, :cost]),
         true <- has_enough_resources?(hero_available_resources_components, item_cost_components) do
      spend_resources(hero_available_resources_components, item_cost_components)
      Ecspanse.Command.remove_child!(market_entity, item_entity)
      Ecspanse.Command.add_child!(hero_entity, item_entity)
    end
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

  defp spend_resources(available_resources, cost_resources) do
    Enum.each(cost_resources, fn cost_resource ->
      available_resource =
        Enum.find(available_resources, fn available_resource ->
          available_resource.id == cost_resource.id
        end)

      Ecspanse.Command.update_component!(available_resource,
        amount: available_resource.amount - cost_resource.amount
      )
    end)
  end
end
