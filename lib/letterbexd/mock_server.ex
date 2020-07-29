defmodule Letterbexd.MockServer do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/user1/" do
    conn
    |> Plug.Conn.send_resp(
      200,
      """
        <div class="profile-name-wrap">
          <h1 title="User 1" class="title-1">User 1</h1>
        </div>
        <ul class="stats">
          <li><a href="/dmyoko/films/"><strong>390</strong><span>Films</span></a></li>
          <li><a href="/dmyoko/following/"><strong>13</strong><span>Following</span></a></li>
          <li><a href="/dmyoko/followers/"><strong>16</strong><span>Followers</span></a></li>
        </ul>
      """
    )
  end

  get "/user2/" do
    conn
    |> Plug.Conn.send_resp(
      200,
      """
        <div class="profile-name-wrap">
          <h1 title="User 2" class="title-1">User 2</h1>
        </div>
        <ul class="stats">
          <li><a href="/dmyoko/films/"><strong>390</strong><span>Films</span></a></li>
          <li><a href="/dmyoko/following/"><strong>30</strong><span>Following</span></a></li>
          <li><a href="/dmyoko/followers/"><strong>16</strong><span>Followers</span></a></li>
        </ul>
      """
    )
  end

  get "/user1/following/page/1/" do
    conn
    |> Plug.Conn.send_resp(
      200,
      """
        <a href="/user2/" class="name"> User 2 </a>
      """
    )
  end

  get "/user2/following/page/1/" do
    conn
    |> Plug.Conn.send_resp(200, repeatedly("<a href=\"/user2/\" class=\"name\"> User 2 </a>", 25))
  end

  get "/user2/following/page/2/" do
    conn
    |> Plug.Conn.send_resp(200, repeatedly("<a href=\"/user2/\" class=\"name\"> User 2 </a>", 5))
  end

  get "/user1/films/ratings/rated/5/" do
    conn
    |> Plug.Conn.send_resp(
      200,
      """
        <h2 class="ui-block-heading">
          <span class="replace-if-you" data-replacement="You’ve" data-person="user1">You’ve</span> rated 1&nbsp;films <span class="rating -tiny rated-10"> ★★★★★ </span>.
        </h2>
      """
    )
  end

  get "/user1/films/ratings/rated/5/page/1/" do
    conn
    |> Plug.Conn.send_resp(
      200,
      """
        <div class="poster" data-film-id="film1" data-target-link="/film1"></div>
      """
    )
  end

  defp repeatedly(value, times),
    do: Stream.repeatedly(fn -> value end) |> Enum.take(times) |> Enum.join()
end
