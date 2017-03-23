defmodule Xom.Parsers do
  defprotocol Parser do
    def new()
    def update(parser, chunk)
    def parse(parser)
  end
end
