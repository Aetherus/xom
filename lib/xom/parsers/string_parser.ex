defmodule Xom.Parsers.StringParser do

  defstruct buffer: "", options: %{}

  defimpl Xom.Parsers.Parser, for: __MODULE__ do
    def new(options \\ %{}), do: %__MODULE__{options: options}

    def update(%__MODULE__{buffer: buffer} = parser, chunk) do
      %{parser | buffer: buffer <> HtmlEntities.decode(chunk)}
    end

    def parse(%__MODULE__{buffer: buffer, options: options}) do
      {buffer, options}
    end
  end
end
