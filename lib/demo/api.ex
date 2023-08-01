defmodule Demo.API do
  @moduledoc """
  Module to facilitate the frontent interaction with the game.
  """

  @spec fetch_hero_details() :: {:ok, map()} | {:error, :not_found}
  def fetch_hero_details do
    Ecspanse.Query.select(
      {Demo.Components.Hero, Demo.Components.Energy, Demo.Components.Position}
    )
    |> Ecspanse.Query.one()
    |> case do
      {hero, energy, position} ->
        %{
          name: hero.name,
          energy: energy.current,
          max_energy: energy.max,
          pos_x: position.x,
          pos_y: position.y
        }

      _ ->
        {:error, :not_found}
    end
  end
end
