defmodule Name.Normalizer.Vowels do
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