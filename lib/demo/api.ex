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
          resources: list_hero_resources(hero_entity)
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
end
