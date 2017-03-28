defmodule XomTest do
  use ExUnit.Case, async: true
  doctest Xom

  @mock_file_path "test/fixtures/elixir.jpg"
  @sample_file_node """
    <file filename="foo.jpg" content-type="image/jpeg">
      #{File.read!(@mock_file_path) |> Base.encode64}
    </file>
  """

  test "parse true" do
    assert {:ok, true, _} = Xom.parse("<boolean>true</boolean>")
  end

  test "parse false" do
    assert {:ok, false, _} = Xom.parse("<boolean>false</boolean>")
  end

  test "parse float" do
    assert {:ok, -3.14, _} = Xom.parse("<float>-3.14</float>")
  end

  test "parse integer" do
    assert {:ok, 123, _} = Xom.parse("<integer>123</integer>")
  end

  test "parse string" do
    assert {:ok, "这是bar！", _} = Xom.parse("<string>这是bar！</string>")
  end

  test "parse timestamp" do
    {:ok, timestamp, _} = Xom.parse("<timestamp>2017-01-23T12:34:56+08:00</timestamp>")
    assert %{year: 2017, month: 1, day: 23, hour: 12, minute: 34, second: 56, time_zone: "Etc/GMT-8"} = timestamp
  end

  test "parse file" do
    assert {:ok, %Plug.Upload{path: tmp_path, content_type: "image/jpeg", filename: "foo.jpg"}, _} = Xom.parse(@sample_file_node)
  end

  test "parse list" do
    xml = """
    <list>
      <string>foo</string>
      <string>bar</string>
    </list>
    """
    assert {:ok, ["foo", "bar"], _} = Xom.parse(xml)
  end

  test "parse map" do
    xml = """
    <map>
      <string name="foo">FOO</string>
      <string name="bar">BAR</string>
    </map>
    """
    assert {:ok, %{"foo" => "FOO", "bar" => "BAR"}, _} = Xom.parse(xml)
  end

  test "parse io" do
    fd = File.open!("test/fixtures/fixture.xml", [:read, :binary])
    {:ok, result, _} = Xom.parse(fd)
    assert_parse_success(result)
  end

  test "parse conn" do
    conn = Plug.Test.conn(:post, "/", File.read!("test/fixtures/fixture.xml"))
    {:ok, result, _} = Xom.parse(conn)
    assert_parse_success(result)
  end

  test "plug" do
    conn = Plug.Test.conn(:post, "/", File.read!("test/fixtures/fixture.xml"))
    assert {:ok, %{}, _conn} = Xom.Plug.Parser.parse(conn, "application", "vnd.xom+xml", nil, nil)
  end

  def assert_parse_success(result) do
    assert %{
      "foo" => "foo",
      "bar" => "bar",
      "baz" => " baz ",
      "file" => %Plug.Upload{path: path1},
      "list" => [
        %{
          "latitude" => 23.45,
          "longitude" => 112.33,
          "snapshot" => %Plug.Upload{path: path2}
        },
        %{
          "latitude" => 34.56,
          "longitude" => 223.44,
          "snapshot" => %Plug.Upload{path: path3}
        }
      ]
    } = result
  end

end
