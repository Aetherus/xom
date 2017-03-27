defmodule Xom.Parsers.FloatParser do

  defstruct buffer: [], options: %{}

  def new(options \\ %{}), do: %__MODULE__{options: options}

end

defimpl Xom.Parsers.Parser, for: Xom.Parsers.FloatParser do
  alias Xom.Parsers.FloatParser

  def update(%FloatParser{buffer: buffer} = parser, chunk) do
    %{parser | buffer: [buffer, chunk]}
  end

  def parse(%FloatParser{buffer: buffer, options: options}) do
    result = buffer |> to_string() |> String.trim() |> String.to_float()
    {result, options}
  end
end