defmodule Sample do
  @moduledoc """
  Documentation for Sample.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Sample.hello
      :world

  """
  def hello do
    :world
  end

  def main([]) do
    IO.puts "Hello world"
    res = :libpacket.open(0, [{:protocol, 0x300}, {:type, :raw}, {:family, :packet}])
    interface = :interface.get_interface()
    IO.inspect interface
    Main.start(res)
  end
end
