### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ 99132aa0-3863-11eb-37ac-b9147571a942
function get_inner_bags(contents::AbstractString)
	bags = split(contents, ',')
	matches = [match(r"(\d{1,2}) ([a-z ]*) bag", bag) for bag in bags]
	
	inner_bags = Dict()
	for bag in matches
		if bag != nothing
			if bag.captures[2] in keys(inner_bags)
				error("double contents")
			end
			inner_bags[bag.captures[2]]= parse(Int, bag.captures[1])
		end
	end
	inner_bags
end

# ╔═╡ 8571f2c0-3862-11eb-0c53-07179a259591
struct Bag
	name
	contains::Dict
	contained_in::Set
end

# ╔═╡ 68780d90-3866-11eb-1c11-9302cee4ab18
function get_bags(rules)
	bags = Dict{String, Bag}()
	for rule in rules
		name = rule[1]
		if name in keys(bags)
			error("double definition")
		end
		bags[name]= Bag(name, Dict(get_inner_bags(rule[2])), Set([]))
	end
	bags
end

# ╔═╡ f24f3c60-386a-11eb-1ffb-2327da73e3d5
function reverse_bags(bags::Dict{String, Bag})::Dict{String, Bag}
	for outer_name in keys(bags)
		contents = bags[outer_name].contains
		for inner in keys(contents)
			push!(bags[inner].contained_in, outer_name)
		end
	end
	bags
end

# ╔═╡ f38b1060-386d-11eb-14d2-0f578d984281
function collect_outer(bags::Dict{String, Bag}, bag_name)
	if bags[bag_name].contained_in == Set([])
		return Set([])
	else
		c = bags[bag_name].contained_in
		for outer_name in bags[bag_name].contained_in
			union!(c, collect_outer(bags, outer_name))
		end
		return c
	end
end

# ╔═╡ 42709b90-3874-11eb-2c04-9b76dc7cf895
rules = split.(readlines("./data/input7.txt"), " bags contain ");

# ╔═╡ 7747fb60-3874-11eb-1086-3f32c57f3a08
bags = reverse_bags(get_bags(rules))

# ╔═╡ 87fdefa0-3874-11eb-12e5-0796dd2323aa
length(collect_outer(bags, "shiny gold"))

# ╔═╡ 1e07c6c0-3874-11eb-0db8-ff81e15ea6b4
md"# Test"

# ╔═╡ 01229ee0-3874-11eb-0ea1-9be322eb7573
test_str="light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.";

# ╔═╡ 0abb2210-3874-11eb-125b-cdafec9edf62
rules_test = split.(split(test_str, '\n'), " bags contain ");

# ╔═╡ 74eace50-3870-11eb-083e-853b81958316
bags_test = reverse_bags(get_bags(rules_test))

# ╔═╡ 353732a0-386e-11eb-3a83-4f937025fc35
@assert length(collect_outer(bags_test, "shiny gold")) == 4

# ╔═╡ Cell order:
# ╠═99132aa0-3863-11eb-37ac-b9147571a942
# ╠═8571f2c0-3862-11eb-0c53-07179a259591
# ╠═68780d90-3866-11eb-1c11-9302cee4ab18
# ╠═f24f3c60-386a-11eb-1ffb-2327da73e3d5
# ╠═f38b1060-386d-11eb-14d2-0f578d984281
# ╠═42709b90-3874-11eb-2c04-9b76dc7cf895
# ╠═7747fb60-3874-11eb-1086-3f32c57f3a08
# ╠═87fdefa0-3874-11eb-12e5-0796dd2323aa
# ╟─1e07c6c0-3874-11eb-0db8-ff81e15ea6b4
# ╠═01229ee0-3874-11eb-0ea1-9be322eb7573
# ╠═0abb2210-3874-11eb-125b-cdafec9edf62
# ╠═74eace50-3870-11eb-083e-853b81958316
# ╠═353732a0-386e-11eb-3a83-4f937025fc35
