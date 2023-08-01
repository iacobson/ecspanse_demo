defmodule Demo.Entities.Hero do
  @moduledoc """
  Utilities for the Hero entity.
  """

  alias Demo.Components

  @spec new() :: Ecspanse.Entity.entity_spec()
  def new do
    {Ecspanse.Entity,
     components: [
       Components.Hero,
       Components.Energy,
       Components.Position
     ]}
  end

  @spec fetch() :: {:ok, Ecspanse.Entity.t()} | {:error, :not_found}
  def fetch do
    Ecspanse.Query.select({Ecspanse.Entity}, with: [Components.Hero])
    |> Ecspanse.Query.one()
    |> case do
      {%Ecspanse.Entity{} = entity} -> {:ok, entity}
      _ -> {:error, :not_found}
    end
  end
end
