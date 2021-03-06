defimpl Xom.IOWrapper, for: Plug.Conn do
  use GenServer

  def wrap(conn) do
    GenServer.start_link(__MODULE__, %{conn: conn, done: false})
  end

  def conn(pid) do
    GenServer.call(pid, :conn)
  end

  def stop(pid) do
    GenServer.stop(pid, :normal)
  end

  # GenServer callbacks
  def init(state) do
    {:ok, state}
  end

  def handle_call(:conn, _from, %{conn: conn} = state) do
    {:reply, conn, state}
  end

  def handle_info({:io_request, from, reply_as, {:get_chars, _, chunk_size}}, %{conn: conn, done: false} = state) do
    state = case Plug.Conn.read_body(conn, length: chunk_size) do
      {status, data, conn} when status in [:ok, :more] ->
        send(from, {:io_reply, reply_as, to_string(data)})
        %{conn: conn, done: status == :ok}
      {:error, _} = reply ->
        send(from, {:io_reply, reply_as, reply})
        %{state | done: true}
    end
    {:noreply, state}
  end

  def handle_info({:io_request, from, reply_as, {:get_chars, _, _}}, %{done: true} = state) do
    send(from, {:io_reply, reply_as, :eof})
    {:noreply, state}
  end

  def handle_info({:io_request, from, reply_as, _}, state) do
    send(from, {:io_reply, reply_as, {:error, :not_supported}})
    {:noreply, state}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

end