defmodule Xom.Parsers do
  defmodule ParseError do
    defexception [:message]

    def exception(module) do
      %__MODULE__{message: "#{module} failed to parse the value"}
    end
  end

  defprotocol Parser do
    #@spec update(parser, chunk) :: Parser.t
    def update(parser, chunk)
  
    #@spec parse(parser) :: {any, Map.t}
    def parse(parser)
  end
end
