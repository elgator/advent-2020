### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ 31051c50-421f-11eb-29d0-abb83b489bbf
function parse_row(line)
	head, tail = split(line, ": ")
	
	halves = split(tail, " | ")
	halves = replace.(halves, r"\"(\w)\"" => s"\1")
	head, halves
end

# ╔═╡ 071216ae-443a-11eb-10ff-f93db7b0bd04
function merge_lists(a, b)
	merged = []
	if length(a) == 0
		return b
	end
	if length(b) == 0
		return a
	end
	for n in a
		for m in b
			push!(merged, n * m)
		end
	end
	merged
end

# ╔═╡ b69f2890-4221-11eb-1bbc-bd2115155fef
function eval_one_rule!(rulebook, evald)
	@show "-----------"
	changes = false
	for (rule_key, rule) in rulebook
		rule_ids = [collect(eachmatch(r"\d+", variant, overlap=false)) for variant in rule]
		rule_ids = map(variant->map(y->y.match, variant), rule_ids)
		@show rule_ids
		all_keys = true
		all_evald =  true
		for variant in rule_ids
			if length(variant) != 0 # a number found
				all_evald = false
			end
			if !all(in.(variant, Ref(keys(evald))))
				all_keys = false
			end
		end
				
		if all_evald
			pop!(rulebook, rule_key)
			evald[rule_key] = deepcopy(rule)
			return true
		end
		
		if all_keys
			result = []
			for variant in rule_ids
				left = []
				for id in variant
					left = merge_lists(left, evald[id])
				end
				result = vcat(result, left)
			end
			pop!(rulebook, rule_key)
			evald[rule_key] = deepcopy(result)
			return true	
		end
	end
	changes
end
	

# ╔═╡ 3c00acc0-4231-11eb-161c-e5677eb6a9fa
function main_cycle(rule_id, rulebook)
	evaluated = Dict()

	while length(rulebook) > 0
		changes = eval_one_rule!(rulebook, evaluated)
		if !changes
			error("not found")
		end
	end
	evaluated[rule_id]
end

# ╔═╡ aa8a9920-4232-11eb-243c-a574ba4acc0c
task_rules_str, task_msg_str = split(read("./data/input19.txt", String), "\n\n")

# ╔═╡ 08ccfff0-4233-11eb-1a72-abda4e7968a4
task_rules = Dict(parse_row.(split(task_rules_str, '\n', keepempty=false)))

# ╔═╡ 505b2d10-4233-11eb-3c65-056329e3c06a
task_rule0 = main_cycle("0", task_rules)

# ╔═╡ 5d443360-456b-11eb-2f0e-6136bbc88663
part1 = in.(split(task_msg_str), Ref(task_rule0)) |> sum

# ╔═╡ 10d13710-41fd-11eb-0814-5b22fdbdac53
test_str=
"""0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: \"a\"
5: \"b\""""

# ╔═╡ 2a7aa1d0-4232-11eb-0da2-7d8de6cb6e11
test_messages=
"""ababbb
bababa
abbbab
aaabbb
aaaabbb"""

# ╔═╡ 5d83aa40-4232-11eb-0c68-eb040d53330b
test_message_rows=split(test_messages, '\n', keepempty=false)

# ╔═╡ 07f17990-421e-11eb-2921-d98cf8168450
test_rows = split(test_str, '\n', keepempty=false)

# ╔═╡ c99ce9f0-4221-11eb-36f7-7f52d76fcdd0
test_rules = Dict{String,Array{Any,1}}(parse_row.(test_rows))

# ╔═╡ a90c50d0-4222-11eb-3795-434828f49931
test_rule0 = main_cycle("0", test_rules)

# ╔═╡ 6ad69d60-4232-11eb-2959-67f3e794421c
@assert in.(test_message_rows, Ref(test_rule0)) |> sum == 2

# ╔═╡ Cell order:
# ╠═31051c50-421f-11eb-29d0-abb83b489bbf
# ╠═b69f2890-4221-11eb-1bbc-bd2115155fef
# ╠═071216ae-443a-11eb-10ff-f93db7b0bd04
# ╠═3c00acc0-4231-11eb-161c-e5677eb6a9fa
# ╠═aa8a9920-4232-11eb-243c-a574ba4acc0c
# ╠═08ccfff0-4233-11eb-1a72-abda4e7968a4
# ╠═505b2d10-4233-11eb-3c65-056329e3c06a
# ╠═5d443360-456b-11eb-2f0e-6136bbc88663
# ╠═10d13710-41fd-11eb-0814-5b22fdbdac53
# ╠═2a7aa1d0-4232-11eb-0da2-7d8de6cb6e11
# ╠═5d83aa40-4232-11eb-0c68-eb040d53330b
# ╠═07f17990-421e-11eb-2921-d98cf8168450
# ╠═c99ce9f0-4221-11eb-36f7-7f52d76fcdd0
# ╠═a90c50d0-4222-11eb-3795-434828f49931
# ╠═6ad69d60-4232-11eb-2959-67f3e794421c
