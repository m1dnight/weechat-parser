defmodule WeechatParser.MixProject do
  use Mix.Project

  def project do
    [
      app: :weechat_parser,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:nimble_parsec, "~> 0.2"},
      {:timex, "~> 3.5"}
    ]
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "weechat_parser",
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README* readme* LICENSE*
                license* CHANGELOG* changelog*),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/m1dnight/weechat-parser"}
    ]
  end
end
