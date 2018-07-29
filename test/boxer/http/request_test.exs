defmodule Boxer.HTTP.RequestTest do
  use ExUnit.Case, async: true

  alias Boxer.HTTP.Request

  describe "new/1" do
    test "creates a new HTTP Request struct with method set to :get" do
      assert Request.new("/foo") == %Request{method: :get, path: "/foo"}
    end
  end

  describe "new/2" do
    test "creates a new HTTP Request struct with the specified method and path" do
      assert Request.new(:delete, "/foo") == %Request{method: :delete, path: "/foo"}
    end
  end

  describe "body/2" do
    test "sets the body parameter to the specified value if the value is a string" do
      request = Request.new("/foo")
      |> Request.method(:post)
      |> Request.body("foo")

      assert request == %Request{method: :post, path: "/foo", body: "foo"}
    end

    test "sets the body parameter to the JSON form of a given map value" do
      request = Request.new("/foo")
      |> Request.method(:post)
      |> Request.body(%{})

      assert request == %Request{method: :post, path: "/foo", body: "{}"}
    end
  end

  describe "serialize/1" do
    test "serializes a GET or DELETE request into a correct HTTP request body" do
      payload = Request.new("/foo")
      |> Request.serialize

      assert payload == "GET /foo HTTP/1.1\r\n\r\n"
    end

    test "correctly serializes a request that includes headers" do
      payload = Request.new("/foo")
      |> Request.header("User-Agent", "boxer/1.1")
      |> Request.serialize

      assert payload == "GET /foo HTTP/1.1\r\nUser-Agent: boxer/1.1\r\n"
    end
  end
end