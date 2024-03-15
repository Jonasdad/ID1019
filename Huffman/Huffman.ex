
defmodule Huffman do

  def bench() do
    sample = read("C:/Users/Dader/Downloads/sample-2mb-text-file.txt")
    tree = tree(sample)
    coding_table = encode_table(tree)
    seq = encode(sample, coding_table)

    encode_length = length(sample)
    decode_length = length(seq)
   # decode(seq, coding_table)

    time_encode = :timer.tc(
      fn -> encode(sample, coding_table)
      :ok
    end
    )

    time_decode = :timer.tc(
      fn -> decode(seq, coding_table)
      :ok
  end
    )
    IO.puts("Number of characters: #{encode_length}")
    IO.puts("Encode Time: #{elem(time_encode, 0) / 1000000}")
    IO.puts("Decode Time: #{elem(time_decode, 0) / 1000000}")
    IO.puts("Bits to encode: #{encode_length*8}")
    IO.puts("Bits after encoding: #{decode_length}")
    IO.puts("Ratio: #{1 - (decode_length/(encode_length*8))}")

  end

  # Simple function to read contents of a file into a string
  def read(file) do
    {:ok, file} = File.open(file, [:read, :utf8])
    binary = IO.read(file, :all)
    File.close(file)
    case :unicode.characters_to_list(binary, :utf8) do
      {:incomplete, list, _} -> list
      list -> list
    end
  end


  def tree(sample) do
    freqList = freq(sample)
    huffman_tree(freqList |> List.keysort(1))
  end

  # Två metoder: huffman_tree och insert
  # huffman tree bygger trädet
  # build sätter rätt löv och noder på rätt plats
  def huffman_tree([]) do [] end
  def huffman_tree([{tree, _}]) do
    tree
  end

  def huffman_tree([{char1, freq1}, {char2, freq2} | t]) do
    huffman_tree(build({{char1, char2}, freq1 + freq2}, t))
  end

  # basecase
  def build({char, freq}, []) do
    [{char, freq}]
  end

  # build the tree bottom - up. More frequent characters put higher up.
  # ádding frequencies of low frequent characters should equal node to the left.
  def build({char1, freq1}, [{char2, freq2} | t]) do
    if(freq1 < freq2) do
      [{char1, freq1}, {char2, freq2} | t]
    else
      [{char2, freq2} | build({char1, freq1}, t)]
    end
  end

  # Initiates compression
  def encode_table(tree) do
    compress(tree, [])
  end

  # Initiates compress/2 with an empty list to generate sequence
  # Create code for each character BACKWARDS
  def compress({left, right}, sequence) do
    left_seq = compress(left, [0 | sequence])
    right_seq = compress(right, [1 | sequence])
    left_seq ++ right_seq
  end

  # Generate the proper code for each character, but re-reverse the code
  # to get the actual code.
  def compress(char, code) do
    [{char, Enum.reverse(code)}]
  end

  # Generates a binary list sequence for each character
  # returns entire string encoded by the huffman tree
  def encode([], _) do
    []
  end
  def encode([ht | tt], etable)do
    code = elem(List.keyfind(etable, ht, 0), 1)
    List.flatten([code | encode(tt, etable)])
  end


  # Decodes a given binary list sequence into characters
  def decode([], _) do
    []
  end
  def decode(seq, table) do
    {char, rest} = decode_char(seq, 1, table)
    [char | decode(rest, table)]
  end

  # Finds each character from a binary sequence
  # starts at length 1 and increases until a match is found
  def decode_char(seq, n, table) do
    {code, rest} = Enum.split(seq, n)

    case List.keyfind(table, code, 1) do
      {char, _} ->
        {char, rest}

      nil ->
        decode_char(seq, n+1, table)
    end
  end

  # Initial call of freq/1 to initiate freq/2 using only the sample text
  def freq(sample) do
    freq(sample, [])
  end

  # End of list -> Return Frequency List
  def freq([], freqList) do
    freqList
  end

  # List iteration -> count frequency while iterating
  # Frenquency is counted in second argument of freq/2 using numberOccurances/2
  def freq([char | rest], freqList) do
    freq(rest, numberOccurances(char, freqList))
  end

  # Same character AGAIN -> increment character frequency
  def numberOccurances(char, [{char, n} | rest]) do
    [{char, n + 1} | rest]
  end

  # Base case - Only char and Empty list -> 1 type of that character
  def numberOccurances(char, []) do
    [{char, 1}]
  end

  # New character -> Keep running algorithm
  # Iterates through freqList => O(n^2) complexity for freq & numberOccurances combined.
  def numberOccurances(char, [diffChar | rest]) do
    [diffChar | numberOccurances(char, rest)]
  end
end
