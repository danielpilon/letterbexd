defmodule FilmsTest do
  use ExUnit.Case

  test "returns followees films by rating" do
    {:ok, films} = Films.by_rating("dmyoko", :five)
    assert Enum.count(films) == 22
  end
end
