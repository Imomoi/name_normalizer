defmodule Name.Normalizer do
  alias Name.Normalizer.ReplacementProcessor, as: ReplacementProcessor
  alias Name.Normalizer.Endings, as: Endings
  alias Name.Normalizer.Doubles, as: Doubles
  alias Name.Normalizer.Vowels, as: Vowels
  alias Name.Normalizer.Consonat, as: Consonat
  alias Name.Normalizer.IgnoredSymbols, as: IgnoredSymbols

  @doc """
      iex> Name.Normalizer.normalize("Бауэр")
      "БАУИР"

      iex> Name.Normalizer.normalize("Зицер")
      "ЗИЦИР"

      iex> Name.Normalizer.normalize_last_name("Молоков")
      "МАЛАК4"

      iex> Name.Normalizer.normalize_last_name("Леонтьев")
      "ЛИАНТ4"

      iex> Name.Normalizer.normalize_last_name("Леонтьев") == Name.Normalizer.normalize_last_name("Леоньтев")
      true

      iex> Name.Normalizer.normalize("Гудз") == Name.Normalizer.normalize("Гутс")
      true

      iex> Name.Normalizer.normalize("Матревелли") == Name.Normalizer.normalize("Матревели")
      true

      iex> Name.Normalizer.normalize("Шмидт") == Name.Normalizer.normalize("Шмит")
      true

      iex> Name.Normalizer.normalize("Емец") == Name.Normalizer.normalize("Йемец")
      true

      iex> Name.Normalizer.normalize("Пиотух") == Name.Normalizer.normalize("Петух")
      true

      iex> Name.Normalizer.normalize("Иозеп") == Name.Normalizer.normalize("Ёзеп")
      true
  """
  def normalize(name) do
    name
    |> String.upcase()
    |> ReplacementProcessor.process(IgnoredSymbols.patterns())
    |> normalize_impl
  end

  @doc """
      iex> Name.Normalizer.normalize_last_name("Аввакумов")
      "АВАКУМ4"

      iex> Name.Normalizer.normalize_last_name("РАНЕВСКАЯ")
      "РАН&"

      iex> Name.Normalizer.normalize_last_name("Грицюк")
      "КРИЦ0"

      iex> Name.Normalizer.normalize_last_name("Грицук")
      "КРИЦ0"

      iex> Name.Normalizer.normalize_last_name("Грецук")
      "КРИЦ0"

      iex> Name.Normalizer.normalize_last_name("Аввакумов") == Name.Normalizer.normalize_last_name("Авакумов")
      true

      iex> Name.Normalizer.normalize_last_name("Ивлиев") == Name.Normalizer.normalize_last_name("Ивлев")
      true
  """
  def normalize_last_name(name) do
    name
    |> String.upcase()
    |> ReplacementProcessor.process(IgnoredSymbols.patterns())
    |> ReplacementProcessor.process(Endings.patterns())
    |> normalize_impl
  end

  defp normalize_impl(name) do
    name
    |> ReplacementProcessor.process(Doubles.patterns())
    |> ReplacementProcessor.process(Vowels.patterns())
    |> ReplacementProcessor.process(Consonat.patterns())
    |> ReplacementProcessor.process(Doubles.patterns())
  end
end
