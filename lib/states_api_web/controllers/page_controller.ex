defmodule StatesApiWeb.PageController do
  use StatesApiWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def api_reference(conn, _params) do
    render conn, "api_reference.html"
  end
end
