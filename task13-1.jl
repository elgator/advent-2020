### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ f894a952-3d12-11eb-366b-2f658c4d5586
function wait_time(time, bus)
	bus - mod(time, bus)
end

# ╔═╡ c0fea940-3d13-11eb-3fc9-5daa03a0f6d9
function find_bus(time, busses)
	idx = argmin(wait_time.(Ref(time), busses))
	return busses[idx], wait_time(time, busses[idx])
end

# ╔═╡ 77f9b010-3d12-11eb-1c5b-8d25c619c277
function get_busses(bus_str)
	seq = split(bus_str, ',')
	busses = [parse(Int64, bus) for bus in seq if bus !="x"]
end

# ╔═╡ 28708db0-3d13-11eb-02b7-3d287668f350
begin
	task_time_s, task_busses_s = readlines("./data/input13.txt")
	task_time = parse(Int64, task_time_s)
	task_busses = get_busses(task_busses_s)
	part1 = prod(find_bus(task_time, task_busses))
end

# ╔═╡ 74948180-3d11-11eb-0aad-e74b26c81a86
test_str=
"939
7,13,x,x,59,x,31,19"

# ╔═╡ 55f55820-3d12-11eb-0950-67f2db9b1827
begin
	test_time_s, test_busses_s = split(test_str, '\n')
	test_time = parse(Int64, test_time_s)
	test_busses = get_busses(test_busses_s)
	@assert prod(find_bus(test_time, test_busses)) == 295
end

# ╔═╡ Cell order:
# ╠═f894a952-3d12-11eb-366b-2f658c4d5586
# ╠═c0fea940-3d13-11eb-3fc9-5daa03a0f6d9
# ╠═77f9b010-3d12-11eb-1c5b-8d25c619c277
# ╠═28708db0-3d13-11eb-02b7-3d287668f350
# ╠═74948180-3d11-11eb-0aad-e74b26c81a86
# ╠═55f55820-3d12-11eb-0950-67f2db9b1827
