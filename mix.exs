defmodule CalculatorTest.MixProject do
  use Mix.Project

  def project do
    [
      app: :calculator_code_test,
      version: "0.1.0",
      elixir: "~> 1.6",
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
      {:mix_test_watch, "~> 0.8", only: :dev, runtime: false},
      {:csv, "~> 2.3"},
      {:ecto, "~> 3.0"}
    ]
  end
end
