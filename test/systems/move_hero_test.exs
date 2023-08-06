defmodule Demo.Systems.MoveHeroTest do
  @moduledoc """
  The Ecspanse.Server does not start by default in test mode.
  This allows running systems in isolation, without being triggered each frame by the server.

  A test server should be manully started when running tests.
  ```elixir
  start_supervised({SomeTestModule, :test})
  ```
  The `:test` arg is required to start the Ecspanse.Server.
  The same can be done with the real project setup if needed to run a real working system.

  ```elixir
  start_supervised({Demo, :test})
  ```
  """

  use ExUnit.Case, async: false

  defmodule DemoTest do
    @moduledoc "A test module that does not schedule any system"
    use Ecspanse
    @impl true
    def setup(data) do
      data
    end
  end

  setup do
    {:ok, _pid} = start_supervised({DemoTest, :test})
    Ecspanse.System.debug()

    hero_entity = %Ecspanse.Entity{} = Ecspanse.Command.spawn_entity!(Demo.Entities.Hero.new())
    {:ok, position_component} = Demo.Components.Position.fetch(hero_entity)

    assert position_component.x == 0
    assert position_component.y == 0

    {:ok, energy_component} = Demo.Components.Energy.fetch(hero_entity)
    assert energy_component.current == 50

    {:ok, hero_entity: hero_entity, energy_component: energy_component}
  end

  test "hero moves if enough energy", %{hero_entity: hero_entity} do
    event = move(:up)
    frame = frame(event)
    Demo.Systems.MoveHero.run(event, frame)

    {:ok, position_component} = Demo.Components.Position.fetch(hero_entity)
    assert position_component.x == 0
    assert position_component.y == 1

    {:ok, energy_component} = Demo.Components.Energy.fetch(hero_entity)
    assert energy_component.current == 49

    event = move(:right)
    frame = frame(event)
    Demo.Systems.MoveHero.run(event, frame)

    {:ok, position_component} = Demo.Components.Position.fetch(hero_entity)
    assert position_component.x == 1
    assert position_component.y == 1

    {:ok, energy_component} = Demo.Components.Energy.fetch(hero_entity)
    assert energy_component.current == 48

    event = move(:down)
    frame = frame(event)
    Demo.Systems.MoveHero.run(event, frame)

    {:ok, position_component} = Demo.Components.Position.fetch(hero_entity)
    assert position_component.x == 1
    assert position_component.y == 0

    {:ok, energy_component} = Demo.Components.Energy.fetch(hero_entity)
    assert energy_component.current == 47

    event = move(:left)
    frame = frame(event)
    Demo.Systems.MoveHero.run(event, frame)

    {:ok, position_component} = Demo.Components.Position.fetch(hero_entity)
    assert position_component.x == 0
    assert position_component.y == 0

    {:ok, energy_component} = Demo.Components.Energy.fetch(hero_entity)
    assert energy_component.current == 46
  end

  test "hero doesn not move if not enough energy", %{
    hero_entity: hero_entity,
    energy_component: energy_component
  } do
    Ecspanse.Command.update_component!(energy_component, current: 0)

    event = move(:up)
    frame = frame(event)
    Demo.Systems.MoveHero.run(event, frame)

    {:ok, position_component} = Demo.Components.Position.fetch(hero_entity)
    assert position_component.x == 0
    assert position_component.y == 0

    {:ok, energy_component} = Demo.Components.Energy.fetch(hero_entity)
    assert energy_component.current == 0
  end

  defp move(direction) do
    %Demo.Events.MoveHero{direction: direction, inserted_at: System.os_time()}
  end

  defp frame(event) do
    %Ecspanse.Frame{event_batches: [[event]], delta: 1}
  end
end
