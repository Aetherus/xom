defmodule Xom.BooleanParser do

  defstruct buffer: [], options: %{}

  def new(options \\ %{}), do: %__MODULE__{options: options}

end

defimpl Xom.Parser, for: Xom.BooleanParser do
  alias Xom.{BooleanParser, ParseError}

  def update(%BooleanParser{buffer: buffer} = parser, chunk) do
    %{parser | buffer: [buffer, chunk]}
  end

  def parse(%BooleanParser{buffer: buffer, options: options}) do
    result = case String.trim(to_string(buffer)) do
      "true" -> true
      "false" -> false
      "" -> nil
      _ -> raise ParseError, BooleanParser
    end
    {result, options}
  end
end
