defmodule FilmsTest do
  use ExUnit.Case

  test "returns followees films by rating" do
    {:ok, films} = Films.by_rating("user1", [:five])
    assert Enum.count(films) == 1
  end

  test "return followees films by range of ratings" do
    {:ok, films} = Films.by_rating("user1", [:four_and_half, :five])
    assert Enum.count(films) == 2
  end
end
