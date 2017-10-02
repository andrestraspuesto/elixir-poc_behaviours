defmodule PocBehaviours.GestorReglasTest do
  use ExUnit.Case
  alias PocBehaviours.GestorReglas
  doctest PocBehaviours.GestorReglas

    describe "En estado iniciado" do

      test "se puede cumplimentar" do
        {:ok, pid} = GestorReglas.start_link
        assert :ok == GestorReglas.cumplimentar(pid)
      end

      test "se puede renunciar" do
        {:ok, pid} = GestorReglas.start_link
        assert :ok == GestorReglas.renunciar(pid)
      end

      test "el estado es iniciado" do
        {:ok, pid} = GestorReglas.start_link
        assert :iniciado == GestorReglas.ver_estado(pid)
      end

      test "no se puede solicitar" do
        {:ok, pid} = GestorReglas.start_link
        assert :error == GestorReglas.solicitar(pid)
      end
    end

    describe "En estado cumplimentado" do

      test "se puede cumplimentar" do
        {:ok, pid} = GestorReglas.start_link(:cumplimentado)
        assert :ok == GestorReglas.cumplimentar(pid)
      end

      test "se puede renunciar" do
        {:ok, pid} = GestorReglas.start_link(:cumplimentado)
        assert :ok == GestorReglas.renunciar(pid)
      end

      test "el estado es cumplimentado" do
        {:ok, pid} = GestorReglas.start_link(:cumplimentado)
        assert :cumplimentado == GestorReglas.ver_estado(pid)
      end

      test "se puede solicitar" do
        {:ok, pid} = GestorReglas.start_link(:cumplimentado)
        assert :ok == GestorReglas.solicitar(pid)
      end
    end

    describe "En estado solicitado" do

      test "no se puede cumplimentar" do
        {:ok, pid} = GestorReglas.start_link(:solicitado)
        assert :error == GestorReglas.cumplimentar(pid)
      end

      test "se puede renunciar" do
        {:ok, pid} = GestorReglas.start_link(:solicitado)
        assert :ok == GestorReglas.renunciar(pid)
      end

      test "el estado es solicitado" do
        {:ok, pid} = GestorReglas.start_link(:solicitado)
        assert :solicitado == GestorReglas.ver_estado(pid)
      end

      test "no se puede solicitar" do
        {:ok, pid} = GestorReglas.start_link(:solicitado)
        assert :error == GestorReglas.solicitar(pid)
      end
    end

    describe "En estado renunciado" do

      test "no se puede cumplimentar" do
        {:ok, pid} = GestorReglas.start_link(:renunciado)
        assert :error == GestorReglas.cumplimentar(pid)
      end

      test "no se puede renunciar" do
        {:ok, pid} = GestorReglas.start_link(:renunciado)
        assert :error == GestorReglas.renunciar(pid)
      end

      test "el estado es renunciado" do
        {:ok, pid} = GestorReglas.start_link(:renunciado)
        assert :renunciado == GestorReglas.ver_estado(pid)
      end

      test "no se puede solicitar" do
        {:ok, pid} = GestorReglas.start_link(:renunciado)
        assert :error == GestorReglas.solicitar(pid)
      end
    end

end
