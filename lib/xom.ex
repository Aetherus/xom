defmodule Xom do
  alias Xom.Parsers.{ParseError, Parser, BooleanParser, FileParser, FloatParser, IntegerParser, ListParser, MapParser, StringParser, TimestampParser}

  @chunk_size 1024  # bytes

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
    :erlsom.parse_sax(xml, [], &on_sax_event/2)
  end

  defp on_sax_event(:startDocument, stack) do
    [ListParser.new() | stack]
  end

  defp on_sax_event(:endDocument, stack) do
    [root] = stack
    root
  end

  defp on_sax_event({:startElement, _, element_name, _, attributes}, stack) do
    parser_type = Map.fetch!(@parsers, element_name)
    options = attributes 
              |> Stream.map(fn {attr_name, _, _, value} -> {attr_name, value} end)
              |> Enum.into(%{})
    [parser_type.new(options) | stack]
  end

  defp on_sax_event({:endElement, _, element_name, _}) do
    [peek | stack] = stack
    if peek.__struct__ != @parsers[element_name] do
      raise ParseError, element_name
    end
    value = Parser.parse(peek)
    [peek | stack] = stack
    parser = Parser.update(peek, value)
    [parser | stack]
  end

  defp on_sax_event({:characters, text}, stack) do
    [peek | stack] = stack
    parser = Parser.update(peek, text)
    [parser | stack]
  end

  defp on_sax_event(_, stack) do
    stack
  end
end
