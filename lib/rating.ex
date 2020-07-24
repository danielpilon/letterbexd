defmodule Rating do
  @type t ::
          :five
          | :four_and_half
          | :four
          | :three_and_half
          | :three
          | :two_and_half
          | :two
          | :one_and_half
          | :one
          | :half

  @rating_to_string %{
    :five => "5",
    :four_and_half => "4½",
    :four => "4",
    :three_and_half => "3½",
    :three => "3",
    :two_and_half => "2½",
    :two => "2",
    :one_and_half => "1½",
    :one => "1",
    :half => "½"
  }

  @spec from(Rating.t()) :: String.t()
  def from(rating), do: @rating_to_string[rating]
end
