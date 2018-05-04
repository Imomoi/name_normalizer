defmodule Name.Normalizer do
  defmodule ReplacementProcessor do
    def process(result, []), do: result

    def process(result, [h | t]),
      do: result |> String.replace(h.pattern, h.replace_with) |> process(t)
  end

  defmodule Endings do
    @patterns [
      %{pattern: ~r/ЕВСКАЯ$/u, replace_with: "&"},
      %{pattern: ~r/ОВСКАЯ$/u, replace_with: "$"},
      %{pattern: ~r/ЕВСКИЙ$/u, replace_with: "#"},
      %{pattern: ~r/ОВСКИЙ$/u, replace_with: "!"},
      # ЕВА, ОВА, ИЕВА, ЕЕВА
      %{pattern: ~r/(ОВ|ЕВ|ИЕВ|ЕЕВ)А$/u, replace_with: "9"},
      %{pattern: ~r/(ОВ|ЕВ|ИЕВ|ЕЕВ)$/u, replace_with: "4"},
      %{pattern: ~r/ИНА$/u, replace_with: "1"},
      %{pattern: ~r/НКО$/u, replace_with: "3"},
      %{pattern: ~r/ИН$/u, replace_with: "8"},
      %{pattern: ~r/[ЫИ]Й$/u, replace_with: "7"},
      %{pattern: ~r/АЯ$/u, replace_with: "6"},
      %{pattern: ~r/[ЫИ]Х$/u, replace_with: "5"},
      # УК, ЮК
      %{pattern: ~r/УК|ЮК$/u, replace_with: "0"},
      %{pattern: ~r/[ИЕ]К$/u, replace_with: "2"}
    ]

    def patterns do
      @patterns
    end
  end

  defmodule Doubles do
    @patterns [
      %{pattern: ~r/([A-ZА-Я])\1+/u, replace_with: "\\1"}
    ]

    def patterns do
      @patterns
    end
  end

  defmodule Vowels do
    @patterns [
      %{pattern: ~r/ЙО|ЙЕ|ИО|ИЕ/u, replace_with: "И"},
      %{pattern: ~r/Е|Ё|Э|И/u, replace_with: "И"},
      %{pattern: ~r/О|Ы|А|Я/u, replace_with: "А"},
      %{pattern: ~r/Ю|У/u, replace_with: "У"}
    ]

    def patterns do
      @patterns
    end
  end

  defmodule Consonat do
    @letters "Б|П|В|Ф|Г|К|Д|Т|Ж|Ш|З|С|Л|М|Н|Р|Й|Х|Ц|Ч"

    @patterns [
      %{pattern: ~r/Б+(#{@letters}|$)/u, replace_with: "П\\1"},
      %{pattern: ~r/З+(#{@letters}|$)/u, replace_with: "С\\1"},
      %{pattern: ~r/Д+(#{@letters}|$)/u, replace_with: "Т\\1"},
      %{pattern: ~r/В+(#{@letters}|$)/u, replace_with: "Ф\\1"},
      %{pattern: ~r/Г+(#{@letters}|$)/u, replace_with: "К\\1"}
    ]

    def patterns do
      @patterns
    end
  end

  defmodule IgnoredSymbols do
    @patterns [
      %{pattern: ~r/[^ОЕАИУЭЮЯПСТРКЛМНБВГДЖЗЙФХЦЧШЩЁЫ]/u, replace_with: ""}
    ]

    def patterns do
      @patterns
    end
  end

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
