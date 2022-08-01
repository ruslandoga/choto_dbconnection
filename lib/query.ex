defmodule Choto.Connection.Query do
  @moduledoc false
  defstruct [:statement, :command]

  @type command :: :select | :insert | :update | :alter | nil
  @type t :: %__MODULE__{statement: iodata(), command: command}

  @spec new(String.t()) :: t
  def new(statement) do
    %__MODULE__{statement: statement, command: extract_command(statement)}
  end

  defp extract_command(statement) do
    cond do
      String.contains?(statement, "SELECT") -> :select
      String.contains?(statement, "INSERT") -> :insert
      String.contains?(statement, "DELETE") -> :delete
      String.contains?(statement, "UPDATE") -> :update
      String.contains?(statement, "ALTER") -> :alter
      true -> nil
    end
  end

  defimpl DBConnection.Query do
    def parse(query, _opts), do: query
    def describe(query, _opts), do: query
    def encode(_query, params, _opts), do: params
    def decode(_query, result, _opts), do: result
  end

  defimpl String.Chars do
    def to_string(%{statement: statement}) do
      IO.iodata_to_binary(statement)
    end
  end
end
