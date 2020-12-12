### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ 36827a90-3c90-11eb-0807-bb4e2cd6b6dc
mutable struct Ferry
	x::Float64
	y::Float64
	fx::Float64 # ferry
	fy::Float64
	
	Ferry() = new(10, 1, 0, 0)
end	

# ╔═╡ 8830df30-3c95-11eb-1f93-8146d34e2c34
distance(f::Ferry) = round(Int64, abs(f.fx) + abs(f.fy))

# ╔═╡ f75f30a0-3c90-11eb-0b9b-097d42b25859
function move_north!(f::Ferry, dy)
	f.y += dy
end

# ╔═╡ 2a10ca3e-3c91-11eb-32fb-411f5d3004e7
function move_east!(f::Ferry, dx)
	f.x += dx
end

# ╔═╡ 45279ac0-3c91-11eb-0deb-41e314fa0c78
function rotate!(f::Ferry, Δangle)
	ϕ = Δangle/360*2π
	x = f.x*cos(ϕ) - f.y*sin(ϕ)
	y = f.x*sin(ϕ) + f.y*cos(ϕ)
	f.x, f.y = x, y	
end

# ╔═╡ 93ee6210-3c91-11eb-3841-a1cd9cf52e7b
function forward!(f::Ferry, count)
	f.fx += count * f.x
	f.fy += count * f.y
end	

# ╔═╡ 06cf1ae0-3c92-11eb-3694-cfbfa667098b
begin
	function do!(f::Ferry, comm, num)
		if     comm == :north
			move_north!(f, num)
		elseif comm == :south
			move_north!(f, -num)
		elseif comm == :east
			move_east!(f, num)
		elseif comm == :west
			move_east!(f, -num)
		elseif comm == :right
			rotate!(f, -num)
		elseif comm == :left
			rotate!(f, num)
		elseif comm == :forward
			forward!(f, num)
		else
			error("unknown command to do $comm")
		end
	end
		
	function do!(f::Ferry, comms::Array)
		for comm in comms
			do!(f, comm...)
		end
	end
end

# ╔═╡ 95bc3680-3c8c-11eb-3c3c-fd3b865cee7b
function parse_comms(rows)
	comms = []
	for row in rows
		m = match(r"^(\w)(\d*)$", row)
		if m === nothing
			error("unparsable line")
		end
		
		comm = m.captures[1]
		num = parse(Int, m.captures[2])

		if     comm == "N"
			comm = :north
		elseif comm == "S"
			comm = :south
		elseif comm == "E"
			comm = :east
		elseif comm == "W"
			comm = :west
		elseif comm == "F"
			comm = :forward
		elseif comm == "R"
			comm = :right
		elseif comm == "L"
			comm = :left
		else
			@show m
			error("unknown command")
		end
				
		push!(comms, (comm, num))
	end
	comms
end

# ╔═╡ 0b171d70-3c95-11eb-0bb7-9b9ff49b4d9a
begin
	task1_rows =  readlines("./data/input12.txt")
	task1_comms = parse_comms(task1_rows)
end

# ╔═╡ c0779c30-3c95-11eb-0e4b-2545559b15eb
begin
	task2_ferry = Ferry()
	do!(task2_ferry, task1_comms)
	distance(task2_ferry)
end

# ╔═╡ 36e54d50-3c8b-11eb-0a52-63e3a084d2ed
test_str1=
"F10
N3
F7
R90
F11"

# ╔═╡ a0a83bc0-3c8c-11eb-25e4-17ea2e8643c5
begin
	test_rows = split(test_str1, '\n')
	test_comms = parse_comms(test_rows)
end

# ╔═╡ de898ba0-3c92-11eb-11f6-5ff019d0e9b9
begin
	test_ferry = Ferry()
	do!(test_ferry, test_comms)
	@assert distance(test_ferry) == 286
end

# ╔═╡ Cell order:
# ╠═36827a90-3c90-11eb-0807-bb4e2cd6b6dc
# ╠═8830df30-3c95-11eb-1f93-8146d34e2c34
# ╠═f75f30a0-3c90-11eb-0b9b-097d42b25859
# ╠═2a10ca3e-3c91-11eb-32fb-411f5d3004e7
# ╠═45279ac0-3c91-11eb-0deb-41e314fa0c78
# ╠═93ee6210-3c91-11eb-3841-a1cd9cf52e7b
# ╠═06cf1ae0-3c92-11eb-3694-cfbfa667098b
# ╠═95bc3680-3c8c-11eb-3c3c-fd3b865cee7b
# ╠═0b171d70-3c95-11eb-0bb7-9b9ff49b4d9a
# ╠═c0779c30-3c95-11eb-0e4b-2545559b15eb
# ╠═36e54d50-3c8b-11eb-0a52-63e3a084d2ed
# ╠═a0a83bc0-3c8c-11eb-25e4-17ea2e8643c5
# ╠═de898ba0-3c92-11eb-11f6-5ff019d0e9b9
