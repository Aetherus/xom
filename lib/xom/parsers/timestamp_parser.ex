defmodule Xom.TimestampParser do

  defstruct buffer: [], options: %{}

  def new(options \\ %{}), do: %__MODULE__{options: options}

end

defimpl Xom.Parser, for: Xom.TimestampParser do
  alias Xom.TimestampParser

  def update(%TimestampParser{buffer: buffer} = parser, chunk) do
    %{parser | buffer: [buffer, chunk]}
  end

  def parse(%TimestampParser{buffer: buffer, options: options}) do
    {:ok, timestamp} = buffer |> to_string() |> Timex.parse("{ISO:Extended}")
    {timestamp, options}
  end
end
