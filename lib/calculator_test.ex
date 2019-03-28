defmodule CalculatorCodeTest do
  @moduledoc """
  Documentation for CalculatorTest.
  """

  alias CalculatorCodeTest.Shipment

  @doc """
  Creates struct for each input of Shipment attributes

  Returns [%Ecto.Changeset{}]
  """
  def get_quotes(shipments) do
    shipments
    |> Enum.map(&Shipment.new/1)
    |> Enum.map(&Shipment.get_quote/1)
  end

  @doc """
  Generates a string for the expected display format.

  Note: ideally we'd pipe the returned data structure
  from mapping Shipment.get_quote/1 and pass it to an Eex
  template.

  Returns String
  """
  def print_quotes(quotes) when is_list(quotes) do
    # We could do more here with validation,
    # but we're just going to map the %Shipment{}
    # structs as-is for now:
    shipments =
      quotes
      |> Enum.map(&Ecto.Changeset.apply_changes/1)

    """
    Quote Report

    #{Enum.map(shipments, &quote_to_string/1)}
    Total: $#{total_shipments_cost(shipments)}
    """
  end

  defp total_shipments_cost(shipments) do
    shipments
    |> Enum.map(fn s ->
      if is_nil(s.price), do: 0, else: s.price
    end)
    |> Enum.sum()
    |> format_float()
  end

  defp quote_to_string(%Shipment{} = s) do
    from = "#{s.from_suburb}, #{s.from_postcode}"
    to = "#{s.to_suburb}, #{s.to_postcode}"

    price =
      if is_nil(s.price),
        do: "-",
        else: "$#{format_float(s.price)}"

    "#{from} to #{to}, #{s.weight}gm: #{price}\n"
  end

  defp format_float(float) when is_float(float) do
    :erlang.float_to_binary(float, decimals: 2)
  end

  defp format_float(_), do: nil
end
