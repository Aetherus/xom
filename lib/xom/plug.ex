defmodule Xom.Plug.Parser do
  @behaviour Plug.Parsers

  alias Xom.IOWrapper

  def parse(conn, "application", "vnd.xom+xml", _headers, _opts) do
    try do
      {:ok, pid} = IOWrapper.wrap(conn)
      {:ok, result, _} = Xom.parse(pid)
      conn = IOWrapper.Plug.Conn.conn(pid)
      IOWrapper.Plug.Conn.stop(pid)
      {:ok, normalize(result), conn}
    rescue
      _ -> raise Plug.BadRequestError
    end
  end

  def parse(conn, _, _, _, _, _) do
    {:next, conn}
  end

  defp normalize(%{} = params), do: params

  defp normalize(params), do: %{"_params" => params}
end