defmodule Xom.Parsers.BooleanParser do

  defstruct buffer: "", options: %{}

  defimpl Xom.Parsers.Parser, for: __MODULE__ do
    def new(options \\ %{}), do: %__MODULE__{options: options}

    def update(%__MODULE__{buffer: buffer} = parser, chunk) do
      chunk = chunk |> String.trim() |> String.downcase()
      %{parser | buffer: buffer <> chunk}
    end

    def parse(%__MODULE__{buffer: "true", options: options}), do: {true, options}

    def parse(%__MODULE__{buffer: "false", options: options}), do: {false, options}

    def parse(%__MODULE__{buffer: _} = parser) do
      raise Xom.Parsers.ParseError, __MODULE__
    end
  end
end
