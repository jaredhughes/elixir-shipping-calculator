defmodule CalculatorCodeTestTest do
  use ExUnit.Case

  describe "the pricing system " do
    setup :make_shipments_fixture

    test "prints expected output", %{shipments: shipments} do
      display =
        shipments
        |> CalculatorCodeTest.get_quotes()
        |> CalculatorCodeTest.print_quotes()

      expected_display = """
      Quote Report

      Brisbane, 4000 to Brisbane, 4000, 200gm: $4.10
      Adelaide, 5000 to Sydney, 2000, 4000gm: $9.50
      Sydney, 2000 to Glebe, 2037, 5000gm: $4.10
      Perth, 6000 to Brisbane, 4000, 10000gm: $14.90
      Melbourne, 3000 to Modbury, 5092, 12000gm: -
      South Perth, 6151 to Brisbane, 4000, 8000gm: -
      Fremantle, 6160 to Adelaide, 5000, 500gm: $4.50

      Total: $37.10
      """

      assert expected_display == display
    end
  end

  #
  # FIXTURES
  #

  defp make_shipments_fixture(_) do
    shipments =
      [
        {["Brisbane", 4000], ["Brisbane", 4000], 200},
        {["Adelaide", 5000], ["Sydney", 2000], 4000},
        {["Sydney", 2000], ["Glebe", 2037], 5000},
        {["Perth", 6000], ["Brisbane", 4000], 10000},
        {["Melbourne", 3000], ["Modbury", 5092], 12000},
        {["South Perth", 6151], ["Brisbane", 4000], 8000},
        {["Fremantle", 6160], ["Adelaide", 5000], 500}
      ]
      |> Enum.map(&make_shipment/1)

    [shipments: shipments]
  end

  defp make_shipment({
         [from_suburb, from_postcode],
         [to_suburb, to_postcode],
         weight
       }) do
    %{
      from_suburb: from_suburb,
      from_postcode: from_postcode,
      to_suburb: to_suburb,
      to_postcode: to_postcode,
      weight: weight
    }
  end
end
