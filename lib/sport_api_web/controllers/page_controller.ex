defmodule SportApiWeb.PageController do
  use SportApiWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def get_leagues(%Plug.Conn{params: params} = conn, _params) do
    data = File.stream!(Path.absname("data.csv")) |> CSV.decode
    data = data
    |> Enum.slice(1, Enum.count(data))
    |> Enum.map( 
      fn ({:ok, [id, div, season, date, home_team, away_team, fthg, ftag, ftr, hthg, htag, htr]}) -> %{
        "id": id,
        "season": "#{String.slice(season, 0, 4)}-#{String.slice(season, 0, 2) <> String.slice(season, 4, 6)}",
        "pair": "#{home_team} #{away_team}",
        "date": date
      }
    end)
    IO.inspect params
    IO.inspect conn
    season = Map.get(params, "season")
    pair = Map.get(params, "pair")
    IO.inspect season
    IO.inspect List.first(data)
    if season do
      data = data |> Enum.filter(fn(row) -> Map.get(row, :season) == season end)
    else
      data = []
    end

    if pair do
      data = data |> Enum.filter(fn(row) -> Map.get(row, "pair") == pair end)
    else
      data = []
    end

    json conn, data
  end
end
