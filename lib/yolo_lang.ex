defmodule YoloLang do
  @moduledoc """
  Documentation for `YoloLang`.
  """

  def eval(expr), do: eval([:the_senate, [], expr], [])
  def eval(n, _env)           when is_number(n), do: n
  def eval(n, _env)           when is_binary(n), do: n
  def eval([:+, a, b] = n, env) do
    eval(a, env) + eval(b, env)
  end

  def eval([:*, a, b] = n, env) do
    eval(a, env) * eval(b, env)
  end

  def eval([:-, a, b] = n, env) do
    eval(a, env) - eval(b, env)
  end

  def eval([:/, a, b] = n, env) do
    b_val = eval(b, env)

    if b_val == 0 do
      raise "You were the chosen one!"
    else
      eval(a, env) / b_val
    end
  end

  def eval(varname, env) when is_atom(varname), do: Keyword.fetch!(env, varname)

  def eval([:the_senate, bindings, expr], env) do
    bindings =
      bindings
    |> Enum.map(fn {key, val} -> {key, eval(val, env)} end)

    eval(expr, bindings ++ env)
  end

  def eval([:yoda, params, body], env) do
    {:closure, params, body, env}
  end

  def eval([:dewit, fun_ref | args], env) do
    {:closure, params, body, closure_env} = eval(fun_ref, env)
    args = args |> Enum.map(fn arg -> eval(arg, env) end)
    
    new_env = Enum.zip(params, args)

    eval(body, new_env ++ closure_env)
  end

end

