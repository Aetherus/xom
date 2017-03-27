defmodule Xom.Parsers do
  defmodule ParseError do
    defexception [:message]

    def exception(module) do
      %__MODULE__{message: "#{module} failed to parse the value"}
    end
  end

  defprotocol Parser do
    def update(parser, chunk)
    def parse(parser)
  end
end
