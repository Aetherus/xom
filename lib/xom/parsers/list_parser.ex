defmodule Xom.ListParser do

  defstruct buffer: [], options: %{}

  def new(options \\ %{}), do: %__MODULE__{options: options}

end

defimpl Xom.Parser, for: Xom.ListParser do
  alias Xom.ListParser

  def update(%ListParser{buffer: buffer} = parser, {chunk, _}) do
    %{parser | buffer: [chunk | buffer]}
  end

  def parse(%ListParser{buffer: buffer, options: options}) do
    {Enum.reverse(buffer), options}
  end
end
