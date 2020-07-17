defmodule LetterbexdTest do
  use ExUnit.Case
  doctest Letterbexd

  test "greets the world" do
    assert Letterbexd.hello() == :world
  end
end
