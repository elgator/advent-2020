### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ 1e714470-3918-11eb-2de9-4dcc5053b7a0
begin
	mutable struct Runnr
		acc::Int
		address::Int
		history::Array{Int, 1}
		status::Symbol

		Runnr()=new(0, 1, [], :running)
	end
	
	# make runners' states comparable
	import Base.:(==)
	==(r1::Runnr, r2::Runnr) = (r1.acc==r2.acc) && 
		(r1.address==r2.address) && (r1.history ==r2.history)
end

# ╔═╡ e131006e-391a-11eb-322f-ab5ba69be263
begin
	function exec_command!(r::Runnr, command::Tuple)
		comm = command[1]
		args = command[2:end]
		
		push!(r.history, r.address)
		
		if comm == "nop"
			#
		elseif comm == "acc"
			r.acc += args[1]
		elseif comm == "jmp"
			r.address += args[1]
		else
			error("Unknown VM command at $r.address")
		end
		
		if comm !="jmp" r.address +=1 end
		return r
	end
	
	function vm_main_cycle(prog::Array)
		r = Runnr()
		
		while true
			if r.address ∈ r.history
				r.status = :cycle
				break
			end
			
			if r.address == length(prog) + 1
				r.status = :normal_term
				break
			end
				
			if !(1<= r.address < length(prog) + 1)
				r.status = :bounds_fail
				break
			end
			
			exec_command!(r, prog[r.address])
		end
		
		r
	end
	
	parse_line(line) = split(line) |> x -> (x[1], parse(Int, x[2]))
end

# ╔═╡ 51d77c80-3922-11eb-273f-71137e8bee3f
prog = parse_line.(readlines("./data/input8.txt"))

# ╔═╡ bdb15980-3922-11eb-025f-4756ee11fde2
r = vm_main_cycle(prog).acc

# ╔═╡ c346e020-3924-11eb-2983-4bc39ffb0737
md"## Part 2"

# ╔═╡ d56f5020-3924-11eb-3838-c5cb2f4f801f
function alter_comm(comm::Tuple)
	if comm[1]=="jmp"
		("nop", comm[2])
	elseif comm[1]=="nop"
		("jmp", comm[2])
	else
		comm
	end
end

# ╔═╡ 9e72d750-392d-11eb-31d7-9deb15dcfdb6
function find_patch(prog)
	to_change = findall(x->x[1]=="nop"||x[1]=="jmp", prog)
	
	for addr in to_change
		prog_alt = copy(prog)
		prog_alt[addr] = alter_comm(prog_alt[addr])
		
		r=vm_main_cycle(prog_alt)
		if r.status==:normal_term
			return addr, r.acc
		end
	end
end

# ╔═╡ f27bc000-392d-11eb-01c6-c5d7d3c54d2d
find_patch(prog)[2]

# ╔═╡ 6a9ead20-3921-11eb-0a63-07b9890283da
md"# Tests
## Test 1"

# ╔═╡ c9adac60-3919-11eb-2b15-cda59425d009
begin
	test_str=
	"nop +0
	acc +1
	jmp +4
	acc +3
	jmp -3
	acc -99
	acc +1
	jmp -4
	acc +6"
	
	test_prog = parse_line.(split(test_str, '\n'))
	
	r1 = exec_command!(Runnr(), ("nop", 0)) |>
	x-> exec_command!(x, ("acc", 1)) |>
	x-> exec_command!(x, ("jmp", 4)) |>
	x-> exec_command!(x, ("acc", 1)) |>
	x-> exec_command!(x, ("jmp", -4)) |>
	x-> exec_command!(x, ("acc", 3)) |>
	x-> exec_command!(x, ("jmp", -3)) 
	
	r2 = exec_command!(Runnr(), test_prog[1]) |> 
	x-> exec_command!(x, test_prog[x.address]) |>
	x-> exec_command!(x, test_prog[x.address]) |>
	x-> exec_command!(x, test_prog[x.address]) |>
	x-> exec_command!(x, test_prog[x.address]) |>
	x-> exec_command!(x, test_prog[x.address]) |>
	x-> exec_command!(x, test_prog[x.address])
	
	@assert r1 == r2
	@assert r1.acc == 5
	
	r_test = vm_main_cycle(test_prog)
	
	@assert r_test == r1
	
end

# ╔═╡ 3ec5c44e-392a-11eb-178c-191634d08ee3
md"## Test 2"

# ╔═╡ 321891a0-392b-11eb-2e20-9d34389b2e1a
begin
	addr, acc = find_patch(test_prog)
	@assert addr == 8
	@assert acc == 8
end

# ╔═╡ Cell order:
# ╠═1e714470-3918-11eb-2de9-4dcc5053b7a0
# ╠═e131006e-391a-11eb-322f-ab5ba69be263
# ╠═51d77c80-3922-11eb-273f-71137e8bee3f
# ╠═bdb15980-3922-11eb-025f-4756ee11fde2
# ╟─c346e020-3924-11eb-2983-4bc39ffb0737
# ╠═d56f5020-3924-11eb-3838-c5cb2f4f801f
# ╠═9e72d750-392d-11eb-31d7-9deb15dcfdb6
# ╠═f27bc000-392d-11eb-01c6-c5d7d3c54d2d
# ╟─6a9ead20-3921-11eb-0a63-07b9890283da
# ╠═c9adac60-3919-11eb-2b15-cda59425d009
# ╟─3ec5c44e-392a-11eb-178c-191634d08ee3
# ╠═321891a0-392b-11eb-2e20-9d34389b2e1a
