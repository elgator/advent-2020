### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ 95dfe8b0-3aab-11eb-318e-1785a9452ec2
using DataStructures

# ╔═╡ fdd622e2-3aab-11eb-32ac-d5de49fb8816
function count_diffs(jolt_seq)
	seq = copy(jolt_seq)
	push!(seq, 0)
	sort!(seq)
	counts =  counter(diff(seq))
	counts[3]+=1 #for output socket
	counts
end

# ╔═╡ d2c3b800-3aac-11eb-2ec5-53dc38c0b9ff
jolts =  [parse(Int, x) for x in readlines("./data/input10.txt")]

# ╔═╡ 2045f160-3aad-11eb-2a55-a314a0f99185
counts = count_diffs(jolts)

# ╔═╡ 2b9bb4ee-3aad-11eb-34c7-6d8a698dd6ca
counts[1]*counts[3]

# ╔═╡ 50bdf610-3aaa-11eb-2a2a-27218ca0f28d
begin
	test_str=
	"16
	10
	15
	5
	1
	11
	7
	19
	6
	12
	4"
	test_jolts = [parse(Int, x) for x in split(test_str)]
	c = count_diffs(test_jolts)
	@assert c[3]*c[1] == 35
end

# ╔═╡ f8a93730-3aab-11eb-18ee-2797cf36c08f
begin
	test_str2="
	28
	33
	18
	42
	31
	14
	46
	20
	48
	47
	24
	23
	49
	45
	19
	38
	39
	11
	1
	32
	25
	35
	8
	17
	7
	9
	4
	2
	34
	10
	3"
	test_jolts2 = [parse(Int, x) for x in split(test_str2)]
	c1 = count_diffs(test_jolts2)
	@assert c1[3]*c1[1] == 220
end

# ╔═╡ Cell order:
# ╠═95dfe8b0-3aab-11eb-318e-1785a9452ec2
# ╠═fdd622e2-3aab-11eb-32ac-d5de49fb8816
# ╠═d2c3b800-3aac-11eb-2ec5-53dc38c0b9ff
# ╠═2045f160-3aad-11eb-2a55-a314a0f99185
# ╠═2b9bb4ee-3aad-11eb-34c7-6d8a698dd6ca
# ╠═50bdf610-3aaa-11eb-2a2a-27218ca0f28d
# ╠═f8a93730-3aab-11eb-18ee-2797cf36c08f
