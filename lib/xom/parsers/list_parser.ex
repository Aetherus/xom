defmodule Xom.Parsers.ListParser do

  defstruct buffer: [], options: %{}

  defimpl Xom.Parsers.Parser, for: __MODULE__ do
    def new(options \\ %{}), do: %__MODULE__{options: options}

    def update(%__MODULE__{buffer: buffer} = parser, {chunk, _}) do
      %{parser | buffer: [chunk | buffer]}
    end

    def parse(%__MODULE__{buffer: buffer, options: options}) do
      {Enum.reverse(buffer), options}
    end
  end
end
