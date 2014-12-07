defmodule PortalDoorTest do
  use ExUnit.Case

  test "start_link: starts a Portal.Door with the given color" do
    Portal.Door.start_link(:orange)
    assert [] == Agent.get(:orange, fn list -> list end)
  end

  test "get: returns the content of the door" do
    Portal.Door.start_link(:blue)
    assert Agent.get(:blue, fn list -> list end) == Portal.Door.get(:blue)
  end

  test "push: pushes content through the door" do
    Portal.Door.start_link(:brown)
    Portal.Door.push(:brown, 1)
    assert [1] == Portal.Door.get(:brown)
  end

  test "pop: when not blank, returns the first element of the door" do
    Portal.Door.start_link(:yellow)
    Portal.Door.push(:yellow, 3)
    Portal.Door.push(:yellow, 5)
    assert {:ok, 5} = Portal.Door.pop(:yellow)
  end

  test "pop: when not blank, removes the first element of the door" do
    Portal.Door.start_link(:magenta)
    Portal.Door.push(:magenta, 3)
    Portal.Door.push(:magenta, 5)
    Portal.Door.pop(:magenta)
    assert [3] == Portal.Door.get(:magenta)
  end

  test "pop: when blank, does not change the value" do
    Portal.Door.start_link(:black)
    Portal.Door.pop(:black)
    assert [] == Portal.Door.get(:black)
  end

  test "pop: when blank, returns error sign" do
    Portal.Door.start_link(:white)
    assert :error = Portal.Door.pop(:white)
  end
end
