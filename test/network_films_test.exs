defmodule NetworkFilmsTest do
  use ExUnit.Case

  test "retrieves 5 start rated films from followees" do
    {:ok, network_films} = NetworkFilms.by_followees_rating("user2", [:four_and_half, :five])

    expected = %NetworkFilms{
      films: [
        %{film: %Films{id: "film1", url: "/film1"}, frequency: 30},
        %{film: %Films{id: "film2", url: "/film2"}, frequency: 30}
      ],
      ratings: [:four_and_half, :five],
      user_id: "user2"
    }

    assert network_films == expected
  end
end
