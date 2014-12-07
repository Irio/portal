defmodule PortalTest do
  use ExUnit.Case

  test "shoot: starts a Portal.Door with the given color" do
    Portal.shoot(:orange)
    assert Portal.Door.get(:orange)
  end

  test "transfer: push data into left struct" do
    Portal.shoot(:orange)
    Portal.shoot(:green)
    Portal.transfer(:orange, :green, [1])
    assert Portal.Door.get(:orange) == [1]
    assert Portal.Door.get(:green) == []
  end

  test "push_right: push head of left into right struct" do
    Portal.shoot(:orange)
    Portal.shoot(:blue)
    portal = Portal.transfer(:orange, :blue, [1])
    Portal.push_right(portal)
    assert Portal.Door.get(:orange) == []
    assert Portal.Door.get(:blue) == [1]
  end

  test "push_left: push head of right into left struct" do
    Portal.shoot(:yellow)
    Portal.shoot(:magenta)
    portal = Portal.transfer(:yellow, :magenta, [])
    Portal.Door.push(:magenta, 3)
    Portal.push_left(portal)
    assert Portal.Door.get(:yellow) == [3]
    assert Portal.Door.get(:magenta) == []
  end
end
