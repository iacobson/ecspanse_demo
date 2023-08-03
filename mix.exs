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
      {:ecspanse, path: "../ecspanse"}
      # {:ecspanse, git: "https://github.com/iacobson/ecspanse.git", branch: "main"}
    ]
  end
end
