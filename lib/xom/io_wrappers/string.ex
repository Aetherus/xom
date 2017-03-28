defimpl Xom.IOWrapper, for: BitString do
  def wrap(str), do: StringIO.open(str)
end