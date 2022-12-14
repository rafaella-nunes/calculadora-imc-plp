defmodule CalculadoraIMC do

  import IO
  import String

  def escolher_sistema() do
    puts "Digite m para sistema métrico"
    puts "Digite i para sistema imperial"
    case read(:stdio, :line) do
      :eof -> :ok #quando termina de ler o arquivo retorna um ok (continue)
      {:error, reason} ->
        IO.inspect reason
        escolher_sistema()
      data ->
        char = data
          |> trim_trailing #remover espaços em branco
          |> downcase #deixar a letra minúscula

        cond do
          char == "i" || char == "m" ->
            puts "Sua escolha: #{char}"
            set_sistema(char)
            |> ask_input
          true ->
            puts "Por favor, escolha entre m ou i !"
            escolher_sistema()
        end
    end
  end

  def calcular(%{system: :metrico, altura: altura, peso: peso}) do
    altura = altura / 100
    (peso / (altura * altura))
  end

  def calcular(%{system: :imperial, altura: altura, peso: peso}) do
    (peso / (altura * altura)) * 703
  end

  def print_resultado(imc) do
    puts "Seu IMC é #{:erlang.float_to_binary(imc, decimals: 2)}" #transformando de float para string
    cond do
      imc <= 18.5 ->
        puts "Você está abaixo do peso."
      18.5 < imc && imc <= 24.9 ->
        puts "Você está com o peso normal."
      24.9 < imc && imc <= 29.9 ->
        puts "Você está com sobrepeso."
      imc > 29.9 ->
        puts "Você está com obesidade."
      true ->
        puts "vish"
    end
  end

  defp ask_input(%{using: :metrico}) do
    params = ask_altura_e_peso :metrico
    Map.put params, :system, :metrico
  end

  defp ask_input(%{using: :imperial}) do
    params = ask_altura_e_peso :imperial
    Map.put params, :system, :metrico
  end

  defp ask_altura_e_peso(type) do
    peso_ = if type == :metrico, do: "(em kg)", else: "(em libras)"
    altura_ = if type == :metrico, do: "(em cm)", else: "(em polegadas)"
    peso = gets("Qual é o seu peso? #{peso_} ")
      |> trim_trailing
      |> Float.parse
    altura = gets("Qual é a sua altura? #{altura_} ")
      |> trim_trailing
      |> Float.parse
    case { peso, altura } do
      { :error, _} ->
        puts "Tente novamente! Esse valor está errado!"
        ask_altura_e_peso type
      { _, :error } ->
        puts "Tente novamente! Esse valor está errado!"
        ask_altura_e_peso type
      { { peso, _ }, { altura, _ } } ->
        %{ altura: altura, peso: peso}
    end
  end

  def set_sistema("m") do
    %{using: :metrico}
  end

  def set_sistema("i") do
    %{using: :imperial}
  end
end

CalculadoraIMC.escolher_sistema
  |> CalculadoraIMC.calcular
  |> CalculadoraIMC.print_resultado
