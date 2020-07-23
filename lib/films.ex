defmodule Films do
  @enforce_keys [:id, :url]
  defstruct [:id, :url]

  def by_rating(user_id, rating) do
    url = "https://letterboxd.com/#{user_id}/films/ratings/rated/#{Rating.from(rating)}/"

    quantity =
      url
      |> HTTPoison.get()
      |> get_ratings_quantity()

    films =
      quantity
      |> get_movie_pages
      |> Enum.reduce([], &fetch_movies_page("#{url}page/#{&1}/", &2))

    {:ok, films}
  end

  def get_ratings_quantity({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    {:ok, parsed} = Floki.parse_document(body)

    heading =
      parsed
      |> Floki.find(".ui-block-heading")
      |> Floki.text()

    quantity =
      Regex.named_captures(~r/rated\s(?<quantity>[0-9].)/, heading)
      |> Map.get("quantity")
      |> String.to_integer()

    quantity
  end

  defp get_movie_pages(following) do
    pages = (following / 18) |> Float.ceil(0) |> trunc()

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
    |> Floki.find("div .poster")
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
