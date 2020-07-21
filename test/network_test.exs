defmodule LetterbexdTest do
  use ExUnit.Case
  doctest Network

  test "returns followees list" do
    {:ok, user_profile} = UserProfile.from("dmyoko")
    {:ok, %Network{followees: followees}} = Network.from(user_profile)
    expected = %{name: "Daniel Pilon", profile_url: "https://letterboxd.com/danielpilon/"}
    assert followees |> Enum.member?(expected)
  end

  test "returns followees list with all pages" do
    {:ok, user_profile} = UserProfile.from("danielpilon")
    {:ok, %Network{followees: followees}} = Network.from(user_profile)
    assert Enum.count(followees) == user_profile.following
  end
end
