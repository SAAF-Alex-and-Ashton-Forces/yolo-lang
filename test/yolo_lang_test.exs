defmodule YoloLangTest do
  use ExUnit.Case
  doctest YoloLang

  test "greets the world" do
    assert YoloLang.hello() == :world
  end
end
