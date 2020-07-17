defmodule LetterbexdTest do
  use ExUnit.Case
  doctest Letterbexd

  test "returns followees list" do
    {:ok, followees} = Letterbexd.get_followees("dmyoko")
    expected = %Friend{name: "Daniel Pilon", profile_url: "https://letterboxd.com/danielpilon/"}
    assert followees |> Enum.member?(expected)
  end

  test "returns user profile" do
    {:ok, user_profile} = Letterbexd.get_user_profile("dmyoko")

    expected = %UserProfile{
      name: "Daniel Moreira Yokoyama",
      followers: 16,
      following: 13,
      films: 389,
      id: "dmyoko"
    }

    assert user_profile == expected
  end
end
