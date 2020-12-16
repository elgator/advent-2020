### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ f2fdde6e-3f66-11eb-12b0-1ffe09b1f8e4
begin
	function parse_rule(rule)
		m = match(r"^(.*): (\d*)-(\d*) or (\d*)-(\d*)$", rule)
		name, f1_lo, f1_hi, f2_lo, f2_hi = Tuple(m.captures)
		f1_lo = parse(Int16, f1_lo)
		f1_hi = parse(Int16, f1_hi)
		f2_lo = parse(Int16, f2_lo)
		f2_hi = parse(Int16, f2_hi)
		(;name=name, bounds=(f1_lo, f1_hi, f2_lo, f2_hi))
	end
	
	function parse_line(line)
		@show line
		split(line, ',') .|> (x->parse(Int16, x))
	end
	
	function parse_input(input_str)
		rules, ticket, nearby = split(input_str, "\n\n", keepempty=false)
		rules = split(rules, '\n', keepempty=false) .|> parse_rule
		ticket = split(ticket, '\n', keepempty=false)[2] |> parse_line
		nearby = split(nearby, '\n', keepempty=false)[2:end] .|> parse_line
		rules, ticket, nearby
	end
end

# ╔═╡ c1724e40-3f66-11eb-02e2-af017ca5b1fa
parse_rule("class: 1-3 or 5-7")

# ╔═╡ 88a08092-3f6c-11eb-26a3-234a1eabc102
begin
	function validate(x::T where T<:Integer, rules::Array)
		valid = false
		for rule in rules
			f1_lo, f1_hi, f2_lo, f2_hi = rule[:bounds]
			valid = valid || (f1_lo <= x <= f1_hi) || (f2_lo <= x <= f2_hi)
		end
		valid
	end
	
	function validate(ticket::Array{T,1} where T<:Integer, rules::Array)
		counter = 0
		for field in ticket
			if !validate(field, rules)
				counter += field
			end
		end
		counter
	end		
end

# ╔═╡ 7081c4f0-3f6d-11eb-2983-77f7c346d2f0
task_str = read("./data/input16.txt", String)

# ╔═╡ 78740e00-3f74-11eb-0612-1f4395311d41
rules, ticket, nearby = parse_input(task_str)

# ╔═╡ 8bf3f7b0-3f74-11eb-1be8-cd860a5adc20
part1 = nearby .|> (x->validate(x, rules)) |> sum

# ╔═╡ e2147af0-3f62-11eb-061b-dba532ecdff2
test_str1 =
"""class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50

your ticket:
7,1,14

nearby tickets:
7,3,47
40,4,50
55,2,20
38,6,12"""

# ╔═╡ 08200dd0-3f64-11eb-11ba-550417726514
test_rules1, test_ticket1, test_nearby1 = parse_input(test_str1)

# ╔═╡ 730c8e80-3f6d-11eb-30e6-85cda3cdf102
begin
	@assert validate(6, test_rules1) == true
	@assert validate(7, test_rules1) == true
	@assert validate(4, test_rules1) == false
	@assert validate(55, test_rules1) == false
	@assert validate(12, test_rules1) == false
end

# ╔═╡ 2418d8e0-3f6f-11eb-3cf3-5dc0aafe1a2c
begin
	@assert validate([7,3,47], test_rules1) == 0
	@assert validate([40,4,50], test_rules1) == 4
	@assert validate([55,2,20], test_rules1) == 55
	@assert validate([38,6,12], test_rules1) == 12
end

# ╔═╡ 98b831a0-3f6f-11eb-3167-f17071ce5255
@assert test_nearby1 .|> (x->validate(x, test_rules1)) |> sum == 71

# ╔═╡ Cell order:
# ╠═f2fdde6e-3f66-11eb-12b0-1ffe09b1f8e4
# ╠═c1724e40-3f66-11eb-02e2-af017ca5b1fa
# ╠═88a08092-3f6c-11eb-26a3-234a1eabc102
# ╠═7081c4f0-3f6d-11eb-2983-77f7c346d2f0
# ╠═78740e00-3f74-11eb-0612-1f4395311d41
# ╠═8bf3f7b0-3f74-11eb-1be8-cd860a5adc20
# ╠═e2147af0-3f62-11eb-061b-dba532ecdff2
# ╠═08200dd0-3f64-11eb-11ba-550417726514
# ╠═730c8e80-3f6d-11eb-30e6-85cda3cdf102
# ╠═2418d8e0-3f6f-11eb-3cf3-5dc0aafe1a2c
# ╠═98b831a0-3f6f-11eb-3167-f17071ce5255
