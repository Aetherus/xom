defmodule Xom.Parsers.BooleanParser do

  defstruct buffer: ""

  defimpl Xom.Parsers.Parser, for: __MODULE__ do
    def new, do: %__MODULE__{}

    def update(%__MODULE__{buffer: buffer}, chunk) do
      chunk = chunk |> String.trim() |> String.downcase
      %__MODULE__{buffer: buffer <> chunk}
    end

    def parse(%__MODULE__{buffer: "true"}), do: true

    def parse(%__MODULE__{buffer: "false"}), do: false

    def parse(%__MODULE__{buffer: _}) do
      # TODO raise error
    end
  end
end
