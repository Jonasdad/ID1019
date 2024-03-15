defmodule Eager do

  def test() do
    env = EnvTree.new()
    env = EnvTree.add(env, :atm, :a)
    env = EnvTree.add(env, :x, :a)

#    eval_expr({:atm, :a}, env) #{:ok, a}
#    eval_expr({:var, :x}, env) #[{:ok, :a}]
#    eval_expr({:var, :x}, []) #error
#    eval_expr({:cons, {:var, :x}, {:atm, :b}}, env) #{:ok, {:a, :b}}
#Eager.eval_seq(seq, EnvTree.new())

 #eval_match({:atm, :atm}, :b, env) #: returns {:ok, []}
 eval_match({:var, :x}, :a, env) #: returns {:ok, [{:x, :a}]}
 #eval_match({:var, :x}, :a, [{:x, :a}]) #: returns {:ok, [{:x,:a}]}
 #eval_match({:var, :x}, :a, [{:x, :b}]) #: returns :fail
 #eval_match({:cons, {:var, :x}, {:var, :x}}, {:a, :b}, []) #: returns :fail
end

#------------Eval_expr------------#
  def eval_expr({:atm, id}, _) do {:ok, id} end
  def eval_expr({:var, id}, env) do
    case EnvTree.lookup(env, id) do
      nil ->
        IO.puts("Variable not present in environment")
        :error
    {_, str} -> {:ok, str}
    end
  end
    #head- and tail structure
  def eval_expr({:cons, head_expr, tail_expr}, env) do
    case eval_expr(head_expr, env) do
      :error ->
        :error

    {:ok, head_struct} -> case eval_expr(tail_expr, env) do
      :error -> :error
      {:ok, tail_struct} -> {:ok, {head_struct, tail_struct}}
    end
  end
end

  #def eval_expr({:case, ..., ...}, env) do
#end
#------------Eval_match------------#
def eval_match(:ignore, _, env) do
    {:ok, env}
  end

def eval_match({:var, key}, struct, env) do
  case EnvTree.lookup(env, key) do
    nil -> {:ok, Env.add(key, struct, env)}
    {^key, ^struct} -> {:ok, env}
    {_,_} -> :fail
  end
end

def eval_match({:atm, value}, key, env) do
    case EnvTree.lookup(env, key) do
      #Variable not found in environment -> Add it to the environment and return modified environment
      nil -> {:ok, {EnvTree.add(env, key, value)}}

      #Pin (^) operator saves current state of variable and it cannot be reassigned
      #do if match succeeds with found value
      {^value, ^key} -> {:ok, env}
      #Else we fail
      {_, _} -> :fail
    end
  end

  def eval_match({:cons, head_pattern, tail_pattern}, {head_struct, tail_struct}, env) do
    case eval_match(head_pattern, head_struct, env) do
      :fail -> :fail
      {:ok, env} -> eval_match(tail_pattern, tail_struct, env)
    end
  end
  def eval_match(_, _, _) do
    :epicfail
  end
end
