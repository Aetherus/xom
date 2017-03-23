defmodule Xom.Parsers.FileParser do

  defstruct buffer: ""

  defimpl Xom.Parsers.Parser, for: __MODULE__ do
    def new, do: %__MODULE__{}

    def update(%__MODULE__{buffer: buffer}, chunk) do
    end

    def parse(%__MODULE__{buffer: _}) do
      # TODO raise error
    end
  end
end
