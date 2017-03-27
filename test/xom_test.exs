defmodule XomTest do
  use ExUnit.Case, async: true
  doctest Xom

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "string parser" do
    io = StringIO.open("<string name=\"foo\">bar</string>")
    %{"foo" => "bar"} = Xom.parse(io)
  end
end
