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
function main_cycle(rulebook)
	evaluated = Dict()

	while length(rulebook) > 0
		changes = eval_one_rule!(rulebook, evaluated)
		if !changes
			break
		end
	end
	evaluated
end

# ╔═╡ 72ce3e20-45dd-11eb-298a-e5d07836f2a7
function check_message(msg, rule_42, rule_31)
	# try to iteratively match rule31 to the end of the msg
	count31 = 0
	while true
		m = nothing
		for variant in rule_31
			m = match(variant * Regex("\$"), msg)
			if m != nothing
				count31 += 1
				msg = msg[1:m.offset-1]
				break
			end
		end
		if m == nothing break end
	end
	
	if count31 == 0	return false end
	
	# try to iteratively match rule42 to the end of the msg
	count42 = 0
	while true
		m = nothing
		for variant in rule_42
			m = match(variant * Regex("\$"), msg)
			if m != nothing
				count42 += 1
				msg = msg[1:m.offset-1]
				break
			end
		end
		if m == nothing break end
	end
	if count42 == 0 return false end
	if count42 < count31 + 1 return false end
	if msg !="" return false end
	
	return true
end

# ╔═╡ aa8a9920-4232-11eb-243c-a574ba4acc0c
task_rules_str, task_msg_str = split(read("./data/input19.txt", String), "\n\n")

# ╔═╡ 9c953910-45e3-11eb-1887-396bb742934a
task_msgs =  split(task_msg_str, '\n', keepempty=false)

# ╔═╡ 08ccfff0-4233-11eb-1a72-abda4e7968a4
begin
	task_rules = Dict(parse_row.(split(task_rules_str, '\n', keepempty=false)))
	pop!(task_rules, "0")
	pop!(task_rules, "11")
	pop!(task_rules, "8")
end

# ╔═╡ 505b2d10-4233-11eb-3c65-056329e3c06a
task_rule0 = main_cycle(task_rules)

# ╔═╡ 352dae80-45dc-11eb-069a-8f7e191dc3f5
length(task_rule0["42"]), length(task_rule0["31"]) # 128, 128

# ╔═╡ 69f1ad60-45dc-11eb-0370-d161ec6d81ee
in.(task_rule0["31"], Ref(task_rule0["42"])) |> sum # 0, no intersections

# ╔═╡ 586997de-45e3-11eb-0c53-49c7e3ba74d5
part2 = check_message.(task_msgs, Ref(task_rule0["42"]), Ref(task_rule0["31"])) |> sum

# ╔═╡ de293f70-45e3-11eb-3b5e-239e39531e86
md"# Tests"

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
test_rule0 = main_cycle(test_rules)

# ╔═╡ c89f66e0-45e1-11eb-364f-d9e2fcb042ba
begin
	good_test_1 = task_rule0["42"][18]*task_rule0["42"][11]*task_rule0["31"][56]
	bad_test_1 = task_rule0["42"][18]*task_rule0["42"][11]*task_rule0["31"][56]*"ss"
	bad_test_2 = "ss"*task_rule0["42"][18]*task_rule0["42"][11]*task_rule0["31"][56]
	good_test_2 = task_rule0["42"][30]*task_rule0["42"][28]*task_rule0["42"][120]*task_rule0["31"][36]
	good_test_3 = task_rule0["42"][30]*task_rule0["42"][28]*task_rule0["42"][120]*task_rule0["31"][36]*task_rule0["31"][50]
	bad_test_3 = task_rule0["42"][28]*task_rule0["42"][120]*task_rule0["31"][36]*task_rule0["31"][50]
end

# ╔═╡ 7846edf0-45df-11eb-1227-c165b1e3e611
begin
	@assert check_message(good_test_1, task_rule0["42"], task_rule0["31"]) == true
	@assert check_message(good_test_2, task_rule0["42"], task_rule0["31"]) == true
	@assert check_message(good_test_3, task_rule0["42"], task_rule0["31"]) == true
	@assert check_message(bad_test_1, task_rule0["42"], task_rule0["31"]) == false
	@assert check_message(bad_test_2, task_rule0["42"], task_rule0["31"]) == false
	@assert check_message(bad_test_3, task_rule0["42"], task_rule0["31"]) == false
end

# ╔═╡ Cell order:
# ╠═31051c50-421f-11eb-29d0-abb83b489bbf
# ╠═b69f2890-4221-11eb-1bbc-bd2115155fef
# ╠═071216ae-443a-11eb-10ff-f93db7b0bd04
# ╠═3c00acc0-4231-11eb-161c-e5677eb6a9fa
# ╠═72ce3e20-45dd-11eb-298a-e5d07836f2a7
# ╠═aa8a9920-4232-11eb-243c-a574ba4acc0c
# ╠═9c953910-45e3-11eb-1887-396bb742934a
# ╠═08ccfff0-4233-11eb-1a72-abda4e7968a4
# ╠═505b2d10-4233-11eb-3c65-056329e3c06a
# ╠═352dae80-45dc-11eb-069a-8f7e191dc3f5
# ╠═69f1ad60-45dc-11eb-0370-d161ec6d81ee
# ╠═586997de-45e3-11eb-0c53-49c7e3ba74d5
# ╟─de293f70-45e3-11eb-3b5e-239e39531e86
# ╠═10d13710-41fd-11eb-0814-5b22fdbdac53
# ╠═2a7aa1d0-4232-11eb-0da2-7d8de6cb6e11
# ╠═5d83aa40-4232-11eb-0c68-eb040d53330b
# ╠═07f17990-421e-11eb-2921-d98cf8168450
# ╠═c99ce9f0-4221-11eb-36f7-7f52d76fcdd0
# ╠═a90c50d0-4222-11eb-3795-434828f49931
# ╠═c89f66e0-45e1-11eb-364f-d9e2fcb042ba
# ╠═7846edf0-45df-11eb-1227-c165b1e3e611
