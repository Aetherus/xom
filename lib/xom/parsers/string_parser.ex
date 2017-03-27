defmodule Xom.Parsers.StringParser do

  defstruct buffer: "", options: %{}

  def new(options \\ %{}), do: %__MODULE__{options: options}

end

defimpl Xom.Parsers.Parser, for: Xom.Parsers.StringParser do
  alias Xom.Parsers.StringParser

  def update(%StringParser{buffer: buffer} = parser, chunk) do
    %{parser | buffer: buffer <> HtmlEntities.decode(chunk)}
  end

  def parse(%StringParser{buffer: buffer, options: options}) do
    {buffer, options}
  end
end
