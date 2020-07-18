defmodule Letterbexd do
  @moduledoc """
  Documentation for `Letterbexd`.
  """

  def get_followees(user_name) do
    friends = user_name
    |> get_user_profile
    |> get_following_pages
    |> Enum.reduce([], fn (page, acc) -> fetch_following_page("https://letterboxd.com/#{user_name}/following/page/#{page}/", acc) end)

    {:ok, friends}
  end

  def get_user_profile(user_name) do
    user_profile =
      HTTPoison.get("https://letterboxd.com/#{user_name}/")
      |> to_user_profile(user_name)

    {:ok, user_profile}
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

  defp to_user_profile({:ok, %HTTPoison.Response{status_code: 200, body: body}}, user_name) do
    {:ok, parsed} = body |> Floki.parse_document()

    [name] = parsed |> Floki.find("div.profile-name-wrap h1.title-1") |> Floki.attribute("title")
    films = value_from(parsed, "Films")
    followers = value_from(parsed, "Followers")
    following = value_from(parsed, "Following")

    %UserProfile{
      name: name,
      films: films,
      followers: followers,
      following: following,
      id: user_name
    }
  end

  defp value_from(html, span) do
    html
    |> Floki.find("ul.stats a")
    |> Enum.filter(&(Floki.find(&1, "span:fl-contains('#{span}')") != []))
    |> Floki.find("strong")
    |> Floki.text()
    |> String.replace(",", "")
    |> String.to_integer()
  end

  defp get_following_pages({:ok, %UserProfile{ following: following }}) do
    pages = div(following, 25)
    if pages * 25 < following do
      1..(pages + 1)
    else
      1..pages
    end
  end

  defp fetch_following_page(url, acc) do
    friends = url
    |> HTTPoison.get
    |> to_friends
    acc ++ friends
  end
end
