defmodule SportApiWeb.PageController do
  use SportApiWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def parsed_season_pair(season_string) do
    first = String.slice(season_string, 0, 4)
    second = String.slice(season_string, 0, 2)
    third = String.slice(season_string, 4, 6)
    "#{first}-#{second}#{third}"
  end

  def get_leagues(%Plug.Conn{params: params} = conn, _params) do
    data = File.stream!(Path.absname("data.csv")) |> CSV.decode
    data = data
    |> Enum.slice(1, Enum.count(data))
    |> Enum.map( 
      fn ({:ok, [id, div, season, date, home_team, away_team, _fthg, _ftag, _ftr, _hthg, _htag, _htr]}) -> %{
        "id" => id, 
        "date" => date, 
        "pair" => "#{home_team} #{away_team}",
        "division" => div,
        "season" => parsed_season_pair(season)
      }
    end)

    request_season = Map.get(params, "season")
    if request_season do
      json conn, Enum.filter(data, fn(row) -> Map.get(row, "season") == request_season end)
    end

    request_division = Map.get(params, "division")
    if request_division do
      json conn, Enum.filter(data, fn(row) -> Map.get(row, "division") == request_division end)
    end

    json conn, data
  end
end
