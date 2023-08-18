defmodule Demo.Components.Resource do
  @moduledoc """
  Generic component, that defines the state for all resources in the game
  """
  use Ecspanse.Template.Component, state: [:id, :name, amount: 0], tags: [:resource]

  @impl true
  def validate(state) do
    with :ok <- validate_integer_amount(state[:amount]),
         :ok <- validate_positive_amount(state[:amount]) do
      :ok
    end
  end

  defp validate_integer_amount(amount) do
    if is_integer(amount) do
      :ok
    else
      {:error, "#{inspect(amount)} must be an integer"}
    end
  end

  defp validate_positive_amount(amount) do
    if amount >= 0 do
      :ok
    else
      {:error, "#{inspect(amount)} must be positive"}
    end
  end
end
