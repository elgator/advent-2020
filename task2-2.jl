### A Pluto.jl notebook ###
# v0.12.15

using Markdown
using InteractiveUtils

# ╔═╡ 78387600-347b-11eb-29f7-739b3496961a
lines = readlines("./data/input2.txt")

# ╔═╡ 8fc360a0-347b-11eb-07d8-7bd065befe4c
function parse_policy_rule(line)
	range, test_char, password = split(line)
	range_l, range_h = split(range, "-")
	range_l = parse(Int64, range_l)
	range_h = parse(Int64, range_h)
	test_char = test_char[begin]
	range_l, range_h, test_char, password
end

# ╔═╡ 95290f90-347b-11eb-014e-bb747479cff1
function validate(pos1, pos2, test_char, password)
	(password[pos1] == test_char) ⊻ (password[pos2] == test_char)
end

# ╔═╡ 992124c0-347b-11eb-100a-ebbfdf2ab256
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
# ╠═78387600-347b-11eb-29f7-739b3496961a
# ╠═8fc360a0-347b-11eb-07d8-7bd065befe4c
# ╠═95290f90-347b-11eb-014e-bb747479cff1
# ╠═992124c0-347b-11eb-100a-ebbfdf2ab256
