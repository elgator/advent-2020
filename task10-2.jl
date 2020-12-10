### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ 95dfe8b0-3aab-11eb-318e-1785a9452ec2
using DataStructures

# ╔═╡ d3f59ff0-3aba-11eb-227b-59a7de53a275
function prepare_diffs(jolt_seq)
	seq = copy(jolt_seq)
	push!(seq, 0)
	push!(seq, max(seq...) + 3)
	sort!(seq)
	diff(seq)
end

# ╔═╡ fdd622e2-3aab-11eb-32ac-d5de49fb8816
function count_diffs(jolt_seq)
	counter(prepare_diffs(jolt_seq))
end

# ╔═╡ d2c3b800-3aac-11eb-2ec5-53dc38c0b9ff
jolts =  [parse(Int, x) for x in readlines("./data/input10.txt")]

# ╔═╡ 2045f160-3aad-11eb-2a55-a314a0f99185
counts = count_diffs(jolts)

# ╔═╡ 61b4db30-3abb-11eb-064a-bf3a27daca27
part1 = counts[1]*counts[3]

# ╔═╡ 878e53d0-3ab7-11eb-2895-dd3912fca094
diffs = prepare_diffs(jolts)

# ╔═╡ 09c41150-3ab8-11eb-2468-d5e81cbae3e5
# calculated manualy: how many combinations can give a fixed sum
# i.e. 4=1+1+1+1=2+1+1=1+2+1=1+1+2=2+2=3+1=1+3 -> 7
magic_numbers=[1, 2, 4, 7, 13]

# ╔═╡ 65de40f0-3ab8-11eb-3638-974298cda546
function count_ones(diff_seq::Vector{Int})
	ones_seq = Vector{Int}()
	acc = 0
	for diff in diff_seq
		if diff == 1
			acc += 1
		else
			if acc != 0 
				push!(ones_seq, acc)
				acc = 0
			end
		end
	end
	if acc != 0
		push!(ones_seq, acc)
	end
	ones_seq
end

# ╔═╡ 3aaae090-3ab9-11eb-35e5-712a7510a029
part2 = reduce((x,y) ->x * magic_numbers[y], count_ones(diffs), init=1)

# ╔═╡ bc67c7c0-3abd-11eb-3b45-97f5499b0211
md"# Tests
## Tests 1"

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

# ╔═╡ 274a7382-3abe-11eb-3082-8739f546865a
md"## Tests2"

# ╔═╡ 85fda4e0-3abb-11eb-01ae-d5f536b0dc6f
begin
	test_diffs = prepare_diffs(test_jolts)
	test_counts = count_ones(test_diffs)
	comb = reduce((x,y) ->x * magic_numbers[y], test_counts, init=1)
	@assert comb == 8
end

# ╔═╡ 1f225b20-3abc-11eb-3ccd-99c1b94d055a
begin
	test_diffs2 = prepare_diffs(test_jolts2)
	test_counts2 = count_ones(test_diffs2)
	comb2 = reduce((x,y) ->x * magic_numbers[y], test_counts2, init=1)
	@assert comb2 == 19208
end

# ╔═╡ Cell order:
# ╠═95dfe8b0-3aab-11eb-318e-1785a9452ec2
# ╠═d3f59ff0-3aba-11eb-227b-59a7de53a275
# ╠═fdd622e2-3aab-11eb-32ac-d5de49fb8816
# ╠═d2c3b800-3aac-11eb-2ec5-53dc38c0b9ff
# ╠═2045f160-3aad-11eb-2a55-a314a0f99185
# ╠═61b4db30-3abb-11eb-064a-bf3a27daca27
# ╠═878e53d0-3ab7-11eb-2895-dd3912fca094
# ╠═09c41150-3ab8-11eb-2468-d5e81cbae3e5
# ╠═65de40f0-3ab8-11eb-3638-974298cda546
# ╠═3aaae090-3ab9-11eb-35e5-712a7510a029
# ╟─bc67c7c0-3abd-11eb-3b45-97f5499b0211
# ╠═50bdf610-3aaa-11eb-2a2a-27218ca0f28d
# ╠═f8a93730-3aab-11eb-18ee-2797cf36c08f
# ╟─274a7382-3abe-11eb-3082-8739f546865a
# ╠═85fda4e0-3abb-11eb-01ae-d5f536b0dc6f
# ╠═1f225b20-3abc-11eb-3ccd-99c1b94d055a
