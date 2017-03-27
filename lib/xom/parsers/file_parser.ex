defmodule Xom.Parsers.FileParser do
  use GenServer

  defstruct pid: nil

  def new(options \\ %{}) do
    {:ok, pid} = GenServer.start_link(__MODULE__, options)
    %__MODULE__{pid: pid}
  end

  ## GenServer callbacks ##
  def init(options) do
    {:ok, tmp_path} = Temp.path("xom")
    fd = File.open!(tmp_path, [:write, :binary])
    {:ok, %{fd: fd, path: tmp_path, options: options}}
  end

  def handle_cast({:update, chunk}, %{fd: fd} = state) do
    binary = chunk |> String.trim() |> Base.decode64!(ignore: :whitespace)
    IO.binwrite(fd, binary)
    {:noreply, state}
  end

  def handle_call(:parse, _from, %{fd: fd, path: path, options: options} = state) do
    File.close(fd)
    uploaded_file = %Plug.Upload{path: path, filename: options["filename"], content_type: options["content-type"]}
    {:reply, {uploaded_file, options}, state}
  end
end

defimpl Xom.Parsers.Parser, for: Xom.Parsers.FileParser do
  alias Xom.Parsers.FileParser

  def update(%FileParser{pid: pid} = parser, chunk) do
    GenServer.cast(pid, {:update, chunk})
    parser
  end

  def parse(%FileParser{pid: pid}) do
    result = GenServer.call(pid, :parse)
    GenServer.stop(pid, :normal)
    result
  end
end
