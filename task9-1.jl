### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ a05bdc90-3a33-11eb-29be-abee01a09380
function get_init_sums(preamble)
	n = length(preamble)
	storage = zeros(Int,n,n)
	for i in 1:n, j in 1:i-1
		storage[i, j] = preamble[i]+preamble[j]
	end
	storage
end

# ╔═╡ 0d7ba510-3a4a-11eb-14cf-b1a44a6ac46c
function push_in_storage!(storage, win, new_num)
	# shifts left both storage and win and pushes the new num
	shape = size(storage)
	@assert length(win) == shape[1]
	new_storage = copy(storage)
	
	popfirst!(win)
	push!(win, new_num)
	# shift up and left
	storage[2:end-1,1:end-1] .= new_storage[3:end, 2:end]
	
	for j in 1:(length(win)-1)
		storage[end, j] = new_num + win[j]
	end
	
	storage, win
end

# ╔═╡ abae3400-3a4f-11eb-1877-99bd477dc2ce
function check_series(preamble, series)
	storage = get_init_sums(preamble)

	for num in series
		valid = reshape(storage, (1,:)) |> x-> filter(!=(0), x)
		if !(num ∈ valid)
			return num
		end
		push_in_storage!(storage, preamble, num)
	end
	return 0
end

# ╔═╡ 39a6a050-3a53-11eb-3a08-6d68ff5120fa
function read_preamble_seq(n, rows)
	pre_seq = [parse(Int, x) for x in rows]
	seq = pre_seq[n+1:end]
	pre = pre_seq[1:n]
	pre, seq
end	

# ╔═╡ 2aa06270-3a54-11eb-0292-4de662f7387a
input_rows = readlines("./data/input9.txt")

# ╔═╡ 5f5bfce0-3a54-11eb-2bc0-8d2d5a6b70aa
preamble, seq = read_preamble_seq(25, input_rows)

# ╔═╡ 7d53a630-3a54-11eb-2d0b-e9f9fa649048
check_series(preamble, seq)

# ╔═╡ d0e87ae0-3a55-11eb-0e9e-33709f87dd3e
md"# Tests
## Test 1"

# ╔═╡ 4270c1e0-3a51-11eb-36c4-f5932a73969a
begin
	test_str=
	"35
	20
	15
	25
	47
	40
	62
	55
	65
	95
	102
	117
	150
	182
	127
	219
	299
	277
	309
	576";
	
	test_seq_rows = split(test_str, keepempty=false)
	tst_preamble, test_seq = read_preamble_seq(5, test_seq_rows)
	@assert check_series(tst_preamble, test_seq) == 127
end

# ╔═╡ Cell order:
# ╠═a05bdc90-3a33-11eb-29be-abee01a09380
# ╠═0d7ba510-3a4a-11eb-14cf-b1a44a6ac46c
# ╠═abae3400-3a4f-11eb-1877-99bd477dc2ce
# ╠═39a6a050-3a53-11eb-3a08-6d68ff5120fa
# ╠═2aa06270-3a54-11eb-0292-4de662f7387a
# ╠═5f5bfce0-3a54-11eb-2bc0-8d2d5a6b70aa
# ╠═7d53a630-3a54-11eb-2d0b-e9f9fa649048
# ╠═d0e87ae0-3a55-11eb-0e9e-33709f87dd3e
# ╠═4270c1e0-3a51-11eb-36c4-f5932a73969a
