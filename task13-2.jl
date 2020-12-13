### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ 77f9b010-3d12-11eb-1c5b-8d25c619c277
function get_busses(bus_str)
	seq = split(bus_str, ',')
	busses = []
	t = 0
	for bus in seq
		if bus !="x"
			push!(busses, (parse(Int64, bus), t))
		end
		t += 1
	end
	return busses
end

# ╔═╡ e22fb430-3d2a-11eb-1468-ffe3e993a895
function find_shift(period1, period2, shift, residual)
	@assert residual >= 0
	i = 1
	while i <= period2
		num = i*period1 + shift
		if mod(num, period2) == residual
			break
		end
		i += 1
	end
	return i
end

# ╔═╡ 5be17650-3d2c-11eb-20bf-f79270edd725
let
	x = 7
	y = 13
	Δt = 12
	
	t = find_shift(x, y, 0, y-Δt) * x
	@assert mod(t, x) == 0
	@assert mod(t+Δt, y) == 0
end

# ╔═╡ 8dd3e1d0-3d30-11eb-003a-f388db4139e4
function find_shift2(seq)
	shift = 0
	prod = popfirst!(seq)[1]
	for (num, Δt) in seq
		Δt = mod(Δt, num)
		shift = find_shift(prod, num, shift, num-Δt) * prod + shift
		prod *= num
	end
	return shift
end	

# ╔═╡ 5dfbffa0-3d31-11eb-0369-7f931f119e9f
let
	seq = [(17, 0), (13, 2), (19, 3)]
	shift = find_shift2(seq)
	@assert shift == 3417
	@assert mod(shift, 17) == 0
	@assert mod(shift+2, 13) == 0
	@assert mod(shift+3, 19) == 0
end

# ╔═╡ 28708db0-3d13-11eb-02b7-3d287668f350
begin
	task_time_s, task_busses_s = readlines("./data/input13.txt")
	task_time = parse(Int64, task_time_s)
	part2 = get_busses(task_busses_s) |> find_shift2
end

# ╔═╡ b8c7e7e0-3d32-11eb-2c4f-f5e26bd2cf93
begin
	test_str="7,13,x,x,59,x,31,19"
	test_str2="17,x,13,19"
	test_str3="67,7,59,61"
	test_str4="67,x,7,59,61"
	test_str5="67,7,x,59,61"
	test_str6="1789,37,47,1889"
end

# ╔═╡ e3591f62-3d32-11eb-25a6-2d5d58d63a36
begin
	@assert get_busses(test_str) |> find_shift2 == 1068781
	@assert get_busses(test_str2) |> find_shift2 == 3417
	@assert get_busses(test_str3) |> find_shift2 == 754018
	@assert get_busses(test_str4) |> find_shift2 == 779210
	@assert get_busses(test_str5) |> find_shift2 == 1261476
	@assert get_busses(test_str6) |> find_shift2 == 1202161486
end

# ╔═╡ Cell order:
# ╠═77f9b010-3d12-11eb-1c5b-8d25c619c277
# ╠═e22fb430-3d2a-11eb-1468-ffe3e993a895
# ╠═5be17650-3d2c-11eb-20bf-f79270edd725
# ╠═8dd3e1d0-3d30-11eb-003a-f388db4139e4
# ╠═5dfbffa0-3d31-11eb-0369-7f931f119e9f
# ╠═28708db0-3d13-11eb-02b7-3d287668f350
# ╠═b8c7e7e0-3d32-11eb-2c4f-f5e26bd2cf93
# ╠═e3591f62-3d32-11eb-25a6-2d5d58d63a36
