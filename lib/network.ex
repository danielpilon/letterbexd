defmodule Network do
  @type friend :: %{
          name: String.t(),
          profile_url: String.t()
        }
  @type t :: %Network{
          followees: list(friend)
        }
  defstruct followees: []

  @spec from(UserProfile.t()) :: {:ok, Network.t()}
  def from(%UserProfile{id: id, following: following}) do
    following_url = "https://letterboxd.com/#{id}/following/page/"

    followees =
      following
      |> get_following_pages
      |> Enum.reduce([], &fetch_following_page("#{following_url}#{&1}/", &2))

    {:ok, %Network{followees: followees}}
  end

  defp to_friends({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    {:ok, parsed} = body |> Floki.parse_document()

    parsed
    |> Floki.find("a.name")
    |> Enum.map(&to_friend/1)
  end

  defp to_friend({"a", _attrs, [friend_name]} = anchor) do
    [href] = Floki.attribute([anchor], "href")

    %{
      name: friend_name |> String.trim(),
      profile_url: "https://letterboxd.com#{href}"
    }
  end

  defp get_following_pages(following) do
    pages = (following / 25) |> Float.ceil(0) |> trunc()

    1..pages
  end

  defp fetch_following_page(url, acc) do
    friends =
      url
      |> HTTPoison.get()
      |> to_friends

    acc ++ friends
  end
end
