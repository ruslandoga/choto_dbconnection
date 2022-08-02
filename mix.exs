defmodule Choto.Connection.MixProject do
  use Mix.Project

  def project do
    [
      app: :choto_dbconnection,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:choto, github: "ruslandoga/choto"},
      {:db_connection, "~> 2.4"}
    ]
  end
end
