### A Pluto.jl notebook ###
# v0.12.15

using Markdown
using InteractiveUtils

# ╔═╡ 29d02cf0-347c-11eb-1af7-8b64f3366adf
using DataStructures

# ╔═╡ 9223dc50-346f-11eb-0209-910472c1e473
lines = readlines("./data/input2.txt")

# ╔═╡ 96628580-3471-11eb-02c9-bf852c21165f
function parse_policy_rule(line)
	range, test_char, password = split(line)
	range_l, range_h = split(range, "-")
	range_l = parse(Int64, range_l)
	range_h = parse(Int64, range_h)
	test_char = test_char[begin]
	range_l, range_h, test_char, password
end

# ╔═╡ 60346090-3477-11eb-2383-6d978ed2d51b
function validate(range_l, range_h, test_char, password)
	@assert range_l <= range_h
	char_counts = counter(password)
	range_l <= char_counts[test_char] <= range_h
end

# ╔═╡ 8a6cded2-3479-11eb-060e-072f2718c56e
begin
	c = 0
	for line in lines
		global c
		if validate(parse_policy_rule(line)...)
			c +=1
		end
	end
	c
end

# ╔═╡ Cell order:
# ╠═29d02cf0-347c-11eb-1af7-8b64f3366adf
# ╠═9223dc50-346f-11eb-0209-910472c1e473
# ╠═96628580-3471-11eb-02c9-bf852c21165f
# ╠═60346090-3477-11eb-2383-6d978ed2d51b
# ╠═8a6cded2-3479-11eb-060e-072f2718c56e
