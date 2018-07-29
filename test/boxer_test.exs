defmodule BoxerTest do
  use ExUnit.Case
  doctest Boxer

  test "greets the world" do
    assert Boxer.hello() == :world
  end
end
