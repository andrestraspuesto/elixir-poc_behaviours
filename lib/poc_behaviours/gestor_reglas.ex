defmodule PocBehaviours.GestorReglas do
  use GenStateMachine, callback_mode: :state_functions

  @moduledoc """
  Modulo encargado de gestionar las reglas de la
  tramitación.
  Existen 3 estados y el orden en que se debe transitar
  entre ellos es:
  1. Iniciado
  2. Cumplimentado
  3. Solicitado
  Además cabe la posibilidad de renunciar, que puede
  hacerse en cualquier momento

  """

  #API Cliente

  @doc """
  Inicia un proceso GestorReglas en estado iniciado
  ##Ejemplo:
      iex>{:ok, pid} = PocBehaviours.GestorReglas.start_link()
      iex>PocBehaviours.GestorReglas.ver_estado(pid)
      :iniciado
  """
  def start_link() do
    GenStateMachine.start_link(__MODULE__, {:iniciado, %{}})
  end

  @doc """
  Inicia un proceso GestorReglas en estado distinto a iniciado
  ##Ejemplo:
      iex>{:ok, pid} = PocBehaviours.GestorReglas.start_link(:cumplimentado)
      iex>PocBehaviours.GestorReglas.ver_estado(pid)
      :cumplimentado
  """
  def start_link(estado) when is_atom(estado) do
    GenStateMachine.start_link(__MODULE__, {estado, %{}})
  end

  @doc """
  Cambia al estado cumplimentado si está en estado iniciado
  o cumplimentado
  ##Ejemplo:
      iex>{:ok, pid} = PocBehaviours.GestorReglas.start_link()
      iex>PocBehaviours.GestorReglas.cumplimentar(pid)
      :ok
      iex>PocBehaviours.GestorReglas.ver_estado(pid)
      :cumplimentado
      iex>PocBehaviours.GestorReglas.cumplimentar(pid)
      :ok
      iex>PocBehaviours.GestorReglas.ver_estado(pid)
      :cumplimentado
      iex>{:ok, pid} = PocBehaviours.GestorReglas.start_link(:solicitado)
      iex>PocBehaviours.GestorReglas.cumplimentar(pid)
      :error
  """
  def cumplimentar(pid_sm) do
    IO.puts("cumplimentar #{inspect pid_sm}")
    GenStateMachine.call(pid_sm, :cumplimentar)
  end

  @doc """
  Cambia al estado solicitado si está en estado cumplimentado
  ##Ejemplo:
      iex>{:ok, pid} = PocBehaviours.GestorReglas.start_link(:cumplimentado)
      iex>PocBehaviours.GestorReglas.solicitar(pid)
      :ok
      iex>PocBehaviours.GestorReglas.ver_estado(pid)
      :solicitado
      iex>PocBehaviours.GestorReglas.solicitar(pid)
      :error
      iex>PocBehaviours.GestorReglas.ver_estado(pid)
      :solicitado
      iex>{:ok, pid} = PocBehaviours.GestorReglas.start_link()
      iex>PocBehaviours.GestorReglas.solicitar(pid)
      :error
  """
  def solicitar(pid_sm) do
    GenStateMachine.call(pid_sm, :solicitar)
  end

  @doc """
  Cambia al estado renunciado desde cualquier estado
  excepto si ya está renunciado
  ##Ejemplo:
      iex>{:ok, pid} = PocBehaviours.GestorReglas.start_link(:cumplimentado)
      iex>PocBehaviours.GestorReglas.renunciar(pid)
      :ok
      iex>PocBehaviours.GestorReglas.ver_estado(pid)
      :renunciado
      iex>{:ok, pid} = PocBehaviours.GestorReglas.start_link(:solicitado)
      iex>PocBehaviours.GestorReglas.renunciar(pid)
      :ok
      iex>PocBehaviours.GestorReglas.ver_estado(pid)
      :renunciado
      iex>PocBehaviours.GestorReglas.renunciar(pid)
      :error
      iex>PocBehaviours.GestorReglas.ver_estado(pid)
      :renunciado

  """
  def renunciar(pid_sm) do
    GenStateMachine.call(pid_sm, :renunciar)
  end

  @doc """
  Devuelve el estado en que se encuentra el trámite
  ##Ejemplo:
      iex>{:ok, pid} = PocBehaviours.GestorReglas.start_link(:cumplimentado)
      iex>PocBehaviours.GestorReglas.ver_estado(pid)
      :cumplimentado
  """
  def ver_estado(pid_sm) do
    GenStateMachine.call(pid_sm, :ver_estado)
  end

  #Callbacks

  #reglas en estado iniciado

  def iniciado({:call, from}, :cumplimentar, estado) do
    {:next_state, :cumplimentado, estado, {:reply, from, :ok}}
  end

  def iniciado({:call, from}, :renunciar, estado) do
    {:next_state, :renunciado, estado, {:reply, from, :ok}}
  end

  def iniciado({:call, from}, :ver_estado, _estado) do
    {:keep_state_and_data, {:reply, from, :iniciado}}
  end

  def iniciado({:call, from}, _, _estado) do
    {:keep_state_and_data, {:reply, from, :error}}
  end

  #reglas en estado cumplimentado

  def cumplimentado({:call, from}, :cumplimentar, _estado) do
    {:keep_state_and_data, {:reply, from, :ok}}
  end

  def cumplimentado({:call, from}, :solicitar, estado) do
    {:next_state, :solicitado, estado, {:reply, from, :ok}}
  end

  def cumplimentado({:call, from}, :renunciar, estado) do
    {:next_state, :renunciado, estado, {:reply, from, :ok}}
  end

  def cumplimentado({:call, from}, :ver_estado, _estado) do
    {:keep_state_and_data, {:reply, from, :cumplimentado}}
  end

  def cumplimentado({:call, from}, _, _estado) do
    {:keep_state_and_data, {:reply, from, :error}}
  end

  #reglas en estado solicitado

  def solicitado({:call, from}, :renunciar, estado) do
    {:next_state, :renunciado, estado, {:reply, from, :ok}}
  end

  def solicitado({:call, from}, :ver_estado, _estado) do
    {:keep_state_and_data, {:reply, from, :solicitado}}
  end

  def solicitado({:call, from}, _, _estado) do
    {:keep_state_and_data, {:reply, from, :error}}
  end

  #reglas en estado renunciado

  def renunciado({:call, from}, :ver_estado, _estado) do
    {:keep_state_and_data, {:reply, from, :renunciado}}
  end

  def renunciado({:call, from}, _, _estado) do
    {:keep_state_and_data, {:reply, from, :error}}
  end

end
