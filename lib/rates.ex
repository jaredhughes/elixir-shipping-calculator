defmodule CalculatorCodeTest.Rates do
  @moduledoc """
  Mock data store for CSV-based zone & pricing data
  """
  alias CalculatorCodeTest.Utils
  alias CalculatorCodeTest.Rates.{Price, Zone}

  @csv %{
    prices: "prices.csv",
    zones: "zones.csv"
  }

  @doc """
  Fetches all prices from mock data store

  Returns [%Price%{}]
  """
  def get_prices() do
    [:code.priv_dir(:calculator_code_test), @csv.prices]
    |> Path.join()
    |> Utils.csv_file_to_data()
    |> Enum.map(&price_to_struct/1)
  end

  defp price_to_struct(price) do
    %Price{}
    |> Price.changeset(price)
    |> Ecto.Changeset.apply_changes()
  end

  @doc """
  Fetches all zones from mock data store

  Returns [%Zone%{}]
  """
  def get_zones() do
    [:code.priv_dir(:calculator_code_test), @csv.zones]
    |> Path.join()
    |> Utils.csv_file_to_data()
    |> Enum.map(&zone_to_struct/1)
  end

  defp zone_to_struct(zone) do
    %Zone{}
    |> Zone.changeset(zone)
    |> Ecto.Changeset.apply_changes()
  end

  @doc """
  Determines maximum allowed weight based on range

  Returns Integer
  """
  def get_max_weight(range) when is_atom(range) do
    range
    |> Atom.to_string()
    |> String.replace("_", "-")
    |> get_max_weight()
  end

  def get_max_weight(range) when is_bitstring(range) do
    get_prices()
    |> Enum.filter(fn prices -> prices.range == range end)
    |> Enum.map(fn prices -> prices.max_weight end)
    |> Enum.max()
  end

  @doc """
  Fetch name of suburb by postcode (currently unique pairs)

  Returns String
  """
  def suburb_by_postcode(postcode) do
    get_zones()
    |> Enum.find(fn zone -> zone.postcode == postcode end)
    |> case do
      nil -> nil
      zone -> Map.get(zone, :suburb)
    end
  end
end
