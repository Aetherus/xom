defmodule XomTest do
  use ExUnit.Case, async: true
  doctest Xom

  @mock_file_path "test/mock/elixir.jpg"
  @sample_file_node """
    <file filename="foo.jpg" content-type="image/jpeg">
      #{File.read!(@mock_file_path) |> Base.encode64}
    </file>
  """

  test "parse true" do
    {:ok, io} = StringIO.open("<boolean>true</boolean>")
    assert {:ok, true, _} = Xom.parse(io)
  end

  test "parse false" do
    {:ok, io} = StringIO.open("<boolean>false</boolean>")
    assert {:ok, false, _} = Xom.parse(io)
  end

  test "parse float" do
    {:ok, io} = StringIO.open("<float>-3.14</float>")
    assert {:ok, -3.14, _} = Xom.parse(io)
  end

  test "parse integer" do
    {:ok, io} = StringIO.open("<integer>123</integer>")
    assert {:ok, 123, _} = Xom.parse(io)
  end

  test "parse string" do
    {:ok, io} = StringIO.open("<string>bar</string>")
    assert {:ok, "bar", _} = Xom.parse(io)
  end

  test "parse file" do
    {:ok, io} = StringIO.open(@sample_file_node)
    assert {:ok, %Plug.Upload{path: tmp_path, content_type: "image/jpeg", filename: "foo.jpg"}, _} = Xom.parse(io)
    assert File.read!(@mock_file_path) == File.read!(tmp_path)
    File.rm!(tmp_path)
  end

  test "parse list" do
    {:ok, io} = StringIO.open """
    <list>
      <string>foo</string>
      <string>bar</string>
    </list>
    """
    assert {:ok, ["foo", "bar"], _} = Xom.parse(io)
  end

  test "parse map" do
    {:ok, io} = StringIO.open """
    <map>
      <string name="foo">FOO</string>
      <string name="bar">BAR</string>
    </map>
    """
    assert {:ok, %{"foo" => "FOO", "bar" => "BAR"}, _} = Xom.parse(io)
  end

  test "parse composite" do
    fd = File.open!("test/mock/mock.xml", [:read, :binary])
    {:ok, result, _} = Xom.parse(fd)
    assert %{
      "foo" => "foo",
      "bar" => "bar",
      "baz" => " baz ",
      "file" => %Plug.Upload{},
      "list" => [
        %{
          "latitude" => 23.45,
          "longitude" => 112.33,
          "snapshot" => %Plug.Upload{}
        },
        %{
          "latitude" => 34.56,
          "longitude" => 223.44,
          "snapshot" => %Plug.Upload{}
        }
      ]
    } = result
  end
end
