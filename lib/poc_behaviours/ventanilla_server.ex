defmodule PocBehaviours.VentanillaServer do
  use GenServer
  @moduledoc """
  Ejemplo de uso del behaviour GenServer.
  En este caso la funcionalidad de este proceso
  consiste en atender las peticiones de una
  tramitación electrónica.
  """
  alias PocBehaviours.Tramitacion

  @arbitro PocBehaviours.GestorReglas


  @doc """
  Inicia un proceso y asigna el nombre en el estado
  """
  def start_link(nombre, opts \\ %{}) do
    gestor_reglas = opts[:gestor_reglas] || @arbitro
    solicitado_handler = opts[:solicitado_handler] || fn (a) -> a end
    {:ok, pid_reglas} = gestor_reglas.start_link()
    tramite = %Tramitacion{nombre: nombre}
    estado = %{
      pid_reglas: pid_reglas,
      gestor_reglas: gestor_reglas,
      solicitado_handler: solicitado_handler,
      tramite: tramite
    }
    GenServer.start_link(__MODULE__, estado)
  end

  #API

  @doc """
  Añade el email a la información de  la tramitación
  """
  def cumplimentar(pid, email) do
    GenServer.call(pid, {:cumplimentar, email})
  end

  @doc """
  pasa a estado solicitar
  """
  def solicitar(pid) do
    GenServer.call(pid, {:solicitar})
  end

  @doc """
  Renuncia al trámite
  """
  def renunciar(pid) do
    GenServer.call(pid, {:renunciar})
  end

  @doc """
  Detiene el proceso
  """
  def detener(pid) do
    GenServer.cast(pid, :stop)
  end

  #Callbacks

  def handle_call({:cumplimentar, email}, _from, estado_tramite) do
    case validar_accion(estado_tramite, :cumplimentar) do
      :ok ->
        tramite = %Tramitacion{estado_tramite.tramite | email: email}
        nuevo_estado = Map.replace(estado_tramite, :tramite, tramite)
        {:reply, {:ok, "Cumplimentado Email: #{email}"}, nuevo_estado}
      _ ->
        {:reply, {:ok, "no se pudo cumplimentar"}, estado_tramite}
    end

  end

  def handle_call({:solicitar}, _from, estado_tramite) do
    case validar_accion(estado_tramite, :solicitar) do
      :ok ->
        #RegistroAgent.put(estado_tramite.tramite)
        estado_tramite.solicitado_handler.(estado_tramite.tramite)
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

  def handle_cast(:stop, estado_tramite) do
    {:stop, :normal, estado_tramite}
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
