### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ ded4a340-3b72-11eb-132e-5720eba91331
using SparseArrays

# ╔═╡ de27e880-3b72-11eb-1c2c-ff4f90d081f8
function get_map(str_map::Array, ch::Char)
	rows = str_map
	l = length(first(rows))
	is=Vector{Int}()
	js=Vector{Int}()
	vs=Vector{Int}()
	
	for (i, r) in enumerate(rows)
		@assert length(r) == l
		
		# adding 1 to indices for left padding
		js_to_add = findall(==(ch), r) .+ 1
		is_to_add = fill(i, size(js_to_add)) .+ 1
		vs_to_add = ones(Int64, size(js_to_add))
		
		push!(is, is_to_add...)
		push!(js, js_to_add...)
		push!(vs, vs_to_add...)		
	end
	
	# padding
	m, n = length(rows) + 2, l + 2
	
	sparse(is, js, vs, m, n)
end	

# ╔═╡ fd620bd0-3b91-11eb-03f9-6f866ab166da
function get_map(str_map::String, ch::Char)
	rows = split(str_map, "\n")
	get_map(rows, ch)
end

# ╔═╡ f1aee832-3ba0-11eb-01ae-cb7301946f87
function build_pairs(bitvec::Vector{Int})
	l = length(bitvec)
	@assert l >= 2
	i = 1
	pair_idxs = Array{Tuple{Int, Int},1}()
	
	while i <= l - 1
		if bitvec[i] != 0
			for j in i+1:l
				if bitvec[j] == 1
					push!(pair_idxs, (i,j))
					push!(pair_idxs, (j,i))
					i = j - 1
					break
				end
			end
		end
		i += 1
	end
	pair_idxs
end

# ╔═╡ 9f9d3dd0-3baf-11eb-15e2-5757681eeacd
function path_to_pairs(map, path::Vector{CartesianIndex{2}})
	# result is an array of pairs of visible points along the path 
	bitvec = [map[point] for point in path]
	idxs = build_pairs(bitvec)
	pairs = [(path[idx1], path[idx2]) for (idx1,idx2) in idxs]
end

# ╔═╡ 602aab20-3b9f-11eb-0ef5-e9d53dd112a9
function build_pairs_array(map)
	pairs = Vector{Tuple}()
	
	m, n = size(map)
	
	# up-down
	for i in 1:m
		path = [CartesianIndex(i, j) for j in 1:n]
		p = path_to_pairs(map, path)
		push!(pairs, p...)
	end
	
	# left-right
	for j in 1:n
		path = [CartesianIndex(i, j) for i in 1:m]
		p = path_to_pairs(map, path)
		push!(pairs, p...)
	end
	
	# upleft-downright, lower triangle
	for i in 1:m-1
		path = Vector{CartesianIndex{2}}()
		for k in 1:min(m, n)
			i1 = i + (k - 1)
			j1 = k
			if i1 > m || j1 > n
				break
			else
				push!(path, CartesianIndex(i1, j1))
			end
		end
		if length(path) >= 2
			p = path_to_pairs(map, path)
			push!(pairs, p...)
		end
	end
	
	# upleft-downright, upper triangle
	for j in 2:n-1
		path = Vector{CartesianIndex{2}}()
		for k in 1:min(m, n)
			i1 = k 
			j1 = j + (k - 1)
			if i1 > m || j1 > n
				break
			else
				push!(path, CartesianIndex(i1, j1))
			end
		end
		if length(path) >= 2
			p = path_to_pairs(map, path)
			push!(pairs, p...)
		end
	end
	
	# upright-downleft, lower triangle
	for i in 1:m-1
		path = Vector{CartesianIndex{2}}()
		for k in 1:min(m, n)
			i1 = i + (k - 1)
			j1 = n - (k - 1)
			if i1 > m || j1 < 1
				break
			else
				push!(path, CartesianIndex(i1, j1))
			end
		end
		if length(path) >= 2
			p = path_to_pairs(map, path)
			push!(pairs, p...)
		end
	end
	
	# upright-downleft, upper triangle
	for j in 2:n-1
		path = Vector{CartesianIndex{2}}()
		for k in 1:min(m, n)
			i1 = k
			j1 = j - (k - 1)
			if i1 > m || j1 < 1
				break
			else
				push!(path, CartesianIndex(i1, j1))
			end
		end
		if length(path) >= 2
			p = path_to_pairs(map, path)
			push!(pairs, p...)
		end
	end
	
	pairs
