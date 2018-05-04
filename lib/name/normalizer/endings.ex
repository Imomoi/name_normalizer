defmodule Name.Normalizer.Endings do
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