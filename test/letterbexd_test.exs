defmodule LetterbexdTest do
  use ExUnit.Case
  doctest Letterbexd

  test "returns followees list" do
    {:ok, user_profile} = UserProfile.from("dmyoko")
    {:ok, followees} = Letterbexd.get_followees(user_profile)
    expected = %Friend{name: "Daniel Pilon", profile_url: "https://letterboxd.com/danielpilon/"}
    assert followees |> Enum.member?(expected)
  end

  test "returns followees list with all pages" do
    {:ok, user_profile} = UserProfile.from("danielpilon")
    {:ok, followees} = Letterbexd.get_followees(user_profile)
    assert Enum.count(followees) == user_profile.following
  end
end
