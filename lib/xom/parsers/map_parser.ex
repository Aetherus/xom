defmodule Xom.Parsers.MapParser do

  defstruct buffer: %{}, options: %{}

  def new(options \\ %{}), do: %__MODULE__{options: options}

end

defimpl Xom.Parsers.Parser, for: Xom.Parsers.MapParser do
  alias Xom.Parsers.MapParser

  def update(%MapParser{buffer: buffer} = parser, {value, %{"name" => name}}) do
    %{parser | buffer: Map.put(buffer, name, value)}
  end

  def parse(%MapParser{buffer: buffer, options: options}) do
    {buffer, options}
  end
end

