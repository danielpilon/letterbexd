defmodule UserProfileTest do
  use ExUnit.Case

  test "returns user profile" do
    {:ok, user_profile} = UserProfile.from("dmyoko")

    expected = %UserProfile{
      name: "Daniel Moreira Yokoyama",
      followers: 16,
      following: 13,
      films: 390,
      id: "dmyoko"
    }

    assert user_profile == expected
  end
end
