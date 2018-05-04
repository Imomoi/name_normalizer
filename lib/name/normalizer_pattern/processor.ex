defmodule Name.NormalizerPattern.Processor do
  # @doc """
  # Буквы, которые следуют за звонкими согласными из массива `@consonats` и "оглушают" их
  # """
  @letters String.graphemes("ПФКТЖШСЛМНРЙХЦЧ")

  # @doc """
  # Подстановки для звонких согласных

  # ## Структура массива
  
  # ["звонкая согласная", "замена"]
  # """
  @consonats [["Б", "П"], ["З", "С"], ["Д", "Т"], ["В", "Ф"], ["Г","К"]]

  # @doc """
  # Правила замены двойных гласных на соответствующие глухие согласные

  # Структура записи:
  # * `pattern` - шаблон 
  # * `replace_with` - замена
  # """
  @vowels [
    %{pattern: ["ЙО", "ЙЕ", "ИО", "ИЕ"], replace_with: "И"},
    %{pattern: ["Е", "Ё", "Э", "И"], replace_with: "И"},
    %{pattern: ["О", "Ы", "А", "Я"], replace_with: "А"},
    %{pattern: ["Ю", "У"], replace_with: "У"}
  ]

  # @doc """
  # Правила замены фамильных окончаний
  # """
  @endings [
    %{pattern: ["ЕВСКАЯ"], replace_with: "&"},
    %{pattern: ["ОВСКАЯ"], replace_with: "$"},
    %{pattern: ["ЕВСКИЙ"], replace_with: "#"},
    %{pattern: ["ОВСКИЙ"], replace_with: "!"},
    %{pattern: ["ИЕВА","ЕЕВА","ОВА","ЕВА"], replace_with: "9"},
    %{pattern: ["ИЕВ","ЕЕВ", "ОВ","ЕВ"], replace_with: "4"},
    %{pattern: ["ИНА"], replace_with: "1"},
    %{pattern: ["НКО"], replace_with: "3"},
    %{pattern: ["ИН"], replace_with: "8"},
    %{pattern: ["ЫЙ", "ИЙ"], replace_with: "7"},
    %{pattern: ["АЯ"], replace_with: "6"},
    %{pattern: ["ЫХ", "ИХ"], replace_with: "5"},
    %{pattern: ["УК", "ЮК"], replace_with: "0"},
    %{pattern: ["ИК", "ЕК"], replace_with: "2"}
  ]

  # @doc """
  # Все остальные буквы, которые должны остаться после всех действий, по замене
  # """
  @other_letters String.graphemes("ПСТРКЛМНБВГДЖЗЙФХЦЧШЩ")

  @doc """
  Преобразует имя в соответствующую фонетическую форму
  """
  def process(name) do
    compact(name, "", :name)
  end

  @doc """
  Преобразует фамилия в соответствующую фонетическую форму
  """
  def process_last_name(name) do
    compact(name, "", :last_name)
  end

  @doc """
  Производит преобразования текста

  Описание функции: `compact(name, result, method)`

  - `name` - строка, подлежащая обработке
  - `result` - аккумулятор результата
  - `method` - способ обработки запроса. Может принимать значения:
  -- `:last_name` - строка будет обработана с учетом фамильных окончаний
  -- `:name` - строка будет обработана без учета фамильных окончаний

  ## Примеры

      iex> Name.NormalizerPattern.Processor.compact("ЕВСКАЯ", "А", :last_name)
      "А&"
  """
  # Завершающий паттерн. Возвращает результат вычислений.
  def compact("", acc, _), do: acc
  # Удаляет все дубликаты букв.
  def compact(<<c::utf8, c::utf8, tail::binary>>, acc, with_endings) do
    compact(<<c::utf8>> <> tail, acc, with_endings)
  end
  # Формирует функции для обработки фамильных окончаний
  for %{pattern: endings, replace_with: replacement} <- @endings do
    for ending <- endings do
      # Пример:
      #
      # def compact("ЕВСКАЯ", acc, :last_name) do
      #   acc <> "&"
      # end
      def compact(unquote(ending), acc, :last_name) do
        acc <> unquote(replacement)
      end
    end
  end

  # Формирует фукнции для замены звонких согласных на глухие
  # consonat - звонкая согласная
  # replacement - глухая
  for [consonat, replacement] <- @consonats do
    # Обрабатываем случай, когда за звонкой сразу идет замещающая её глухая
    # Добавляем замещающую букву в начало строки, подлежащей обработке, чтобы при необходимости были удалены, получившиеся дубликаты
    # 
    # Пример:
    #
    # def compact("БП" <> tail, acc, with_endings) do
    #   compact("П" <> tail, acc, with_endings)
    # end
    def compact(unquote(consonat <> replacement) <> tail, acc, with_endings) do
      compact(unquote(replacement) <> tail, acc, with_endings)
    end

    # Формируем функции для случаев, когда за звонкой идут другие буквы "оглушающие" её
    for next_letter <- @letters do
      if (next_letter != consonat) && (next_letter != replacement) do
        def compact(unquote(consonat <> next_letter) <> tail, acc, with_endings) do
          compact(tail, acc <> unquote(replacement <> next_letter), with_endings)
        end
      end
    end

    for [next_letter, next_letter_replacement] <- @consonats do
      if (next_letter != consonat) do
        def compact(unquote(consonat <> next_letter) <> tail, acc, with_endings) do
          compact(tail, acc <> unquote(replacement <> next_letter_replacement), with_endings)
        end
      end
    end

    def compact(unquote(consonat <> replacement), acc, _) do
      acc <> unquote(replacement)
    end
    def compact(unquote(consonat), acc, _) do
      acc <> unquote(replacement)
    end
  end

  # Замена составных гласных
  for %{pattern: patterns, replace_with: replace_with} <- @vowels do
    for pattern <- patterns do
      def compact(unquote(pattern) <> tail, acc, with_endings) do
        compact(tail, acc <> unquote(replace_with), with_endings)
      end
    end
  end

  # Оставляем все остальные нужные буквы
  for pattern <- @other_letters do
    def compact(unquote(pattern) <> t, acc, with_endings) do
      compact(t, acc <> unquote(pattern), with_endings)
    end
  end

  def compact(<<_::utf8, tail::binary>>, acc, with_endings), do: compact(tail, acc, with_endings)
end