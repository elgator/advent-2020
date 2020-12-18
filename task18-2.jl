### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ 05f73c70-40fb-11eb-2917-9de4fdca0c2d
function calc(expr)
	# I do not want to build an AST :(
	
	while true
		m = match(r"\(([0-9\+\* ]*)\)", expr)
		if m == nothing
			break
		end
		expr = replace(expr, r"\([0-9\+\* ]*\)"=> calc(m.captures[1]), count=1) 
	end
		
	while true
		m = match(r"(\d*) \+ (\d*)", expr)
		if m == nothing
			break
		end
		num = parse(Int, m.captures[1]) + parse(Int, m.captures[2])
		expr = replace(expr, r"\d* \+ \d*"=>"$num", count=1)
	end
	
	while true
		m = match(r"(\d*) \* (\d*)", expr)
		if m == nothing
			break
		end
		num = parse(Int, m.captures[1]) * parse(Int, m.captures[2])
		expr = replace(expr, r"\d* [\+\*] \d*"=>"$num", count=1)
	end
	expr
end

# ╔═╡ 6d7ea080-4101-11eb-2272-0d5c23c12b27
task_input = readlines("./data/input18.txt")

# ╔═╡ a3b39480-4101-11eb-3ded-adef728df562
part2 = task_input .|> calc .|> (x->parse(Int,x)) |> sum 

# ╔═╡ 352cceb0-40fb-11eb-1a58-f3de037eae53
begin
	@assert parse(Int, calc("1 + (2 * 3) + (4 * (5 + 6))")) == 51
	@assert parse(Int, calc("2 * 3 + (4 * 5)")) == 46
	@assert parse(Int, calc("5 + (8 * 3 + 9 + 3 * 4 * 3)")) == 1445
	@assert parse(Int, calc("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))")) == 669060
	@assert parse(Int, calc("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2")) == 23340
end

# ╔═╡ Cell order:
# ╠═05f73c70-40fb-11eb-2917-9de4fdca0c2d
# ╠═6d7ea080-4101-11eb-2272-0d5c23c12b27
# ╠═a3b39480-4101-11eb-3ded-adef728df562
# ╠═352cceb0-40fb-11eb-1a58-f3de037eae53
