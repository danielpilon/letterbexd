defmodule UserProfile do
  @type t :: %UserProfile{
          name: String.t(),
          films: integer(),
          following: integer(),
          followers: integer(),
          user_id: String.t()
        }
  @enforce_keys [:name, :films, :following, :followers, :user_id]
  defstruct [:name, :films, :following, :followers, :user_id]

  @base_url Application.get_env(:letterbexd, :letterboxd_url)

  @spec from(String.t()) :: {:ok, UserProfile.t()}
  def from(user_id) do
    user_profile =
      HTTPoison.get("#{@base_url}/#{user_id}/")
      |> to_user_profile(user_id)

    {:ok, user_profile}
  end

  defp to_user_profile({:ok, %HTTPoison.Response{status_code: 200, body: body}}, user_id) do
    {:ok, parsed} = body |> Floki.parse_document()

    [name] = parsed |> Floki.find("div.profile-name-wrap h1.title-1") |> Floki.attribute("title")
    films = value_from(parsed, "Films")
    followers = value_from(parsed, "Follower")
    following = value_from(parsed, "Following")

    %UserProfile{
      name: name,
      films: films,
      followers: followers,
      following: following,
      user_id: user_id
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
end
