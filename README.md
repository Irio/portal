# Portal

A project to simulate [Portal](http://en.wikipedia.org/wiki/Portal_(video_game)) behaviour in Elixir. The transferred data are elements from a List. State is kept via [Agents API](http://elixir-lang.org/docs/stable/elixir/Agent.html) - accessible via multiple processes - backed up by [Supervisors](http://elixir-lang.org/docs/stable/elixir/Supervisor.html), responsible to restart processes of portals if something happen with them.

## Setup

Install Elixir and fetch dependencies.

```console
$ brew install elixir
$ mix deps.get
```

## Running

### Experience supervisors in action

```console
$ cd <folder with project>
$ iex -S mix
```

```elixir
iex> Portal.shoot(:orange)
{:ok, #PID<0.72.0>}
iex> Portal.shoot(:blue)
{:ok, #PID<0.74.0>}
iex> portal = Portal.transfer(:orange, :blue, [1, 2, 3, 4])
#Portal<
       :orange <=> :blue
  [1, 2, 3, 4] <=> []
>

iex> Portal.push_right(portal)
#Portal<
    :orange <=> :blue
  [1, 2, 3] <=> [4]
>
iex> Process.unlink(Process.whereis(:blue))
true
iex> Process.exit(Process.whereis(:blue), :shutdown)
true
iex> Portal.push_right(portal)
#Portal<
  :orange <=> :blue
   [1, 2] <=> [3]
>
```

### Willing to try between more than one Elixir node?

**Terminal window 1**

```console
$ iex --sname room1 --cookie secret -S mix
```

```elixir
iex(room1@MacBook-Air-de-Irio)1> Portal.shoot(:blue)
```

**Terminal window 2**

```console
$ iex --sname room2 --cookie secret -S mix
```

```elixir
iex(room2@MacBook-Air-de-Irio)1> Portal.Door.get({:blue, :"room1@MacBook-Air-de-Irio"})
[]
iex(room2@MacBook-Air-de-Irio)2> Portal.shoot(:orange)
{:ok, #PID<0.94.0>}
iex(room2@MacBook-Air-de-Irio)3> orange = {:orange, :"room2@MacBook-Air-de-Irio"}
{:orange, :"room2@MacBook-Air-de-Irio"}
iex(room2@MacBook-Air-de-Irio)4> blue = {:blue, :"room1@MacBook-Air-de-Irio"}
{:blue, :"room1@MacBook-Air-de-Irio"}
iex(room2@MacBook-Air-de-Irio)5> portal = Portal.transfer(orange, blue, [1, 2, 3, 4])
#Portal<
  {:orange, :"room2@MacBook-Air-de-Irio"} <=> {:blue, :"room1@MacBook-Air-de-Irio"}
                             [1, 2, 3, 4] <=> []
>

iex(room2@MacBook-Air-de-Irio)6> Portal.push_right(portal)
#Portal<
  {:orange, :"room2@MacBook-Air-de-Irio"} <=> {:blue, :"room1@MacBook-Air-de-Irio"}
                                [1, 2, 3] <=> [4]
>
```

**Terminal window 1**

```elixir
iex(room1@MacBook-Air-de-Irio)2> orange = {:orange, :"room2@MacBook-Air-de-Irio"}
{:orange, :"room2@MacBook-Air-de-Irio"}
iex(room1@MacBook-Air-de-Irio)3> blue = {:blue, :"room1@MacBook-Air-de-Irio"}
{:blue, :"room1@MacBook-Air-de-Irio"}
iex(room1@MacBook-Air-de-Irio)4> Portal.Door.get(orange)
[3, 2, 1]
iex(room1@MacBook-Air-de-Irio)5> Portal.Door.get(blue)
[4]
```

## Testing

```console
$ mix test
```

## Inspiration

This project was created based on [José Valim's tutorial](http://howistart.org/posts/elixir/1) for How I Start.
