defmodule Xom do
  alias Xom.Parsers.{BooleanParser, FileParser, FloatParser, IntegerParser, ListParser, MapParser, StringParser, TimestampParser}
  alias Data.Stack.Simple, as: Stack

  @parsers %{
    "boolean" => BooleanParser,
    "file" => FileParser,
    "float" => FloatParser,
    "integer" => IntegerParser,
    "list" => ListParser,
    "map" => MapParser,
    "string" => StringParser,
    "timestamp" => TimestampParser
  }

  def parse(xml) do
    stack = Stack.new()

  end
end
