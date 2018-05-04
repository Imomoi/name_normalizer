defmodule Name.NormalizerPattern do
  alias Name.NormalizerPattern.Processor, as: Processor

   @doc """
      iex> Name.NormalizerPattern.normalize("Бауэр")
      "БАУИР"

      iex> Name.NormalizerPattern.normalize("Зицер")
      "ЗИЦИР"

      iex> Name.NormalizerPattern.normalize("Смирнофф")
      "СМИРНАФ"
      
      iex> Name.NormalizerPattern.normalize("Смирновфф")
      "СМИРНАФ"
      
      iex> Name.NormalizerPattern.normalize("Смирнов") 
      "СМИРНАФ"

      iex> Name.NormalizerPattern.normalize("Смиррррнннновфф")
      "СМИРНАФ"
      
      iex> Name.NormalizerPattern.normalize("Смиррррнннноооовфф")
      "СМИРНАФ"
      
      iex> Name.NormalizerPattern.normalize("Смиииииррррнннноооовфф")
      "СМИРНАФ"
      
      iex> Name.NormalizerPattern.normalize("Ссссссммммммиииииррррнннноооовфф")
      "СМИРНАФ"

      iex> Name.NormalizerPattern.normalize("Гудз") == Name.NormalizerPattern.normalize("Гутс")
      true

      iex> Name.NormalizerPattern.normalize("Гудз")
      "ГУТС"

      iex> Name.NormalizerPattern.normalize("Матревелли") == Name.NormalizerPattern.normalize("Матревели")
      true

      iex> Name.NormalizerPattern.normalize("Шмидт") == Name.NormalizerPattern.normalize("Шмит")
      true

      iex> Name.NormalizerPattern.normalize("Емец") == Name.NormalizerPattern.normalize("Йемец")
      true

      iex> Name.NormalizerPattern.normalize("Пиотух") == Name.NormalizerPattern.normalize("Петух")
      true

      iex> Name.NormalizerPattern.normalize("Иозеп") == Name.NormalizerPattern.normalize("Ёзеп")
      true
  """
  def normalize(name) do
    name
      |> String.upcase
      |> Processor.process
  end


  @doc """
      iex> Name.NormalizerPattern.normalize_last_name("Молоков")
      "МАЛАК4"

      iex> Name.NormalizerPattern.normalize_last_name("Леонтьев")
      "ЛИАНТ4"

      iex> Name.NormalizerPattern.normalize_last_name("Леонтьев") == Name.NormalizerPattern.normalize_last_name("Леоньтев")
      true

      iex> Name.NormalizerPattern.normalize_last_name("Аввакумов")
      "АВАКУМ4"

      iex> Name.NormalizerPattern.normalize_last_name("Авакумов")
      "АВАКУМ4"

      iex> Name.NormalizerPattern.normalize_last_name("РАНЕВСКАЯ")
      "РАН&"

      iex> Name.NormalizerPattern.normalize_last_name("Грицюк")
      "КРИЦ0"

      iex> Name.NormalizerPattern.normalize_last_name("Грицук")
      "КРИЦ0"

      iex> Name.NormalizerPattern.normalize_last_name("Грецук")
      "КРИЦ0"

      iex> Name.NormalizerPattern.normalize_last_name("Аввакумов") == Name.NormalizerPattern.normalize_last_name("Авакумов")
      true

      iex> Name.NormalizerPattern.normalize_last_name("Ивлиев") == Name.NormalizerPattern.normalize_last_name("Ивлев")
      true
  """
  def normalize_last_name(name) do
    name
      |> String.upcase
      |> Processor.process_last_name
  end

end
