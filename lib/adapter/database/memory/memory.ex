defmodule CleanArchitecture.Adapter.Database.Memory do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @spec insert(Ecto.Changeset.t(), module()) :: :ok | {:error, any}
  def insert(changeset, mod) do
    with :ok <- changeset_valid?(changeset),
         :ok <- constraints(changeset, mod),
         {:ok, data} <- Ecto.Changeset.apply_action(changeset, :insert) do
      Agent.update(__MODULE__, fn state ->
        state
        |> Map.get_and_update(mod, fn
          nil -> {nil, [data]}
          [] -> {[], [data]}
          value -> {value, [value] ++ [data]}
        end)
        |> elem(1)
      end)

      {:ok, data}
    end
  end

  defp constraints(%Ecto.Changeset{constraints: constraints} = changeset, mod) do
    errors =
      constraints
      |> Enum.reduce([], fn constraint, acc -> [constraint(constraint, changeset, mod)] ++ acc end)
      |> Enum.reject(&is_nil/1)

    case errors do
      [] -> :ok
      errors -> {:error, errors}
    end
  end

  defp constraint(%{type: :unique, field: field, error_message: error_message}, %{params: params}, mod) do
    param_field = Atom.to_string(field)

    case one(&(Map.get(&1, field) == params[param_field]), mod) do
      {:ok, nil} -> nil
      {:error, :unknown_domain} -> nil
      {:ok, _value} -> {:error, "#{field} #{error_message}"}
      {:error, error} -> {:error, error}
    end
  end

  @spec one((any -> boolean()), module()) :: {:ok, any() | nil} | {:error, :unknown_domain}
  def one(fun, mod) do
    Agent.get(__MODULE__, fn state ->
      case Map.get(state, mod) do
        nil -> {:error, :unknown_domain}
        elements -> {:ok, Enum.find(elements, fun)}
      end
    end)
  end

  @spec delete(any, module()) :: :ok
  def delete(nil, _), do: nil

  def delete(element, mod) do
    Agent.update(__MODULE__, fn state ->
      state
      |> Map.get_and_update(mod, fn value ->
        new_value = List.delete(value, element)
        {value, new_value}
      end)
      |> elem(1)
    end)
  end

  @spec all(module()) :: list(any())
  def all(mod) do
    Agent.get(__MODULE__, fn state -> Map.get(state, mod, {:error, :unknown_domain}) end)
  end

  defp changeset_valid?(%Ecto.Changeset{valid?: true}), do: :ok
  defp changeset_valid?(%Ecto.Changeset{valid?: false, errors: errors}), do: {:error, errors}
end
