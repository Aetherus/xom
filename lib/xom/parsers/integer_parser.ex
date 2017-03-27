defmodule Xom.Parsers.IntegerParser do

  defstruct buffer: "", options: %{}

  def new(options \\ %{}), do: %__MODULE__{options: options}

end

defimpl Xom.Parsers.Parser, for: Xom.Parsers.IntegerParser do
  alias Xom.Parsers.IntegerParser

  def update(%IntegerParser{buffer: buffer} = parser, chunk) do
    %{parser | buffer: buffer <> String.trim(chunk)}
  end

  def parse(%IntegerParser{buffer: buffer, options: options}) do
    {String.to_integer(buffer), options}
  end
end
