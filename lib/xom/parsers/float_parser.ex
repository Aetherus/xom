defmodule Xom.Parsers.FloatParser do

  defstruct buffer: ""

  defimpl Xom.Parsers.Parser, for: __MODULE__ do
    def new, do: %__MODULE__{}

    def update(%__MODULE__{buffer: buffer}, chunk) do
      %__MODULE__{buffer: buffer <> String.trim(chunk)}
    end

    def parse(%__MODULE__{buffer: buffer}) do
      String.to_float(buffer)
    end
  end
end
