defmodule Boxer.HTTP.Request do
  alias Boxer.HTTP.Request
  defstruct method:   :get,
            path:     "/",
            body:     "",
            headers:  []

  @methods [:get, :post, :put, :delete]

  @doc """
  Create a new HTTP request
  """
  def new(path) when is_binary(path),
    do: %Request{method: :get, path: path}
  def new(method, path) when method in @methods and is_binary(path),
    do: %Request{method: method, path: path}
  def new(method, path, body, headers) when method in @methods and is_binary(path),
    do: %Request{method: method, path: path}
  @doc """
  Set the request method
  """
  def method(request, method) when method in @methods,
    do: %{request | method: method}

  @doc """
  Set the request body
  """
  def body(request, body) when is_binary(body),
    do: %{request | body: body}
  def body(request, body) when is_map(body),
    do: %{request | body: Poison.encode!(body)}

  @doc """
  Add a header to the request
  """
  def header(%{headers: headers} = request, key, value) when is_binary(key) and is_binary(value),
    do: %{request | headers: [{key, value} | headers]}
  def headers(request, headers) when is_list(headers),
    do: Enum.reduce(headers, request, __MODULE__.header(&2, &1))

  @doc """
  Serialize a request into iodata
  """
  def serialize(%{method: method, path: path, headers: headers}) when method in [:get, :delete] do
    method = method
    |> Atom.to_string
    |> String.upcase

    headers = headers
    |> Enum.map(fn {k, v} -> "#{k}: #{v}" end)
    |> Enum.join("\r\n")

    "#{method} #{path} HTTP/1.1\r\n#{headers}\r\n"
  end
end