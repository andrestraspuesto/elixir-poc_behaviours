defmodule PocBehaviours.VentanillaServerTest do
  use ExUnit.Case
  doctest PocBehaviours.VentanillaServer

  defmodule GestorReglasStub  do
    use GenStateMachine

    def start_link() do
      GenStateMachine.start_link(__MODULE__, {:iniciado, %{}})
    end

    def start_link(estado) when is_atom(estado) do
      GenStateMachine.start_link(__MODULE__, {estado, %{}})
    end

    def cumplimentar(pid_sm), do: :ok
    def solicitar(pid_sm), do: :ok
    def renunciar(pid_sm), do: :ok
    def ver_estado(pid_sm), do: :iniciado
  end


  alias PocBehaviours.VentanillaServer



  test "cumplimenta correctamente" do
    {:ok, pid} = VentanillaServer.start_link("prueba", %{gestor_reglas: GestorReglasStub})
    assert pid != nil
    {:ok, msg} = VentanillaServer.cumplimentar(pid, "correo@co.es")
    assert msg == "Cumplimentado Email: correo@co.es"
  end

  test "solicita correctamente" do
    {:ok, pid} = VentanillaServer.start_link("prueba", %{gestor_reglas: GestorReglasStub})
    assert VentanillaServer.solicitar(pid) == {:ok, "solicitado"}
  end

  test "detiene correctamente" do
    {:ok, pid} = VentanillaServer.start_link("prueba", %{gestor_reglas: GestorReglasStub})
    assert VentanillaServer.detener(pid) == :ok
  end



end
