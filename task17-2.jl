### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ 3881b200-402a-11eb-0136-31e289e56009
function step(cube)
	shifts = CartesianIndices((-1:1, -1:1, -1:1, -1:1)) |> 
		collect |> x->filter(!=(CartesianIndex(0,0,0,0)), x)
	n,m,l,o = size(cube)
	
	# padding
	new = zeros(Bool, n+2, m+2, l+2, o+2)
	new[2:n+1, 2:m+1, 2:l+1, 2:o+1] = cube
	
	for w in 1:o+2, k in 1:l+2, i in 1:n+2, j in 1:m+2
		current_idx = CartesianIndex(i,j,k,w)
		nearby_idxs = shifts .|> x -> x + current_idx - CartesianIndex(1,1,1,1)
		filtered_idxs = filter(x -> checkbounds(Bool, cube, x), nearby_idxs)
		s = sum([cube[idx] for idx in filtered_idxs])
		current = new[current_idx]
		if current
			if !(s == 2 || s == 3)
				new[current_idx] = 0
			end
		else
			if s == 3
				new[current_idx] = 1
			end
		end
	end
	
	# trim, thin cases e.g 1x2x3x4 are not checked
	while sum(new[1    , :, :, :]) == 0
		new = new[2:end, :, :, :]
	end
	while sum(new[:, 1    , :, :]) == 0
		new = new[:, 2:end, :, :]
	end
	while sum(new[:, :, 1    , :]) == 0
		new = new[:, :, 2:end, :]
	end
	while sum(new[:, :, :, 1    ]) == 0
		new = new[:, :, :, 2:end]
	end
	while sum(new[end    , :, :, :]) == 0
		new = new[1:end-1, :, :, :]
	end
	while sum(new[:, end    , :, :]) == 0
		new = new[:, 1:end-1, :, :]
	end
	while sum(new[:, :, end    , :]) == 0
		new = new[:, :, 1:end-1, :]
	end
	while sum(new[:, :, :, end    ]) == 0
		new = new[:, :, :, 1:end-1]
	end	
	
	new
end	

# ╔═╡ 2b5b9ed0-4078-11eb-171c-7ffff9188113
function six_cycles(cube)
	for i in 1:6
		cube = step(cube)
	end
	cube
end

# ╔═╡ fa4d0a00-407b-11eb-1977-4d5235edef80
function hash_dot_matrix(lines)
	line_size = length(lines[1])
	hd_matrix = zeros(Bool, 1, line_size)
	
	for line in lines
		hd_matrix = vcat(hd_matrix, [x=='#' for x in line]')
	end
	hd_matrix[2:end, :]
end

# ╔═╡ dac83b92-407c-11eb-15a7-3558d105e7d2
begin
	part2_input =  hash_dot_matrix(readlines("./data/input17.txt")) 
	m,n = size(part2_input)
	part2_input = reshape(part2_input, (m,n,1,1))
end

# ╔═╡ 2d803a40-407d-11eb-387b-ff0206be8a42
part2 = sum(six_cycles(part2_input))

# ╔═╡ 9fe59370-407b-11eb-155e-03c93f13b6a8
begin
	test_str =
	""".#.
	..#
	###"""
	a = hash_dot_matrix(split(test_str, '\n')) |> x-> reshape(x, (3,3,1,1))
	@assert sum(six_cycles(a)) == 848
end

# ╔═╡ Cell order:
# ╠═3881b200-402a-11eb-0136-31e289e56009
# ╠═2b5b9ed0-4078-11eb-171c-7ffff9188113
# ╠═fa4d0a00-407b-11eb-1977-4d5235edef80
# ╠═dac83b92-407c-11eb-15a7-3558d105e7d2
# ╠═2d803a40-407d-11eb-387b-ff0206be8a42
# ╠═9fe59370-407b-11eb-155e-03c93f13b6a8
