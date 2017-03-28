defmodule Xom.StringParser do

  defstruct buffer: [], options: %{}

  def new(options \\ %{}), do: %__MODULE__{options: options}

end

defimpl Xom.Parser, for: Xom.StringParser do
  alias Xom.StringParser

  def update(%StringParser{buffer: buffer} = parser, chunk) do
    %{parser | buffer: [buffer, chunk]}
  end

  def parse(%StringParser{buffer: buffer, options: options}) do
    result = buffer |> to_string()
    {result, options}
  end
end
