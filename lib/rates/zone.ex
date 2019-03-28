defmodule CalculatorCodeTest.Rates.Zone do
  @moduledoc """
  Zone struct and validation
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias CalculatorCodeTest.Rates.Zone

  @primary_key false
  embedded_schema do
    field :suburb, :string
    field :postcode, :integer
    field :zone, :string
  end

  @fields [
    :suburb,
    :postcode,
    :zone
  ]

  def changeset(%Zone{} = zone, attrs) do
    zone
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
