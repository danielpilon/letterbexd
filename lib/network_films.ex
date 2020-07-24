defmodule NetworkFilms do
  @type film_frequency :: %{
          film: Films.t(),
          frequency: integer()
        }

  @type t :: %NetworkFilms{
          films: list(film_frequency),
          user_id: String.t(),
          rating: Rating.t()
        }

  @enforce_keys [:user_id, :rating]
  defstruct films: %{}, user_id: nil, rating: nil

  @spec by_followees_rating(String.t(), Rating.t()) :: NetworkFilms.t()
  def by_followees_rating(user_id, rating) do
    with {:ok, user_profile} <- user_id |> UserProfile.from(),
         {:ok, %Network{followees: followees}} <- Network.from(user_profile) do
      films =
        followees
        |> Task.async_stream(&films_by_rating(&1.user_id, rating),
          ordered: false,
          timeout: Kernel.max(user_profile.following * 1000, 5000)
        )
        |> Stream.flat_map(fn {:ok, films} -> films end)
        |> Enum.reduce(%{}, &catalog_film_frequencies/2)
        |> Enum.sort(&sort_by_frequency/2)
        |> Enum.into([], &to_film_frequency/1)

      %NetworkFilms{user_id: user_id, rating: rating, films: films}
    else
      err -> raise err
    end
  end

  defp films_by_rating(user_id, rating) do
    with {:ok, films} <- Films.by_rating(user_id, rating) do
      films
    else
      err -> raise err
    end
  end

  defp catalog_film_frequencies(film, film_map),
    do: film_map |> Map.update(film, 1, &Kernel.+(&1, 1))

  defp sort_by_frequency({_, quantity_1}, {_, quantity_2}), do: quantity_1 >= quantity_2

  defp to_film_frequency({key, data}), do: %{film: key, frequency: data}
end
