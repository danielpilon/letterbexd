defmodule Films do
  @type t :: %Films{
          id: String.t(),
          url: String.t()
        }
  @enforce_keys [:id, :url]
  defstruct [:id, :url]

  @base_url Application.get_env(:letterbexd, :letterboxd_url)

  @spec by_rating(
          String.t(),
          list(Rating.t())
        ) :: {:ok, list(Films.t())}
  def by_rating(user_id, ratings) do
    films =
      ratings
      |> Enum.map(&"#{@base_url}/#{user_id}/films/ratings/rated/#{Rating.from(&1)}/")
      |> Enum.flat_map(&films_from/1)

    {:ok, films}
  end

  defp films_from(url) do
    url
    |> HTTPoison.get()
    |> get_ratings_quantity()
    |> get_movie_pages()
    |> Enum.reduce([], &fetch_movies_page("#{url}page/#{&1}/", &2))
  end

  defp get_ratings_quantity({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    {:ok, parsed} = Floki.parse_document(body)

    heading =
      parsed
      |> Floki.find(".ui-block-heading")
      |> Floki.text()
      |> HtmlEntities.decode()

    (Regex.named_captures(~r/rated\s(?<quantity>[0-9].*)films/, heading) ||
       %{})
    |> Map.get("quantity", "0")
    |> String.trim()
    |> String.to_integer()
  end

  defp get_movie_pages(following) do
    pages = (following / 18) |> Float.ceil(0) |> trunc() |> Kernel.max(1)

    1..pages
  end

  defp fetch_movies_page(url, acc) do
    movies =
      url
      |> HTTPoison.get()
      |> to_films

    acc ++ movies
  end

  defp to_films({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    {:ok, parsed} = Floki.parse_document(body)

    parsed
    |> Floki.find("div.poster")
    |> Enum.map(&to_film/1)
  end

  defp to_film(div) do
    id = value_from(div, "data-film-id")
    url = value_from(div, "data-target-link")

    %Films{id: id, url: url}
  end

  defp value_from(element, attribute) do
    [value] = Floki.attribute(element, attribute)
    value
  end
end
