defmodule Morse do
  def morse() do
    {:node, :na, {:node, 116,{:node, 109, {:node, 111, {:node, :na, {:node, 48, nil, nil}, {:node, 57, nil, nil}},
        {:node, :na, nil, {:node, 56, nil, {:node, 58, nil, nil}}}},
       {:node, 103, {:node, 113, nil, nil},
        {:node, 122, {:node, :na, {:node, 44, nil, nil}, nil}, {:node, 55, nil, nil}}}},
      {:node, 110, {:node, 107, {:node, 121, nil, nil}, {:node, 99, nil, nil}},
       {:node, 100, {:node, 120, nil, nil},
        {:node, 98, nil, {:node, 54, {:node, 45, nil, nil}, nil}}}}},
     {:node, 101,
      {:node, 97,
       {:node, 119, {:node, 106, {:node, 49, {:node, 47, nil, nil}, {:node, 61, nil, nil}}, nil},
        {:node, 112, {:node, :na, {:node, 37, nil, nil}, {:node, 64, nil, nil}}, nil}},
       {:node, 114, {:node, :na, nil, {:node, :na, {:node, 46, nil, nil}, nil}},
        {:node, 108, nil, nil}}},
      {:node, 105,
       {:node, 117, {:node, 32, {:node, 50, nil, nil}, {:node, :na, nil, {:node, 63, nil, nil}}},
        {:node, 102, nil, nil}},
       {:node, 115, {:node, 118, {:node, 51, nil, nil}, nil},
        {:node, 104, {:node, 52, nil, nil}, {:node, 53, nil, nil}}}}}}
  end

  def test() do
    map = Map.new()
    list = []
    map = encode_table(map, morse(), list)
    string = 'hej jag heter jonas och gillar programmering'
    seq = encode(string, map)
    #seq1 = '.- .-.. .-.. ..-- -.-- --- ..- .-. ..-- -... .- ... . ..-- .- .-. . ..-- -... . .-.. --- -. --. ..-- - --- ..-- ..- ... '
<<<<<<< HEAD
    #seq2 ='.... - - .--. ... ---... .----- .----- .-- .-- .-- .-.-.- -.-- --- ..- - ..- -... . .-.-.- -.-. --- -- .----- .-- .- - -.-. .... ..--.. ...- .----. -.. .--.-- ..... .---- .-- ....- .-- ----. .--.-- ..... --... --. .--.-- ..... ---.. -.-. .--.-- ..... .---- '
    decode(morse(), seq)
=======
    seq2 ='.... - - .--. ... ---... .----- .----- .-- .-- .-- .-.-.- -.-- --- ..- - ..- -... . .-.-.- -.-. --- -- .----- .-- .- - -.-. .... ..--.. ...- .----. -.. .--.-- ..... .---- .-- ....- .-- ----. .--.-- ..... --... --. .--.-- ..... ---.. -.-. .--.-- ..... .---- '
    decode(decode_tree, seq2)
>>>>>>> 54c3fe5 (asdasd)
  end

  # Decode - Using the binary tree: O(log(n))
  # to find the encoded character
  def decode({:node, char, _left, right}, [?.|t]) do decode(right, t) end
  def decode({:node, char, left, _right}, [?-|t]) do decode(left, t) end
  def decode({:node, _char, _left, _right}, []) do [] end
  def decode({:node, char, _, _}, [32 | t]) do [char | decode(morse(), t)] end


  # Encode: (add_spaces) O(n) * (Map.fetch) O(log(n)) = O(n*log(m))
  # Map.fetch: O(log(n))
  # Then combine the lists: O(1)
  def encode([], _, acc) do IO.inspect("#{acc}");add_spaces(acc) end
  def encode(string, map) do encode(string, map, []) end
  def encode([h|t], map, acc) do
    {_, code} = Map.fetch(map, h)
    encode(t, map, [code|acc])
  end

  # Adds spaces to end of each encoded character.
  # Complexity: O(n)
  def add_spaces(list) do add_spaces(list, []) end
  def add_spaces([], acc) do acc end
  def add_spaces([h|t], acc) do
    IO.inspect("Head: #{h}")
    IO.inspect("Accumulator: #{acc}")
    add_spaces(t, h++[?\s | acc])
  end


  # Encode table: O(log(n)) as we're iterating down a binary tree
  def encode_table(map, {:node, :na, nil, nil}, _list) do map end
  def encode_table(map, {:node, :na, nil, right}, list) do encode_table(map, right, list ++ '.') end
  def encode_table(map, {:node, :na, left, nil}, list) do encode_table(map, left, list ++ '-') end
  def encode_table(map, {:node, :na, left, right}, list) do
    map = encode_table(map, left, list ++ '-')
    encode_table(map, right, list ++ '.')
  end
  def encode_table(map, {:node, char, nil, nil}, list) do
    Map.put(map, char, list)
  end
  def encode_table(map, {:node, char, left, nil}, list) do
    map = Map.put(map, char, list)
    encode_table(map, left, list ++ '-')
  end
  def encode_table(map, {:node, char, nil, right}, list) do
    map = Map.put(map, char, list)
    encode_table(map, right, list ++ '.')
  end
  def encode_table(map, {:node, char, left, right}, list) do
    map = Map.put(map, char, list)
    map = encode_table(map, left, list ++ '-')
    encode_table(map, right, list ++ '.')
  end
end
