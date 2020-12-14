### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ 9e82e510-3ddc-11eb-3735-fb444c8a0976
function parse_mask(mask_str)
	mask_str = split(mask_str, " = ")[2]
	mask0 = parse(UInt64, replace(mask_str, ("X"=>"1")), base = 2)
	mask1 = parse(UInt64, replace(mask_str, ("X"=>"0")), base = 2)
	(;mask0 = mask0, mask1 = mask1)
end	

# ╔═╡ 801b1f60-3ddd-11eb-39e0-7b0fdbde1e13
function apply_mask(x, masks)
	mask0, mask1 = masks
	Int(x & mask0 | mask1)
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
			memory[addr] = apply_mask(val, mask)
		else
			error("unknown command")
		end
	end
	memory
end		

# ╔═╡ 64f84eb0-3de2-11eb-27a5-291a7d18522f
begin
	task_prog1 = parse_line.(readlines("./data/input14.txt"))
	part1 = sum( values(run_prog(task_prog1)))
end

# ╔═╡ 9f6fd5c0-3ddf-11eb-3025-57a2a7bd5c72
test_str1=
"mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0"

# ╔═╡ e91fb1c0-3ddc-11eb-105a-cb529e3ae659
begin
	masks_test1 = parse_mask("mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X")
	@assert apply_mask(11, masks_test1) == 73
	@assert apply_mask(101, masks_test1) == 101
	@assert apply_mask(0, masks_test1) == 64
end

# ╔═╡ c8178cc0-3ddf-11eb-0a5f-1971fdf45a05
begin
	test_prog = parse_line.(split(test_str1, '\n'))
	@assert sum( values(run_prog(test_prog))) == 165
end

# ╔═╡ Cell order:
# ╠═9e82e510-3ddc-11eb-3735-fb444c8a0976
# ╠═801b1f60-3ddd-11eb-39e0-7b0fdbde1e13
# ╠═f49f4f00-3ddd-11eb-3a85-2f60b17738ab
# ╠═421f4900-3ddf-11eb-2e18-fbf0d4d788af
# ╠═5356d3e0-3de0-11eb-0ef9-ff7b04a1784a
# ╠═64f84eb0-3de2-11eb-27a5-291a7d18522f
# ╠═9f6fd5c0-3ddf-11eb-3025-57a2a7bd5c72
# ╠═e91fb1c0-3ddc-11eb-105a-cb529e3ae659
# ╠═c8178cc0-3ddf-11eb-0a5f-1971fdf45a05
