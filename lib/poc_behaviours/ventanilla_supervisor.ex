defmodule PocBehaviours.VentanillaSupervisor do
  use Supervisor
  @moduledoc """
  Modulo encargado de supervisar la creación de procesos
  PocBehaviours.VentanillaServer, que si se cierran no vuelven a
  abrirse
  """
  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def abre_ventanilla(nombre) do
    Supervisor.start_child(__MODULE__,
    [nombre,%{solicitado_handler: &PocBehaviours.RegistroAgent.put/1}])
  end

  def init(:ok) do
    children = [
      worker(PocBehaviours.VentanillaServer, [],  restart: :temporary)
    ]
    Supervisor.init(children, strategy: :simple_one_for_one)
  end
end
