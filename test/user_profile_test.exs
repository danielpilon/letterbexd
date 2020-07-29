defmodule UserProfileTest do
  use ExUnit.Case

  test "returns user profile" do
    {:ok, user_profile} = UserProfile.from("user1")

    expected = %UserProfile{
      name: "User 1",
      followers: 16,
      following: 13,
      films: 390,
      user_id: "user1"
    }

    assert user_profile == expected
  end
end
