defmodule PocBehaviours.RegistroAgent do
  use Agent
  alias PocBehaviours.Tramitacion

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @doc """
  Devuelve el trámite asociado al nombre
      ##Ejemplo
      iex>PocBehaviours.RegistroAgent.start_link([])
      iex>tramite = %PocBehaviours.Tramitacion{nombre: "pepe", email: "aa@ee.es"}
      iex>PocBehaviours.RegistroAgent.put(tramite)
      :ok
      iex>PocBehaviours.RegistroAgent.get("pepe")
      %PocBehaviours.Tramitacion{email: "aa@ee.es", nombre: "pepe"}
  """
  def get(nombre) do
    Agent.get(__MODULE__, &Map.get(&1, nombre))
  end

  @doc """
  Almacena el trámite
      ##Ejemplo
      iex>PocBehaviours.RegistroAgent.start_link([])
      iex>tramite = %PocBehaviours.Tramitacion{nombre: "pepe", email: "aa@ee.es"}
      iex>PocBehaviours.RegistroAgent.put(tramite)
      :ok
  """
  def put(tramite) do
    Agent.update(__MODULE__, &Map.put(&1, tramite.nombre, tramite))
  end
end
