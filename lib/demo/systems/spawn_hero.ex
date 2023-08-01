defmodule Demo.Systems.SpawnHero do
  @moduledoc """
  Creates the hero entity from the specs.
  This system runs only once on Ecspanse startup.
  """
  use Ecspanse.System

  @impl true
  def run(_frame) do
    %Ecspanse.Entity{} = Ecspanse.Command.spawn_entity!(Demo.Entities.Hero.new())
  end
end
