defmodule Letterbexd do
  @moduledoc """
  Documentation for `Letterbexd`.
  """

  def get_followees(user_name) do
    friends = HTTPoison.get("https://letterboxd.com/#{user_name}/following/")
    |> to_friends
    {:ok, friends}
  end

  defp to_friends({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
      body
      |> Floki.find("a.name")
      |> Enum.map(&to_friend/1)
  end

  defp to_friend({"a", _, [friend_name]} = anchor) do
    href = Floki.attribute(anchor, "href")
    friend_name = friend_name |> String.trim
    %Friend{name: friend_name, profile_url: "https://letterboxd.com#{href}"}
  end
end
