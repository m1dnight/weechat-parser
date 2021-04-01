defmodule WeechatParser do
  alias WeechatParser.{Message, Join, Leave, Me}

  @doc """
  Parses a single line of a log file.
  Returns `{:ok, term}`, or `{:error, reason}`.
  """
  def parse_log_line(line) do
    case Parser.leave(line) do
      {:ok, res, _, _, _, _} ->
        {:ok, parse_leave(res)}

      {:error, _, _rest, _context, _line, _column} ->
        case Parser.join(line) do
          {:ok, res, _, _, _, _} ->
            {:ok, parse_join(res)}

          {:error, _, _rest, _context, _line, _column} ->
            case Parser.message(line) do
              {:ok, res, _, _, _, _} ->
                {:ok, parse_message(res)}

              {:error, _, _rest, _context, _line, _column} ->
                case Parser.me(line) do
                  {:ok, res, _, _, _, _} ->
                    {:ok, parse_me(res)}

                  {:error, _, _rest, _context, _line, _column} ->
                    {:error, "Line '#{line}' not understood"}
                end
            end
        end
    end
  end

  @doc """
  Parses an entire file.
  """
  def parse_file(path) do
    File.stream!(path)
    |> Stream.map(&WeechatParser.parse_log_line/1)
    |> Stream.map(fn {:ok, x} -> x end)
    |> Enum.to_list()
  end

  defp parse_message(args) do
    [y, mm, d, h, m, s, nick, msg] = args
    %Message{timestamp: parse_timestamp(y, mm, d, h, m, s), nick: nick, message: msg}
  end

  defp parse_join(args) do
    [y, mm, d, h, m, s, nick, host, channel] = args

    %Join{
      timestamp: parse_timestamp(y, mm, d, h, m, s),
      nick: nick,
      host: host,
      channel: "##{channel}"
    }
  end

  defp parse_leave(args) do
    [y, mm, d, h, m, s, nick, host, reason] = args

    %Leave{
      timestamp: parse_timestamp(y, mm, d, h, m, s),
      nick: nick,
      host: host,
      reason: reason
    }
  end

  defp parse_me(args) do
    [y, mm, d, h, m, s, nick, msg] = args

    %Me{
      timestamp: parse_timestamp(y, mm, d, h, m, s),
      nick: nick,
      message: msg
    }
  end

  defp parse_timestamp(y, mm, d, h, m, s) do
    Timex.to_datetime({{y, mm, d}, {h, m, s}}, "Etc/UTC")
  end
end
