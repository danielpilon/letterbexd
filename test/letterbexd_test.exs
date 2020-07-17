defmodule LetterbexdTest do
  use ExUnit.Case
  doctest Letterbexd

  test "returns followees list" do
    {:ok, followees} = Letterbexd.get_followees("dmyoko")
    expected = %Friend{name: "Daniel Pilon", profile_url: "https://letterboxd.com/danielpilon/"}
    assert followees |> Enum.member?(expected)
  end
end
