defmodule FilmsTest do
  use ExUnit.Case

  test "returns followees films by rating" do
    {:ok, films} = Films.by_rating("dmyoko", 5)
    assert Enum.count(films) == 21
  end
end
