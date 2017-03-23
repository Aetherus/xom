defmodule Xom.Parsers.StringParser do

  defstruct buffer: ""

  defimpl Xom.Parsers.Parser, for: __MODULE__ do
    def new, do: %__MODULE__{}

    def update(%__MODULE__{buffer: buffer}, chunk) do
      %__MODULE__{buffer: buffer <> HtmlEntities.decode(chunk)}
    end

    def parse(%__MODULE__{buffer: buffer}) do
      buffer
    end
  end
end