end

# ╔═╡ 048b5430-3bc8-11eb-3d20-43c9ff8f5c53
function pairs_to_hash(mask, pairs)
	hash = Dict()
	for idx_key_pair in findall(!iszero, mask)
		visible = Vector{CartesianIndex{2}}()
		for pair in pairs
			if pair[1] == idx_key_pair
				push!(visible, pair[2])
			end
		end
		hash[idx_key_pair] = deepcopy(visible)
	end
	hash
end

# ╔═╡ 09129862-3b78-11eb-1484-8bd162e7ad4b
begin
	function is_to_occupy(map, pairs, ij::CartesianIndex)
		visible = pairs[ij]
		
		@assert map[ij] == 0
		sum = 0
		for seat in visible
			sum += map[seat]
		end
		sum == 0
	end
	
	function is_to_empty(map, pairs, ij::CartesianIndex)
		visible = pairs[ij]

		@assert map[ij] == 1
		sum = 0
		for seat in visible
			sum += map[seat]
		end
		sum >= 5
	end
end

# ╔═╡ d490e7c0-3b79-11eb-0193-258281ea6cd9
function step(map::AbstractArray, mask::AbstractArray, pairs::Dict)
	@assert size(map) == size(mask)
	
	new_map = copy(map)
	changes = false
	
	for seat_ij in findall(!iszero, mask)
		if map[seat_ij] == 0 
			if is_to_occupy(map, pairs, seat_ij)
				new_map[seat_ij] = 1
				changes = true
			end
		elseif  map[seat_ij] == 1 && is_to_empty(map, pairs, seat_ij)
			new_map[seat_ij] = 0
			changes = true
		else
			# do nothing
		end
	end
	
	new_map, changes
end		

# ╔═╡ 51d93c20-3b91-11eb-2df9-618c6e4a9ec4
function part2(map, mask)
	counter = 0
	pairs = build_pairs_array(map)
	pairs = pairs_to_hash(mask, pairs)
	while true
		new_map, changes = step(map, mask, pairs)
		counter += 1
		if !changes
			break
		else
			map = new_map
		end
		if counter > 1000
			error("too long")
		end
        
	end
	return sum(map)
end

# ╔═╡ c41acec0-3b91-11eb-3e39-2d2e12bf7384
task_map_rows = readlines("./data/input11.txt");

# ╔═╡ a81aa850-3b94-11eb-1134-6f64132eb03a
task_map = get_map(task_map_rows, 'L');

# ╔═╡ dbf34050-3b95-11eb-3573-9da0a7431931
task_mask = copy(task_map);

# ╔═╡ fb35e030-3b95-11eb-159f-6599df042d33
part2(task_map, task_mask)

# ╔═╡ e3babec0-3b6e-11eb-06cf-4b92565f1b49
begin
	test_str1 = 
"L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL"
	
	test_str1_step1 = 
"#.##.##.##
#######.##
#.#.#..#..
####.##.##
#.##.##.##
#.#####.##
..#.#.....
##########
#.######.#
#.#####.##"
	
	test_str1_step2 =
"#.LL.LL.L#
#LLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLL#
#.LLLLLL.L
#.LLLLL.L#"
	
	test_str1_step3 =
"#.L#.##.L#
#L#####.LL
L.#.#..#..
##L#.##.##
#.##.#L.##
#.#####.#L
..#.#.....
LLL####LL#
#.L#####.L
#.L####.L#"
	
	test_str1_step4 =
"#.L#.L#.L#
#LLLLLL.LL
L.L.L..#..
##LL.LL.L#
L.LL.LL.L#
#.LLLLL.LL
..L.L.....
LLLLLLLLL#
#.LLLLL#.L
#.L#LL#.L#"
	
	test_str1_step5 =
