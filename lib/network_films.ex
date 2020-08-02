defmodule NetworkFilms do
  @type film_frequency :: %{
          film: Films.t(),
          frequency: integer()
        }

  @type t :: %NetworkFilms{
          films: list(film_frequency),
          user_id: String.t(),
          ratings: list(Rating.t())
        }

  @enforce_keys [:user_id, :ratings]
  defstruct films: %{}, user_id: nil, ratings: []

  @spec by_followees_rating(String.t(), Rating.t()) :: {:ok, NetworkFilms.t()}
  def by_followees_rating(user_id, ratings) do
    with {:ok, user_profile} <- user_id |> UserProfile.from(),
         {:ok, %Network{followees: followees}} <- Network.from(user_profile) do
      films =
        followees
        |> Task.async_stream(&films_by_rating(&1.user_id, ratings),
          ordered: false,
          timeout: Kernel.max(user_profile.following * 1000, 5000)
        )
        |> Stream.flat_map(fn {:ok, films} -> films end)
        |> Enum.frequencies()
        |> Enum.sort(&sort_by_frequency/2)
        |> Enum.map(&to_film_frequency/1)

      {:ok, %NetworkFilms{user_id: user_id, ratings: ratings, films: films}}
    else
      err -> raise err
    end
  end

  defp films_by_rating(user_id, ratings) do
    with {:ok, films} <- Films.by_rating(user_id, ratings) do
      films
    else
      err -> raise err
    end
  end

  defp sort_by_frequency({_, quantity_1}, {_, quantity_2}), do: quantity_1 >= quantity_2

  defp to_film_frequency({key, data}), do: %{film: key, frequency: data}
end
