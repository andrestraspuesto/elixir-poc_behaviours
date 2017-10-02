defmodule PocBehaviours.VentanillaSupervisor do
  use Supervisor

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def abre_ventanilla(nombre) do
    Supervisor.start_child(__MODULE__, [nombre])
  end

  def init(:ok) do
    children = [
      worker(PocBehaviours.VentanillaServer, [],  restart: :transient)
    ]
    Supervisor.init(children, strategy: :simple_one_for_one)
  end
end