"#.L#.L#.L#
#LLLLLL.LL
L.L.L..#..
##L#.#L.L#
L.L#.#L.L#
#.L####.LL
..#.#.....
LLL###LLL#
#.LLLLL#.L
#.L#LL#.L#"
	
	test_str1_step6 =
"#.L#.L#.L#
#LLLLLL.LL
L.L.L..#..
##L#.#L.L#
L.L#.LL.L#
#.LLLL#.LL
..#.L.....
LLL###LLL#
#.LLLLL#.L
#.L#LL#.L#"
end

# ╔═╡ 9f8c3dc0-3b76-11eb-3f81-2b9abdfb4f3c
begin
	test_map1 = get_map(test_str1, 'L')
	@assert size(test_map1) == (12, 12)
end

# ╔═╡ 404fcf70-3b8a-11eb-16d8-35382f71c60a
begin
	mask_test = copy(test_map1)
	step0 = spzeros(Int64,size(mask_test)[1], size(mask_test)[2])
	test_map1_step1 = get_map(test_str1_step1, '#')
	test_map1_step2 = get_map(test_str1_step2, '#')
	test_map1_step3 = get_map(test_str1_step3, '#')
	test_map1_step4 = get_map(test_str1_step4, '#')
	test_map1_step5 = get_map(test_str1_step5, '#')
	test_map1_step6 = get_map(test_str1_step6, '#')
	pairs_test = build_pairs_array(test_map1)
	pairs_hash = pairs_to_hash(mask_test, pairs_test)
end;

# ╔═╡ 8c88dc70-3b89-11eb-2e30-65f045c9713c
begin
	step1, c = step(step0, mask_test, pairs_hash)
	step2, c = step(step1, mask_test, pairs_hash)
	step3, c = step(step2, mask_test, pairs_hash)
	step4, c = step(step3, mask_test, pairs_hash)
	step5, c = step(step4, mask_test, pairs_hash)
	step6, c = step(step5, mask_test, pairs_hash)
end;

# ╔═╡ 8a7222b2-3b8f-11eb-1035-a738046f0f8f
begin
	@assert step1 == test_map1_step1
	@assert step2 == test_map1_step2
	@assert step3 == test_map1_step3
	@assert step4 == test_map1_step4
	@assert step5 == test_map1_step5
	@assert step6 == test_map1_step6
end

# ╔═╡ ca5580f0-3b91-11eb-0ea5-83e2be1ea0fd
@assert part2(test_map1, mask_test) == 26

# ╔═╡ Cell order:
# ╠═ded4a340-3b72-11eb-132e-5720eba91331
# ╠═de27e880-3b72-11eb-1c2c-ff4f90d081f8
# ╠═fd620bd0-3b91-11eb-03f9-6f866ab166da
# ╠═f1aee832-3ba0-11eb-01ae-cb7301946f87
# ╠═9f9d3dd0-3baf-11eb-15e2-5757681eeacd
# ╠═602aab20-3b9f-11eb-0ef5-e9d53dd112a9
# ╠═048b5430-3bc8-11eb-3d20-43c9ff8f5c53
# ╠═09129862-3b78-11eb-1484-8bd162e7ad4b
# ╠═d490e7c0-3b79-11eb-0193-258281ea6cd9
# ╠═51d93c20-3b91-11eb-2df9-618c6e4a9ec4
# ╠═c41acec0-3b91-11eb-3e39-2d2e12bf7384
# ╠═a81aa850-3b94-11eb-1134-6f64132eb03a
# ╠═dbf34050-3b95-11eb-3573-9da0a7431931
# ╠═fb35e030-3b95-11eb-159f-6599df042d33
# ╟─e3babec0-3b6e-11eb-06cf-4b92565f1b49
# ╟─9f8c3dc0-3b76-11eb-3f81-2b9abdfb4f3c
# ╠═404fcf70-3b8a-11eb-16d8-35382f71c60a
# ╠═8c88dc70-3b89-11eb-2e30-65f045c9713c
# ╠═8a7222b2-3b8f-11eb-1035-a738046f0f8f
# ╠═ca5580f0-3b91-11eb-0ea5-83e2be1ea0fd
