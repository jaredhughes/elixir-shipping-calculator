defmodule CalculatorCodeTest.Rates.Price do
  @moduledoc """
  Price struct and validation
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias CalculatorCodeTest.Rates.Price

  @primary_key false
  embedded_schema do
    field :range, :string
    field :max_weight, :integer
    field :price, :float
  end

  @fields [
    :range,
    :max_weight,
    :price
  ]

  def changeset(%Price{} = price, attrs) do
    price
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
