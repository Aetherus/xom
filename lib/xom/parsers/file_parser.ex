defmodule Xom.Parsers.FileParser do
  use GenServer

  defstruct pid: nil, options: %{}

  def new(options \\ %{}) do
    {:ok, pid} = GenServer.start_link(__MODULE__, options)
    %__MODULE__{pid: pid, options: options}
  end

  ## GenServer callbacks ##
  def init(options) do
    tmp_path = Temp.path("xom")
    fd = File.open(tmp_path, [:binary, :write])
    {:ok, %{fd: fd, path: tmp_path, options: options}}
  end

  def handle_cast({:update, chunk}, %{fd: fd}) do
    binary = chunk |> String.trim() |> Base.decode64()
    IO.write(fd, binary)
    {:noreply, fd}
  end

  def handle_call(:parse, _from, %{fd: fd, path: path, options: options}) do
    File.close(fd)
    %Plug.Upload{path: path, filename: options["filename"], content_type: options["content-type"]}
  end
end

defimpl Xom.Parsers.Parser, for: Xom.Parsers.FileParser do
  alias Xom.Parsers.FileParser

  def update(%FileParser{pid: pid} = parser, chunk) do
    GenServer.cast(pid, {:update, chunk})
    parser
  end

  def parse(%FileParser{pid: pid, options: options}) do
    result = GenServer.call(pid, :parse)
    GenServer.stop(pid, :normal)
    {result, options}
  end
end
