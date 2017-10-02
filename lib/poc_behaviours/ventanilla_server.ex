defmodule PocBehaviours.VentanillaServer do
  use GenServer
  @moduledoc """
  Ejemplo de uso del behaviour GenServer.
  En este caso la funcionalidad de este proceso
  consiste en atender las peticiones de una
  tramitación electrónica.
  """
  defmodule Tramitacion do
    defstruct [pid_reglas: nil, gestor_reglas: nil, nombre: nil, email: nil]
  end

  @arbitro PocBehaviours.GestorReglas

  def start_link(nombre, opts \\ []) do
    gestor_reglas = opts[:gestorReglas] || @arbitro
    {:ok, pid_reglas} = gestor_reglas.start_link()
    tramite = %Tramitacion{pid_reglas: pid_reglas, gestor_reglas: gestor_reglas, nombre: nombre}
    GenServer.start_link(__MODULE__, tramite)
  end

  #API


  def cumplimentar(pid, email) do
    GenServer.call(pid, {:cumplimentar, email})
  end

  def solicitar(pid) do
    GenServer.call(pid, {:solicitar})
  end

  def renunciar(pid) do
    GenServer.call(pid, {:renunciar})
  end

  #Callbacks

  def handle_call({:cumplimentar, email}, _from, estado_tramite) do
    case validar_accion(estado_tramite, :cumplimentar) do
      :ok ->
        nuevo_estado = %Tramitacion{estado_tramite | email: email}
        {:reply, {:ok, "Cumplimentado Email: #{email}"}, nuevo_estado}
      _ ->
        {:reply, {:ok, "no se pudo cumplimentar"}, estado_tramite}
    end

  end

  def handle_call({:solicitar}, _from, estado_tramite) do
    case validar_accion(estado_tramite, :solicitar) do
      :ok ->
        {:reply, {:ok, "solicitado"}, estado_tramite}
        _ ->
          {:reply, {:ok, "no se pudo solicitar"}, estado_tramite}
    end

  end

  def handle_call({:renunciar}, _from, estado_tramite) do
    case validar_accion(estado_tramite, :renunciar) do
      :ok ->
        {:reply, {:ok, "renuncitado"}, estado_tramite}
        _ ->
          {:reply, {:ok, "no se pudo renunciar"}, estado_tramite}
    end
  end

  def handle_info(_, state) do
    {:reply, {:info, "acción no soportada"}, state}
  end

  defp validar_accion(estado_tramite, accion) when is_atom(accion) do
    pid_reglas = estado_tramite.pid_reglas
    gestor_reglas = estado_tramite.gestor_reglas
    case accion do
      :cumplimentar ->
        gestor_reglas.cumplimentar(pid_reglas)
      :solicitar ->
        gestor_reglas.solicitar(pid_reglas)
      :renunciar ->
        gestor_reglas.renunciar(pid_reglas)
    end
  end

end
