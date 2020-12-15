### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ 9e82e510-3ddc-11eb-3735-fb444c8a0976
function parse_mask(mask_str)
	mask_str = split(mask_str, " = ")[2]
	mask1 = parse(UInt64, replace(mask_str, ("X"=>"0")), base = 2)
	idxs = findall(==('X'), mask_str) 
	powers = length(mask_str) .- idxs	
	(;mask1 = mask1, powers = powers)
end	

# ╔═╡ 801b1f60-3ddd-11eb-39e0-7b0fdbde1e13
function apply_mask(addr, masks)
	mask1, powers = masks
	l = length(powers)
	addrs = []
	for counter in 0:2^l-1
		# put bits from counter to places from powers
		floating1 = 0
		floating0 = 2^36-1
		bitmask = 2^(l-1)
		m = counter
		for bit_i in 1:l
			bit = m - (m >> 1 << 1)
			if bit == 1
				floating1 += 2^(powers[bit_i])
			else
				floating0 -=  2^(powers[bit_i])
			end
			m = m >> 1
		end
		
		push!(addrs, Int(addr & floating0 | floating1 | mask1 ))
	end

	sort(addrs)
end

# ╔═╡ f49f4f00-3ddd-11eb-3a85-2f60b17738ab
function parse_write(line)
	m = match(r"^mem\[(\d*)\] = (\d*)$", line)
	addr = parse(Int, m.captures[1])
	val =  parse(Int, m.captures[2])
	return (;addr = addr, val = val)
end	

# ╔═╡ 421f4900-3ddf-11eb-2e18-fbf0d4d788af
function parse_line(line)
	if line[2] == 'e'
		return (; comm = :write, val = parse_write(line))
	else
		return (; comm = :mask,  val = parse_mask(line))
	end
end

# ╔═╡ 5356d3e0-3de0-11eb-0ef9-ff7b04a1784a
function run_prog(prog)
	memory = Dict()
	mask = (;mask0 = 0, mask1 = 2^36)
	for comm in prog
		if comm[:comm] == :mask
			mask = comm[:val]
		elseif comm[:comm] == :write
			addr = comm[:val][:addr]
			val = comm[:val][:val]
			addrs = apply_mask(addr, mask)
			for addr_w  in addrs
				memory[addr_w] = val
			end
		else
			error("unknown command")
		end
	end
	memory
end		

# ╔═╡ 64f84eb0-3de2-11eb-27a5-291a7d18522f
begin
	task_prog1 = parse_line.(readlines("./data/input14.txt"))
	part2 = sum(values(run_prog(task_prog1)))
end

# ╔═╡ 9f6fd5c0-3ddf-11eb-3025-57a2a7bd5c72
test_str2=
"mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1"

# ╔═╡ e91fb1c0-3ddc-11eb-105a-cb529e3ae659
begin
	masks_test2_1 = parse_mask("mask = 000000000000000000000000000000X1001X")
	@assert apply_mask(42, masks_test2_1) == [26, 27, 58, 59]
	masks_test2_2 = parse_mask("mask = 00000000000000000000000000000000X0XX")
	@assert apply_mask(26, masks_test2_2) == [16, 17, 18, 19, 24, 25, 26, 27]
end

# ╔═╡ c8178cc0-3ddf-11eb-0a5f-1971fdf45a05
begin
	test_prog = parse_line.(split(test_str2, '\n'))
	@assert sum(values(run_prog(test_prog))) == 208
end

# ╔═╡ Cell order:
# ╟─9e82e510-3ddc-11eb-3735-fb444c8a0976
# ╠═801b1f60-3ddd-11eb-39e0-7b0fdbde1e13
# ╠═f49f4f00-3ddd-11eb-3a85-2f60b17738ab
# ╠═421f4900-3ddf-11eb-2e18-fbf0d4d788af
# ╠═5356d3e0-3de0-11eb-0ef9-ff7b04a1784a
# ╠═64f84eb0-3de2-11eb-27a5-291a7d18522f
# ╠═9f6fd5c0-3ddf-11eb-3025-57a2a7bd5c72
# ╠═e91fb1c0-3ddc-11eb-105a-cb529e3ae659
# ╠═c8178cc0-3ddf-11eb-0a5f-1971fdf45a05
