defmodule PocBehaviours.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # Listado de todos los procesos que son supervisados
    #directamente por PocBehaviours.Application
    children = [
      # {PocBehaviours.Worker, arg},
    ]
    #Opciones de configuración de la supervisión
    #Estrategias indican como se debe actuar cuando
    #se notifique al supervisor la finalización de uno de los
    #procesos que supervisa
    opts = [strategy: :one_for_one, name: PocBehaviours.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
