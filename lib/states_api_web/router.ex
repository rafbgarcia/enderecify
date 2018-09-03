defmodule StatesApiWeb.Router do
  use StatesApiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", StatesApiWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/api", PageController, :api_reference
  end

  scope "/" do
    pipe_through :api

    post("/", Absinthe.Plug.GraphiQL, schema: StatesApiWeb.Graphql.Schema, json_codec: Phoenix.json_library())
  end
end
