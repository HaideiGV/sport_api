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
      fn ({:ok, [id, _div, season, date, home_team, away_team, _fthg, _ftag, _ftr, _hthg, _htag, _htr]}) -> %{
        "id" => id, "date" => date, "pair" => "#{home_team} #{away_team}",
        "season" => "#{String.slice(season, 0, 4)}-#{String.slice(season, 0, 2) <> String.slice(season, 4, 6)}"
      }
    end)

    request_season = Map.get(params, "season")
    if request_season do
      json conn, Enum.filter(data, fn(row) -> Map.get(row, "season") == request_season end)
    end

    json conn, data
  end
end
