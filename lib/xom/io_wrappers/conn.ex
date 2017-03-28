defimpl Xom.IOWrapper, for: Plug.Conn do
  use GenServer

  def wrap(conn) do
    GenServer.start_link(__MODULE__, %{conn: conn, done: false})
  end

  def init(state) do
    {:ok, state}
  end

  def handle_info({:io_request, from, reply_as, {:get_chars, _, chunk_size}}, %{conn: conn, done: false} = state) do
    state = case Plug.Conn.read_body(conn, length: chunk_size) do
      {:ok, data, conn} ->
        send(from, {:io_reply, reply_as, to_string(data)})
        %{conn: conn, done: true}
      {:more, data, conn} ->
        send(from, {:io_reply, reply_as, to_string(data)})
        %{conn: conn, done: false}
      {:error, _} = reply ->
        send(from, {:io_reply, reply_as, reply})
        %{state | done: true}
    end
    {:noreply, state}
  end

  def handle_info({:io_request, from, reply_as, {:get_chars, _, _}}, %{conn: conn, done: true} = state) do
    send(from, {:io_reply, reply_as, :eof})
    GenServer.cast(self, :close)
    {:noreply, state}
  end

  def handle_cast(:close, state) do
    {:stop, :normal, state}
  end
end