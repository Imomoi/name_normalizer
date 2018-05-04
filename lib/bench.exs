pattern = fn ->
  Name.NormalizerPattern.normalize_last_name("Аввакумов")
  Name.NormalizerPattern.normalize_last_name("РАНЕВСКАЯ")
  Name.NormalizerPattern.normalize_last_name("Грицюк")
  Name.NormalizerPattern.normalize_last_name("Грицук")
  Name.NormalizerPattern.normalize_last_name("Грецук")
  Name.NormalizerPattern.normalize_last_name("Аввакумов")
  Name.NormalizerPattern.normalize_last_name("Авакумов")
  Name.NormalizerPattern.normalize_last_name("Ивлиев")
  Name.NormalizerPattern.normalize_last_name("Ивлев")
end

regex = fn ->
  Name.Normalizer.normalize_last_name("Аввакумов")
  Name.Normalizer.normalize_last_name("РАНЕВСКАЯ")
  Name.Normalizer.normalize_last_name("Грицюк")
  Name.Normalizer.normalize_last_name("Грицук")
  Name.Normalizer.normalize_last_name("Грецук")
  Name.Normalizer.normalize_last_name("Аввакумов")
  Name.Normalizer.normalize_last_name("Авакумов")
  Name.Normalizer.normalize_last_name("Ивлиев")
  Name.Normalizer.normalize_last_name("Ивлев")
end

Benchee.run(
  %{
    "pattern" => fn -> pattern.() end,
    "regexp" => fn -> regex.() end
  },
  time: 10
)
