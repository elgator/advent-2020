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

# ╔═╡ 09129862-3b78-11eb-1484-8bd162e7ad4b
begin
	function is_to_occupy(map, mask_map, ij::CartesianIndex)
		region = CartesianIndices((-1:1, -1:1)) .+ ij
		@assert map[ij] == 0
		sum = 0
		for seat in region
			sum += map[seat] * mask_map[seat]
		end
		sum == 0
	end
	
	function is_to_empty(map, mask_map, ij::CartesianIndex)
		region = CartesianIndices((-1:1, -1:1)) .+ ij
		@assert map[ij] == 1
		sum = 0
		for seat in region
			sum += map[seat] * mask_map[seat]
		end
		sum - 1 >= 4
	end
end

# ╔═╡ d490e7c0-3b79-11eb-0193-258281ea6cd9
function step(map, mask)
	@assert size(map) == size(mask)
	
	new_map = copy(map)
	
	for seat_ij in findall(!iszero, mask)
		if map[seat_ij] == 0 
			if is_to_occupy(map, mask, seat_ij)
				new_map[seat_ij] = 1
			end
		elseif  map[seat_ij] == 1 && is_to_empty(map, mask, seat_ij)
			new_map[seat_ij] = 0
		else
			# do nothing
		end
	end
	
	new_map
end		

# ╔═╡ 51d93c20-3b91-11eb-2df9-618c6e4a9ec4
function part1(map, mask)
	counter = 0
	while true
		new_map = step(map, mask)
		counter += 1
		if new_map == map
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
part1(task_map, task_mask)

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
"#.LL.L#.##
#LLLLLL.L#
L.L.L..L..
#LLL.LL.L#
#.LL.LL.LL
#.LLLL#.##
..L.L.....
#LLLLLLLL#
#.LLLLLL.L
#.#LLLL.##"
	
	test_str1_step3 =
"#.##.L#.##
#L###LL.L#
L.#.#..#..
#L##.##.L#
#.##.LL.LL
#.###L#.##
..#.#.....
#L######L#
#.LL###L.L
#.#L###.##"
	
	test_str1_step4 =
"#.#L.L#.##
#LLL#LL.L#
L.L.L..#..
#LLL.##.L#
#.LL.LL.LL
#.LL#L#.##
..L.L.....
#L#LLLL#L#
#.LLLLLL.L
#.#L#L#.##"
	
	test_str1_step5 =
"#.#L.L#.##
#LLL#LL.L#
L.#.L..#..
#L##.##.L#
#.#L.LL.LL
#.#L#L#.##
..L.L.....
#L#L##L#L#
#.LLLLLL.L
#.#L#L#.##"
end

# ╔═╡ 9f8c3dc0-3b76-11eb-3f81-2b9abdfb4f3c
begin
	test_map1 = get_map(test_str1, 'L')
	@assert size(test_map1) == (12, 12)
end

# ╔═╡ 81e541ee-3b75-11eb-29b7-8f327855032a
Array(test_map1)

# ╔═╡ 404fcf70-3b8a-11eb-16d8-35382f71c60a
begin
	mask_test = copy(test_map1)
	step0 = spzeros(Int64,size(mask_test)[1], size(mask_test)[2])
	test_map1_step1 = get_map(test_str1_step1, '#')
	test_map1_step2 = get_map(test_str1_step2, '#')
	test_map1_step3 = get_map(test_str1_step3, '#')
	test_map1_step4 = get_map(test_str1_step4, '#')
	test_map1_step5 = get_map(test_str1_step5, '#')
end;

# ╔═╡ 8c88dc70-3b89-11eb-2e30-65f045c9713c
begin
	step1 = step(step0, mask_test)
	step2 = step(step1, mask_test)
	step3 = step(step2, mask_test)
	step4 = step(step3, mask_test)
	step5 = step(step4, mask_test)
end;

# ╔═╡ 8a7222b2-3b8f-11eb-1035-a738046f0f8f
begin
	@assert step1 == test_map1_step1
	@assert step2 == test_map1_step2
	@assert step3 == test_map1_step3
	@assert step4 == test_map1_step4
	@assert step5 == test_map1_step5
end

# ╔═╡ ca5580f0-3b91-11eb-0ea5-83e2be1ea0fd
@assert part1(test_map1, mask_test) == 37

# ╔═╡ Cell order:
# ╠═ded4a340-3b72-11eb-132e-5720eba91331
# ╠═de27e880-3b72-11eb-1c2c-ff4f90d081f8
# ╠═fd620bd0-3b91-11eb-03f9-6f866ab166da
# ╠═09129862-3b78-11eb-1484-8bd162e7ad4b
# ╠═d490e7c0-3b79-11eb-0193-258281ea6cd9
# ╠═51d93c20-3b91-11eb-2df9-618c6e4a9ec4
# ╠═c41acec0-3b91-11eb-3e39-2d2e12bf7384
# ╠═a81aa850-3b94-11eb-1134-6f64132eb03a
# ╠═dbf34050-3b95-11eb-3573-9da0a7431931
# ╠═fb35e030-3b95-11eb-159f-6599df042d33
# ╟─e3babec0-3b6e-11eb-06cf-4b92565f1b49
# ╠═9f8c3dc0-3b76-11eb-3f81-2b9abdfb4f3c
# ╠═81e541ee-3b75-11eb-29b7-8f327855032a
# ╠═404fcf70-3b8a-11eb-16d8-35382f71c60a
# ╠═8c88dc70-3b89-11eb-2e30-65f045c9713c
# ╠═8a7222b2-3b8f-11eb-1035-a738046f0f8f
# ╠═ca5580f0-3b91-11eb-0ea5-83e2be1ea0fd
