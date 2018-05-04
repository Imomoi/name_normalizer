defmodule Name.Normalizer.Doubles do
  @patterns [
    %{pattern: ~r/([A-ZА-Я])\1+/u, replace_with: "\\1"}
  ]

  def patterns do
    @patterns
  end
end