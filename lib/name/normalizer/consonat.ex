defmodule Name.Normalizer.Consonat do
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