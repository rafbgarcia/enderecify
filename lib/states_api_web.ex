defmodule StatesApiWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use StatesApiWeb, :controller
      use StatesApiWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: StatesApiWeb

      import Plug.Conn
      import StatesApiWeb.Gettext
      alias StatesApiWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/states_api_web/templates",
                        namespace: StatesApiWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import StatesApiWeb.ErrorHelpers
      import StatesApiWeb.Gettext
      alias StatesApiWeb.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import StatesApiWeb.Gettext
    end
  end

  def schema do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
    end
  end

  def graphql_resolver do
    quote do
      alias StatesApi.Repo
      import Ecto.Query, warn: false
      import Ecto
    end
  end

  def graphql_schema do
    quote do
      use Absinthe.Schema.Notation
      use Absinthe.Ecto, repo: StatesApi.Repo
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
