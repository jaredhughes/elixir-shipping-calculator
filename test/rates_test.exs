defmodule CalculatorCodeTest.RatesTest do
  use ExUnit.Case
  alias CalculatorCodeTest.Rates

  describe "get_max_weight/1 using atoms" do
    test "for same zone returns integer" do
      result = Rates.get_max_weight(:same_zone)
      assert is_integer(result)
    end

    test "for different zone returns integer" do
      result = Rates.get_max_weight(:different_zone)
      assert is_integer(result)
    end
  end

  describe "get_max_weight/1 using strings" do
    test "for same zone returns integer" do
      result = Rates.get_max_weight("same-zone")
      assert is_integer(result)
    end

    test "for different zone returns integer" do
      result = Rates.get_max_weight("different-zone")
      assert is_integer(result)
    end
  end

  describe "suburb_by_postcode/1" do
    test "returns expected value" do
      result = Rates.suburb_by_postcode(5000)

      assert result == "Adelaide"
    end
  end
end
