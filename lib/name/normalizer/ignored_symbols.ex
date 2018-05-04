defmodule Name.Normalizer.IgnoredSymbols do
  @patterns [
    %{pattern: ~r/[^ОЕАИУЭЮЯПСТРКЛМНБВГДЖЗЙФХЦЧШЩЁЫ]/u, replace_with: ""}
  ]

  def patterns do
    @patterns
  end
end