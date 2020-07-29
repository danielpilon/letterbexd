defmodule FilmsTest do
  use ExUnit.Case

  test "returns followees films by rating" do
    {:ok, films} = Films.by_rating("user1", :five)
    assert Enum.count(films) == 1
  end
end
