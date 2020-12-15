### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ 58f18100-3e9a-11eb-3cac-d388466f0115
function step!(memory, last, i)
	next = nothing
	if !(last ∈ keys(memory))
		next = 0
	else
		next = i+1-memory[last]
	end
	memory[last] = i+1
	next
end

# ╔═╡ e10b9de0-3e9b-11eb-1dea-bfe1fd3f3917
function calc(init, limit=2020)
	memory = Dict()
	next  = 0
	for i in 1:length(init)
		next = step!(memory, init[i], i-1)
	end

	for i in length(init)+1:limit-1
		next = step!(memory, next, i-1)
	end
	next
end

# ╔═╡ 8969b77e-3ebd-11eb-3a0c-7bdc2fa69707
let
	m = Dict()
	step!(m, 0, 0)
	step!(m, 3, 1)
	@assert step!(m, 6, 2) == 0
	@assert step!(m, 0, 3) == 3
	@assert step!(m, 3, 4) == 3
	@assert step!(m, 3, 5) == 1
	@assert step!(m, 1, 6) == 0
	@assert step!(m, 0, 7) == 4
	@assert step!(m, 4, 8) == 0
end

# ╔═╡ 112cb6ae-3e9e-11eb-225c-71dd42311cb4
begin
	@assert calc([0,3,6], 2020) == 436
	@assert calc([1,3,2], 2020) == 1
	@assert calc([2,1,3], 2020) == 10
	@assert calc([1,2,3], 2020) == 27
	@assert calc([2,3,1], 2020) == 78
	@assert calc([3,2,1], 2020) == 438
	@assert calc([3,1,2], 2020) == 1836
end

# ╔═╡ e26760b0-3ec4-11eb-0043-7bb3e76bfeaf
part1 = calc([8,0,17,4,1,12], 2020)

# ╔═╡ Cell order:
# ╠═58f18100-3e9a-11eb-3cac-d388466f0115
# ╠═e10b9de0-3e9b-11eb-1dea-bfe1fd3f3917
# ╠═8969b77e-3ebd-11eb-3a0c-7bdc2fa69707
# ╠═112cb6ae-3e9e-11eb-225c-71dd42311cb4
# ╠═e26760b0-3ec4-11eb-0043-7bb3e76bfeaf
