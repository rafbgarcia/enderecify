defmodule StatesApiWeb.PageController do
  use StatesApiWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
