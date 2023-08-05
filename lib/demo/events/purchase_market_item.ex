defmodule Demo.Events.PurchaseMarketItem do
  @moduledoc """
  Event requesting to purchase an item from the market by its entity id.
  """
  use Ecspanse.Event, fields: [:item_entity_id]
end
