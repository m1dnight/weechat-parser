defmodule WeechatParser.MixProject do
  use Mix.Project

  def project do
    [
      app: :weechat_parser,
      version: "0.1.1",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      deps: deps(),
      name: "weechat-parser",
      source_url: "https://github.com/m1dnight/weechat-parser",
      description: description()
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
      {:timex, "~> 3.5"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "Parses Weechat logs into Structs using Nimble."
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "weechat_parser",
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/m1dnight/weechat-parser"}
    ]
  end
end
