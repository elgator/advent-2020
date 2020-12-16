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
		(;name=name, bounds=[(f1_lo, f1_hi), (f2_lo, f2_hi)])
	end
	
	function parse_line(line)
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

# ╔═╡ 88a08092-3f6c-11eb-26a3-234a1eabc102
begin
	function validate(x::T where T<:Integer, rules::Array)
		valid = false
		for rule in rules
			for bounds in rule[:bounds]
				lo, hi = bounds
				valid = valid || (lo <= x <= hi)
			end
		end
		valid
	end
	
	function validate(x::T where T<:Integer, 
			rule_no::T1 where T1<:Integer, rules::Array)
		valid = false
		rule = rules[rule_no]
		for bounds in rule[:bounds]
			lo, hi = bounds
			valid = valid || (lo <= x <= hi)
		end
		valid
	end
	
	function validate(ticket::Array{T,1} where T<:Integer, rules::Array)
		ticket |> field->validate.(field, Ref(rules)) |> all
	end		
end

# ╔═╡ a9ed0a20-3f80-11eb-2926-19f599837b3b
begin
	function guess_fields(tickets::Array{Array{T,1},1} where T<:Integer, rules)
		
		l = length(rules)
		rule_guesses = ones(Int8, (l,l))
		# rule -> boolean Matrix rule x field

		
		for ticket in tickets
			for rule_no in 1:l
				for field_pos in 1:l
					field_val = ticket[field_pos]
					if !validate(field_val, rule_no, rules)
						 rule_guesses[rule_no, field_pos] = 0
					end
				end
			end
		end
		
		rule_guesses
	end
	
	
	function remove_ones!(guesses)
		l = first(size(guesses))
		for i in 1:l
			if sum(guesses[i, :]) == 1
				idx = only(findall(==(1), guesses[i, :]))
				guesses[:, idx] .= 0
				guesses[i, idx] = 1
			end
		end
	end
	
	function reason!(guesses)
		before = sum(guesses)
        i = 1
		while true
			remove_ones!(guesses)
			now = sum(guesses)
			if now == before
				break
			end
			before = now
		end
		guesses
	end
	
end

# ╔═╡ 7081c4f0-3f6d-11eb-2983-77f7c346d2f0
task_str = read("./data/input16.txt", String)

# ╔═╡ 78740e00-3f74-11eb-0612-1f4395311d41
rules, ticket, nearby = parse_input(task_str)

# ╔═╡ 8bf3f7b0-3f74-11eb-1be8-cd860a5adc20
filtered =  filter(x->validate(x, rules), nearby)

# ╔═╡ df5a2e90-3fb2-11eb-3417-8d935dbba21d
begin
	guesses_wo_errors = guess_fields(filtered, rules)
	solution = reason!(guesses_wo_errors)
	
	# map rule idx to field idx
	idxs_rules_of_interest = [i for (i, rule) in enumerate(rules) 
		if split(rule[:name])[1] == "departure"]
	idxs_fields_of_interest = [only(findall(==(1), solution[row, :])) 
		for row in idxs_rules_of_interest]
	
	prod(ticket[idxs_fields_of_interest])
end

# ╔═╡ Cell order:
# ╠═f2fdde6e-3f66-11eb-12b0-1ffe09b1f8e4
# ╠═88a08092-3f6c-11eb-26a3-234a1eabc102
# ╠═a9ed0a20-3f80-11eb-2926-19f599837b3b
# ╠═7081c4f0-3f6d-11eb-2983-77f7c346d2f0
# ╠═78740e00-3f74-11eb-0612-1f4395311d41
# ╠═8bf3f7b0-3f74-11eb-1be8-cd860a5adc20
# ╠═df5a2e90-3fb2-11eb-3417-8d935dbba21d
