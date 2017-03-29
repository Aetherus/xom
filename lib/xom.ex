defmodule Xom do
  alias Xom.{IOWrapper, ParseError, Parser, BooleanParser, FileParser, FloatParser, IntegerParser, ListParser, MapParser, StringParser, TimestampParser}

  @chunk_size 8_000_000  # bytes

  @parsers %{
    'boolean' => BooleanParser,
    'file' => FileParser,
    'float' => FloatParser,
    'integer' => IntegerParser,
    'list' => ListParser,
    'map' => MapParser,
    'string' => StringParser,
    'timestamp' => TimestampParser
  }

  def parse(thing) do
    {:ok, io} = IOWrapper.wrap(thing)
    :xmerl_sax_parser.stream("",
        continuation_state: io,
        continuation_fun: &read_io/1,
        event_state: [],  # the stack
        event_fun: &on_sax_event/3)
  end

  # Helpers
  defp read_io(io) do
    chunk = case IO.binread(io, @chunk_size) do
      :eof -> []
      chunk -> chunk
    end
    {chunk, io}
  end

  defp on_sax_event(:startDocument, _location, stack) do
    [ListParser.new() | stack]
  end

  defp on_sax_event(:endDocument, _location, stack) do
    [%ListParser{buffer: [result]}] = stack
    result
  end

  defp on_sax_event({:startElement, _, element_name, _, attributes}, _location, stack) do
    parser_type = Map.fetch!(@parsers, element_name)
    options = attributes
              |> Stream.map(fn {_, _, attr_name, value} -> {to_string(attr_name), to_string(value)} end)
              |> Enum.into(%{})
    [parser_type.new(options) | stack]
  end

  defp on_sax_event({:endElement, _, element_name, _}, _location, stack) do
    [peek | stack] = stack
    if peek.__struct__ != @parsers[element_name] do
      raise ParseError, element_name
    end
    value = Parser.parse(peek)
    [peek | stack] = stack
    parser = Parser.update(peek, value)
    [parser | stack]
  end

  defp on_sax_event({:characters, text}, _location, stack) do
    [peek | stack] = stack
    parser = Parser.update(peek, text)
    [parser | stack]
  end

  defp on_sax_event(_, _location, stack) do
    stack
  end
end
