defmodule LetterbexdTest do
  use ExUnit.Case
  doctest Network

  @base_url Application.get_env(:letterbexd, :letterboxd_url)

  test "returns followees list" do
    {:ok, user_profile} = UserProfile.from("user1")
    {:ok, %Network{followees: followees}} = Network.from(user_profile)
    expected = %{name: "User 2", profile_url: "#{@base_url}/user2/", user_id: "user2"}
    assert followees |> Enum.member?(expected)
  end

  test "returns followees list with all pages" do
    {:ok, user_profile} = UserProfile.from("user2")
    {:ok, %Network{followees: followees}} = Network.from(user_profile)
    assert Enum.count(followees) == user_profile.following
  end
end
