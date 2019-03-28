defmodule CalculatorCodeTest.ShipmentTest do
  use ExUnit.Case
  alias CalculatorCodeTest.Shipment

  #
  # NEW SHIPMENT
  #

  describe "new/1 with valid attributes" do
    setup :valid_attrs

    test "returns changeset", %{attrs: attrs} do
      result = Shipment.new(attrs)
      assert result.valid?
    end
  end

  #
  # QUOTE: SAME ZONE
  #

  describe "get_quote/1 for same zone, light weight" do
    setup [:same_zone_light_weight, :get_quote]

    test "determines same zone", %{result: result} do
      assert result.range == "same-zone"
    end

    test "returns expected price", %{result: result} do
      assert result.price == 4.10
    end
  end

  describe "get_quote/1 for same zone, heavy weight" do
    setup [:same_zone_heavy_weight, :get_quote]

    test "determines same zone", %{result: result} do
      assert result.range == "same-zone"
    end

    test "returns expected price", %{result: result} do
      assert result.price == 10.20
    end
  end

  describe "get_quote/1 for same zone, over weight" do
    setup [:same_zone_over_weight, :get_quote]

    test "determines same zone", %{result: result} do
      assert result.range == "same-zone"
    end

    test "returns expected price", %{result: result} do
      assert is_nil(result.price)
    end
  end

  #
  # QUOTE: DIFFERENT ZONE
  #

  describe "get_quote/1 for different zone, light weight" do
    setup [:different_zone_light_weight, :get_quote]

    test "determines different zone", %{result: result} do
      assert result.range == "different-zone"
    end

    test "returns expected price", %{result: result} do
      assert result.price == 4.50
    end
  end

  describe "get_quote/1 for different zone, medium weight" do
    setup [:different_zone_medium_weight, :get_quote]

    test "determines different zone", %{result: result} do
      assert result.range == "different-zone"
    end

    test "returns expected price", %{result: result} do
      assert result.price == 9.50
    end
  end

  describe "get_quote/1 for different zone, heavy weight" do
    setup [:different_zone_heavy_weight, :get_quote]

    test "determines different zone", %{result: result} do
      assert result.range == "different-zone"
    end

    test "returns expected price", %{result: result} do
      assert result.price == 14.90
    end
  end

  describe "get_quote/1 for different zone, over weight" do
    setup [:different_zone_over_weight, :get_quote]

    test "determines different zone", %{result: result} do
      assert result.range == "different-zone"
    end

    test "returns expected price", %{result: result} do
      assert is_nil(result.price)
    end
  end

  #
  # QUOTE: UNSUPPORTED ZONE
  #

  describe "get_quote/1 for unsupported zone" do
    setup [:unsupported_zone, :get_quote]

    test "returns expected price", %{result: result} do
      assert is_nil(result.price)
    end
  end

  #
  # FIXTURES
  #

  defp valid_attrs(context) do
    [shipment: shipment] = same_zone_light_weight(context)

    [attrs: shipment]
  end

  defp get_quote(%{shipment: shipment}) do
    result =
      shipment
      |> Shipment.new()
      |> Shipment.get_quote()
      |> Ecto.Changeset.apply_changes()

    [result: result]
  end

  defp same_zone_light_weight(_) do
    same_zone()
    |> Map.merge(%{
      weight: 200
    })
    |> make_shipment()
  end

  defp same_zone_heavy_weight(_) do
    same_zone()
    |> Map.merge(%{
      weight: 8000
    })
    |> make_shipment()
  end

  defp same_zone_over_weight(_) do
    same_zone()
    |> Map.merge(%{
      weight: 20000
    })
    |> make_shipment()
  end

  defp same_zone() do
    %{
      from_suburb: "Sydney",
      from_postcode: 2000,
      to_suburb: "Glebe",
      to_postcode: 2037
    }
  end

  defp different_zone() do
    %{
      from_suburb: "Melbourne",
      from_postcode: 3000,
      to_suburb: "Modbury",
      to_postcode: 5092
    }
  end

  defp different_zone_light_weight(_) do
    different_zone()
    |> Map.merge(%{
      weight: 500
    })
    |> make_shipment()
  end

  defp different_zone_medium_weight(_) do
    different_zone()
    |> Map.merge(%{
      weight: 5000
    })
    |> make_shipment()
  end

  defp different_zone_heavy_weight(_) do
    different_zone()
    |> Map.merge(%{
      weight: 9000
    })
    |> make_shipment()
  end

  defp different_zone_over_weight(_) do
    different_zone()
    |> Map.merge(%{
      weight: 20000
    })
    |> make_shipment()
  end

  defp unsupported_zone(_) do
    %{
      from_suburb: "South Perth",
      from_postcode: 6151,
      to_suburb: "Brisbane",
      to_postcode: 4000,
      weight: 200
    }
    |> make_shipment()
  end

  defp make_shipment(attrs) do
    shipment = %{
      from_suburb: attrs[:from_suburb],
      from_postcode: attrs[:from_postcode],
      to_suburb: attrs[:to_suburb],
      to_postcode: attrs[:to_postcode],
      weight: attrs[:weight]
    }

    [shipment: shipment]
  end
end
