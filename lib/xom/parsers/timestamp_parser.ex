defmodule Xom.Parsers.TimestampParser do

  defstruct buffer: "", options: %{}

  def new(options \\ %{}), do: %__MODULE__{options: options}

end

defimpl Xom.Parsers.Parser, for: Xom.Parsers.TimestampParser do
  alias Xom.Parsers.TimestampParser

  def update(%TimestampParser{buffer: buffer} = parser, chunk) do
    %{parser | buffer: buffer <> String.trim(chunk)}
  end

  def parse(%TimestampParser{buffer: buffer, options: options}) do
    {:ok, timestamp} = Timex.parse(buffer, "{ISO:Extended}")
    {timestamp, options}
  end
end
