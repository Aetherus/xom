defmodule Xom.ParseError do
  defexception [:message]

  def exception(module) do
    %__MODULE__{message: "#{module} failed to parse the value"}
  end
end

defprotocol Xom.Parser do
  def update(parser, chunk)
  def parse(parser)
end