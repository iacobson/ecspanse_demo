defmodule Demo.MixProject do
  use Mix.Project

  def project do
    [
      app: :ecspanse_demo,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Demo.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:kino, "~> 0.11.0"},
      {:eflambe, "~> 0.3.0"},
      {:ecspanse, "~> 0.7.0"}
    ]
  end
end
