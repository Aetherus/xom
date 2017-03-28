defmodule Xom.MapParser do

  defstruct buffer: %{}, options: %{}

  def new(options \\ %{}), do: %__MODULE__{options: options}

end

defimpl Xom.Parser, for: Xom.MapParser do
  alias Xom.MapParser

  def update(%MapParser{buffer: buffer} = parser, {value, %{"name" => name}}) do
    %{parser | buffer: Map.put(buffer, name, value)}
  end

  def parse(%MapParser{buffer: buffer, options: options}) do
    {buffer, options}
  end
end

