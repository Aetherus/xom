defmodule Xom.Parsers.MapParser do

  defstruct buffer: %{}, options: %{}

  defimpl Xom.Parsers.Parser, for: __MODULE__ do
    def new(options \\ %{}), do: %__MODULE__{options: options}

    def update(%__MODULE__{buffer: buffer} = parser, {value, %{"name" => name}}) do
      %{parser | buffer: Map.put(buffer, name, value)}
    end

    def parse(%__MODULE__{buffer: buffer, options: options}) do
      {buffer, options}
    end
  end
end

