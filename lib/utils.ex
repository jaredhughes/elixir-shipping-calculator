defmodule CalculatorCodeTest.Utils do
  @moduledoc """
  Data transformation utilies
  """

  def csv_file_to_data(filepath) when is_bitstring(filepath) do
    contents =
      filepath
      |> decode_csv_from_file()

    [ok: columns] = Enum.take(contents, 1)

    contents
    |> Enum.drop(1)
    |> Enum.map(fn {:ok, row} ->
      columns
      |> Enum.zip(row)
      |> Enum.into(%{})
    end)
  end

  defp decode_csv_from_file(filepath) do
    filepath
    |> File.stream!()
    |> CSV.decode()
  end
end
