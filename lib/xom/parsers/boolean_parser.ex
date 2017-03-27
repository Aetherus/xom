defmodule Xom.Parsers.BooleanParser do

  defstruct buffer: "", options: %{}

  def new(options \\ %{}), do: %__MODULE__{options: options}

end

defimpl Xom.Parsers.Parser, for: Xom.Parsers.BooleanParser do
  alias Xom.Parsers.BooleanParser

  def update(%BooleanParser{buffer: buffer} = parser, chunk) do
    chunk = chunk |> String.trim() |> String.downcase()
    %{parser | buffer: buffer <> chunk}
  end

  def parse(%BooleanParser{buffer: "true", options: options}), do: {true, options}

  def parse(%BooleanParser{buffer: "false", options: options}), do: {false, options}

  def parse(%BooleanParser{buffer: _} = parser) do
    raise Xom.Parsers.ParseError, BooleanParser
  end
end
