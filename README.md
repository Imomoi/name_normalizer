# Name.Normalizer

Преобразование имен в формат, применимый для фонетического поиска.

Реализовано два алгоритма:

* с использованием регулярных выражений ``Name.Normalizer``
* с использованием pattern matching ``Name.NormalizerPattern``

## Подготовка и выполнение тестов

    mix geps.get
    mix test

## Выполнение сравнительного теста на быстродействие

Для запуска сравнительного теста необходимо выполнить следующую команду:

    mix run lib/bench.exs

Результат выполнения

    Operating System: macOS
    CPU Information: Intel(R) Core(TM) i5-6267U CPU @ 2.90GHz
    Number of Available Cores: 4
    Available memory: 8 GB
    Elixir 1.6.1
    Erlang 20.2.2
    Benchmark suite executing with the following configuration:
    warmup: 2 s
    time: 30 s
    parallel: 1
    inputs: none specified
    Estimated total run time: 1.07 min


    Benchmarking Name.Normalize...
    Benchmarking Name.NormalizerPattern...

    Name                             ips        average  deviation         median         99th %
    Name.NormalizerPattern       78.09 K       12.81 μs   ±614.56%          10 μs          26 μs
    Name.Normalize                2.49 K      402.26 μs     ±9.58%         393 μs         555 μs

    Comparison: 
    Name.NormalizerPattern       78.09 K
    Name.Normalize                2.49 K - 31.41x slower

