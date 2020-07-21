defmodule Letterbexd do
  @moduledoc """
  Documentation for `Letterbexd`.
  """

  def get_followees(%UserProfile{id: id, following: following}) do
    friends =
      following
      |> get_following_pages
      |> Enum.reduce([], fn page, acc ->
        fetch_following_page("https://letterboxd.com/#{id}/following/page/#{page}/", acc)
      end)

    {:ok, friends}
  end

  defp to_friends({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    {:ok, parsed} = body |> Floki.parse_document()

    parsed
    |> Floki.find("a.name")
    |> Enum.map(&to_friend/1)
  end

  defp to_friend({"a", _attrs, [friend_name]} = anchor) do
    [href] = Floki.attribute([anchor], "href")
    %Friend{name: friend_name |> String.trim(), profile_url: "https://letterboxd.com#{href}"}
  end

  defp get_following_pages(following) do
    pages = div(following, 25)

    if pages * 25 < following do
      1..(pages + 1)
    else
      1..pages
    end
  end

  defp fetch_following_page(url, acc) do
    friends =
      url
      |> HTTPoison.get()
      |> to_friends

    acc ++ friends
  end
end
