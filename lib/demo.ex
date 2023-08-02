defmodule Demo do
  use Ecspanse

  alias Demo.Systems

  @impl Ecspanse
  def setup(data) do
    data
    |> Ecspanse.add_startup_system(Systems.SpawnHero)
    |> Ecspanse.add_system(Systems.MoveHero)
  end
end
