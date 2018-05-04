defmodule Name.Normalizer.ReplacementProcessor do
  def process(result, []), do: result

  def process(result, [h | t]), do: result |> String.replace(h.pattern, h.replace_with) |> process(t)
end
