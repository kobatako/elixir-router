defmodule Sample do
  @moduledoc """
  Documentation for Sample.
  """

  @doc """
  this is main process
  """
  def main([]) do
    IO.puts "Hello world"
    res = :libpacket.open(0, [{:protocol, 0x300}, {:type, :raw}, {:family, :packet}])
    Main.start(res)
  end
end
