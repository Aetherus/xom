defmodule Xom.IntegerParser do

  defstruct buffer: [], options: %{}

  def new(options \\ %{}), do: %__MODULE__{options: options}

end

defimpl Xom.Parser, for: Xom.IntegerParser do
  alias Xom.IntegerParser

  def update(%IntegerParser{buffer: buffer} = parser, chunk) do
    %{parser | buffer: [buffer, chunk]}
  end

  def parse(%IntegerParser{buffer: buffer, options: options}) do
    result = buffer |> to_string() |> String.trim() |> String.to_integer()
    {result, options}
  end
end
