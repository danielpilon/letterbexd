defmodule FilmList do
  @base_url Application.get_env(:letterbexd, :letterboxd_url)
  @metadata_header ["Date", "Name", "Tags", "URL", "Description"]
  @films_header ["Position", "Name", "Year", "URL", "Description"]
  NimbleCSV.define(FilmListCsvParser, separator: ",", escape: "\"")

  @spec network_films_to_csv(NetworkFilms.t(), String.t()) :: :ok
  def network_films_to_csv(network_films, file_name) do
    network_films.films
    |> Enum.map(&full_url/1)
    |> Enum.with_index(1)
    |> Enum.map(&to_csv/1)
    |> prepend_header()
    |> prepend_metadata(network_films)
    |> FilmListCsvParser.dump_to_iodata()
    |> write_file(file_name)
  end

  defp full_url(%{film: %{url: film_url}}), do: "#{@base_url}#{film_url}"
  defp to_csv({url, position}), do: [position, "", "", url, ""]
  defp prepend_header(lines), do: [@films_header] ++ lines

  defp prepend_metadata(films, network_films),
    do: [[], @metadata_header, [today(), list_name(network_films), "", "", ""], []] ++ films

  defp today() do
    date = Date.utc_today()

    :io_lib.format("~4..0B-~2..0B-~2..0B", [date.year, date.month, date.day])
    |> IO.iodata_to_binary()
  end

  defp list_name(network_films),
    do: "#{network_films.user_id}-following-#{Atom.to_string(network_films.rating)}-stars"

  defp write_file(content, file_name), do: File.write!(file_name, content)
end
