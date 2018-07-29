defmodule Boxer.Socket do
  @moduledoc """
  Socket connection to the Docker Daemon
  """
  use GenServer
  defstruct [:socket]

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, Keyword.take(opts, [:name]))
  end
  
  @doc """
  Send a payload to the docker daemon
  """
  def request(server, method, path, body, headers),
    do: GenServer.call(server, {:request, method, path, body, headers})
  
  #
  # GenServer Callbacks
  #
  def init(opts) do
    fd = file_descriptor(opts)
    if File.exists?(fd) do
      {:ok, socket} = :gen_udp.open({:local, fd})
      {:ok, %Boxer.Socket{socket: socket}}
    else
      {:stop, "Unable to locate docker daemon socket file descriptor"}
    end
  end
  
  def handle_call({:request, method, path, body, headers}, _from, %{socket: socket} = state) do
    
  end

  #
  # Get the path to the docker daemon socket file descriptor
  #
  defp file_descriptor(opts) when is_list(opts) do
    Keyword.get(opts, :file_descriptor, file_descriptor(:os.type()))
  end
  defp file_descriptor({:unix, :darwin}),
    do: "/private/var/run/docker.sock"
  defp file_descriptor(_),
    do: "/var/run/docker.sock"
end