defmodule WeechatParserTest do
  use ExUnit.Case
  doctest WeechatParser

  test "join failed before" do
    line = "2018-12-23 18:11:19	-->	hyper-ronin (~hyper-ron@unaffiliated/hyper-ronin) has joined #docker"

    parsed = WeechatParser.parse_log_line(line)

    expected =
      {:ok,
       %WeechatParser.Join{
         channel: "#docker",
         host: "~hyper-ron@unaffiliated/hyper-ronin",
         nick: "hyper-ronin",
         timestamp: ~U[2018-12-23 18:11:19Z]
       }}

    assert parsed == expected
  end

  test "join" do
    line =
      "2019-01-01 10:23:05	-->	m1dnight (~m1dnight@ptr-g7gbjui1hyz0jwwnifc.18120a2.ip6.access.telenet.be) has joined #infogroep"

    parsed = WeechatParser.parse_log_line(line)

    expected =
      {:ok,
       %WeechatParser.Join{
         channel: "#infogroep",
         host: "~m1dnight@ptr-g7gbjui1hyz0jwwnifc.18120a2.ip6.access.telenet.be",
         nick: "m1dnight",
         timestamp: ~U[2019-01-01 10:23:05Z]
       }}

    assert parsed == expected
  end

  test "join double hash" do
    line =
      "2018-12-21 18:13:09	-->	m1dnight_ (~m1dnight@ptr-g7gbjui1hyz0jwwnifc.18120a2.ip6.access.telenet.be) has joined ##linux"

    parsed = WeechatParser.parse_log_line(line)

    expected =
      {:ok,
       %WeechatParser.Join{
         channel: "##linux",
         host: "~m1dnight@ptr-g7gbjui1hyz0jwwnifc.18120a2.ip6.access.telenet.be",
         nick: "m1dnight_",
         timestamp: ~U[2018-12-21 18:13:09Z]
       }}

    assert parsed == expected
  end

  test "leave double hash" do
    line = "2018-12-21 18:38:06	<--	deathwishdave (~deathwish@90.253.191.182) has quit (Client Quit)"

    parsed = WeechatParser.parse_log_line(line)

    expected =
      {:ok,
       %WeechatParser.Leave{
         host: "~deathwish@90.253.191.182",
         nick: "deathwishdave",
         reason: "Client Quit",
         timestamp: ~U[2018-12-21 18:38:06Z]
       }}

    assert parsed == expected
  end

  test "me" do
    line = "2018-12-23 02:10:43	 *	cYnIxX3 found their answer."

    parsed = WeechatParser.parse_log_line(line)

    expected =
      {:ok,
       %WeechatParser.Me{
         message: "found their answer.",
         nick: "cYnIxX3",
         timestamp: ~U[2018-12-23 02:10:43Z]
       }}

    assert parsed == expected
  end
end
