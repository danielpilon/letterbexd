defmodule NetworkFilms do
  def by_followees_rating(user_id, rating) do
    with {:ok, user_profile} <- user_id |> UserProfile.from(),
         {:ok, %Network{followees: followees}} <- Network.from(user_profile) do
      followees
      |> Stream.flat_map(&films_by_rating(&1.user_id, rating))
      |> Enum.reduce(%{}, &catalog_film_frequencies/2)
      |> Enum.sort(&sort_by_frequency/2)
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

  defp catalog_film_frequencies(film, film_map) do
    film_map
    |> Map.update(film, 1, &Kernel.+(&1, 1))
  end

  defp sort_by_frequency({_, quantity_1}, {_, quantity_2}), do: quantity_1 >= quantity_2
end
