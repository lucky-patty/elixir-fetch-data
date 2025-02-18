defmodule MarketCapFetcher do
  @moduledoc """
  Fetches cryptocurrency market cap data from CoinMarketCap API
  """

  @doc """
  Hello world.

  ## Examples

      iex> MarketCapFetcher.hello()
      :world

  """
  #  def hello do
  #  :world
  # end
@api_url "https://sandbox-api.coinmarketcap.com/v1/cryptocurrency/listings/latest"
@api_key "b54bcf4d-1bca-4e8e-9a24-22ff2c3d462c"
  
  def fetch_market_data do 
    headers = [
      {"X-CMC_PRO_API_KEY", @api_key},
      {"Accept", "application/json"}
    ]

    case HTTPoison.get(@api_url, headers) do 
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Jason.decode!()
        |> parse_market_data()

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        IO.puts("Failed: #{status_code}")
        IO.puts(body)
        :error

      {:error, reason} ->
        IO.puts("Request failed: #{inspect(reason)}")
        :error
    end
  end

  defp parse_market_data(%{"data" => data}) do 
    Enum.map(data, fn %{"name" => name, "quote" => %{"USD" => %{"market_cap" => market_cap}}} -> 
    %{name: name, market_cap: market_cap} 
    end)
  end
end
