defmodule CalculatorCodeTest.Shipment do
  @moduledoc """
  Shipment attributes validation
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias CalculatorCodeTest.{Rates, Shipment}

  @ranges %{
    same: "same-zone",
    different: "different-zone"
  }

  @primary_key false
  embedded_schema do
    field :from_suburb, :string
    field :from_postcode, :integer
    field :to_suburb, :string
    field :to_postcode, :integer
    field :weight, :integer
    field :range, :string
    field :price, :float
  end

  @required_fields [
    :from_suburb,
    :from_postcode,
    :to_suburb,
    :to_postcode,
    :weight
  ]

  @optional_fields [
    :range,
    :price
  ]

  def changeset(%Shipment{} = shipment, attrs) do
    shipment
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_postcodes()
    |> set_range()
    |> validate_weight_limit()
  end

  @doc """
  Create a new shipment changeset
  """
  def new(shipment_attrs) do
    %Shipment{}
    |> Shipment.changeset(shipment_attrs)
  end

  @doc """
  Retrieve shipping quote for a Shipping changeset
  """
  def get_quote(%Ecto.Changeset{valid?: false} = cs) do
    cs
  end

  def get_quote(%Ecto.Changeset{} = cs) do
    range = get_field(cs, :range)
    weight = get_field(cs, :weight)

    Rates.get_prices()
    |> Enum.find(fn price ->
      price.range == range && weight <= price.max_weight
    end)
    |> case do
      %Rates.Price{price: price} -> put_change(cs, :price, price)
      _ -> add_error(cs, :price, "Unable to determine price.")
    end
  end

  #
  # SETTERS
  #

  defp set_range(%Ecto.Changeset{} = cs) do
    range =
      get_field(cs, :from_postcode)
      |> same_zone?(get_field(cs, :to_postcode))
      |> case do
        true -> @ranges.same
        false -> @ranges.different
      end

    put_change(cs, :range, range)
  end

  #
  # VALIDATIONS
  #

  defp validate_weight_limit(%Ecto.Changeset{} = cs) do
    weight = get_field(cs, :weight)
    range = get_field(cs, :range)

    case verify_weight_for_range(weight, range) do
      {:error, error} -> add_error(cs, :weight, error)
      :ok -> cs
    end
  end

  defp validate_postcodes(%Ecto.Changeset{} = cs) do
    [get_field(cs, :from_postcode), get_field(cs, :to_postcode)]
    |> Enum.map(&validate_postcode/1)
    |> Enum.all?()
    |> case do
      true -> cs
      false -> add_error(cs, :range, "Specified zones are not supported.")
    end
  end

  defp validate_postcode(postcode) do
    Rates.get_zones()
    |> Enum.find(fn zone -> zone.postcode == postcode end)
  end

  #
  # HELPERS
  #

  defp same_zone?(from_postcode, to_postcode) do
    from_zone = postcode_to_zone(from_postcode)
    to_zone = postcode_to_zone(to_postcode)

    not is_nil(from_zone) &&
      not is_nil(to_zone) &&
      from_zone == to_zone
  end

  defp postcode_to_zone(postcode) do
    Rates.get_zones()
    |> Enum.find(fn zone -> zone.postcode == postcode end)
    |> case do
      nil -> nil
      zone -> Map.get(zone, :zone)
    end
  end

  defp verify_weight_for_range(_, nil) do
    {:error, "No range provided."}
  end

  defp verify_weight_for_range(weight, range) do
    if weight > Rates.get_max_weight(range) do
      {:error, "Exceeds maximum weight for range"}
    else
      :ok
    end
  end
end
