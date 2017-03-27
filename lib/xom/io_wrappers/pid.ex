defimpl Xom.IOWrapper, for: PID do
  def wrap(pid), do: {:ok, pid}
end