defmodule Xom.Parsers.FileParser do
  use GenServer

  defstruct pid: nil, options: %{}

  defimpl Xom.Parsers.Parser, for: __MODULE__ do
    def new(options \\ %{}), do
      {:ok, pid} = GenServer.start_link(__MODULE__, options)
      %__MODULE__{pid: pid, options: options}
    end

    def update(%__MODULE__{pid: pid} = parser, chunk) do
      cast(pid, {:update, chunk})
      parser
    end

    def parse(%__MODULE__{pid: pid, options: _}) do
      result = call(pid, :parse)
      stop(pid, :normal)
      {result, options}
    end
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
    %Plug.Upload{path: path, filename: options["filename"], content_type: options[]}
  end
end
