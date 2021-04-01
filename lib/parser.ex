defmodule Parser do
  import NimbleParsec

  date =
    integer(4)
    |> ignore(string("-"))
    |> integer(2)
    |> ignore(string("-"))
    |> integer(2)

  time =
    integer(2)
    |> ignore(string(":"))
    |> integer(2)
    |> ignore(string(":"))
    |> integer(2)

  nick = utf8_string([{:not, ?\n}, {:not, ?\s}, {:not, ?\t}], min: 1)

  host = utf8_string([{:not, ?\n}, {:not, ?\s}, {:not, ?\t}, {:not, ?\)}], min: 0)
  reason = utf8_string([?a..?z, ?A..?Z, ?0..?9, ?\., ?\@, ?\~, ?\-, ?\_, ?\s, ?\:], min: 0)

  msg = utf8_string([{:not, ?\n}], min: 0)

  channel =
    ignore(ascii_char([?\#]))
    |> utf8_string([?a..?z, ?A..?Z, ?0..?9, ?\., ?\@, ?\~, ?\-, ?\_, ?\#], min: 1)

  #
  # Me
  #
  defparsec(
    :me,
    date
    |> ignore(string(" "))
    |> concat(time)
    |> ignore(ascii_char([?\t]))
    |> ignore(ascii_char([?\s]))
    |> ignore(ascii_char([?\*]))
    |> ignore(ascii_char([?\t]))
    |> concat(nick)
    |> ignore(ascii_char([?\s]))
    |> concat(msg)
    |> optional(ignore(ascii_char([?\n]))),
    debug: false
  )

  #
  # Leave
  #

  defparsec(
    :leave,
    date
    |> ignore(string(" "))
    |> concat(time)
    |> ignore(ascii_char([?\t]))
    |> ignore(string("<--"))
    |> ignore(ascii_char([?\t]))
    |> concat(nick)
    |> ignore(ascii_char([?\s]))
    |> ignore(ascii_char([?\(]))
    |> concat(host)
    |> ignore(ascii_char([?\)]))
    |> ignore(ascii_char([?\s]))
    |> ignore(string("has quit"))
    |> ignore(ascii_char([?\s]))
    |> ignore(ascii_char([?\(]))
    |> concat(reason)
    |> ignore(ascii_char([?\)]))
    |> optional(ignore(ascii_char([?\n]))),
    debug: false
  )

  #
  # Join
  #

  defparsec(
    :join,
    date
    |> ignore(string(" "))
    |> concat(time)
    |> ignore(ascii_char([?\t]))
    |> ignore(string("-->"))
    |> ignore(ascii_char([?\t]))
    |> concat(nick)
    |> ignore(ascii_char([?\s]))
    |> ignore(ascii_char([?\(]))
    |> concat(host)
    |> ignore(ascii_char([?\)]))
    |> ignore(ascii_char([?\s]))
    |> ignore(string("has joined"))
    |> ignore(ascii_char([?\s]))
    |> concat(channel)
    |> optional(ignore(ascii_char([?\n]))),
    debug: false
  )

  #
  # Message
  #

  defparsec(
    :message,
    date
    |> ignore(string(" "))
    |> concat(time)
    |> ignore(ascii_char([?\t]))
    |> concat(nick)
    |> ignore(ascii_char([?\t]))
    |> concat(msg)
    |> optional(ignore(ascii_char([?\n]))),
    debug: false
  )
end
