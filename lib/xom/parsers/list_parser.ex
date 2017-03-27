defmodule Xom.Parsers.ListParser do

  defstruct buffer: [], options: %{}

  def new(options \\ %{}), do: %__MODULE__{options: options}

end

defimpl Xom.Parsers.Parser, for: __MODULE__ do
  alias Xom.Parsers.ListParser

  def update(%ListParser{buffer: buffer} = parser, {chunk, _}) do
    %{parser | buffer: [chunk | buffer]}
  end

  def parse(%ListParser{buffer: buffer, options: options}) do
    {Enum.reverse(buffer), options}
  end
end
