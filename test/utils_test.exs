defmodule CalculatorCodeTest.UtilsTest do
  use ExUnit.Case
  alias CalculatorCodeTest.Utils

  describe "csv_file_to_data/1" do
    setup [:csv_fixture, :contents_to_data]

    test "returns expected number of rows", %{result: result} do
      assert length(result) == 2
    end

    test "returns expected data shape", %{result: result} do
      assert result == [
               %{
                 "a" => "1",
                 "b" => "2",
                 "c" => "3"
               },
               %{
                 "a" => "4",
                 "b" => "5",
                 "c" => "6"
               }
             ]
    end
  end

  #
  # FIXTURES & HELPERS
  #

  defp csv_fixture(_) do
    [filepath: Path.absname("test/support/mock.csv")]
  end

  defp contents_to_data(%{filepath: filepath}) do
    [result: Utils.csv_file_to_data(filepath)]
  end
end
