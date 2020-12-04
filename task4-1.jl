### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ dc8acad0-3602-11eb-3f10-47134ce39c40
function read_passport_str(file)
	passports = Array{String, 1}()
	passport = ""
	for line in eachline(file)
		if line !="" 
			if passport != "" passport *= " " end
			passport *= line
		else
			push!(passports, passport)
			passport = ""
		end
	end
	if passport != "" push!(passports, passport) end
	passports
end

# ╔═╡ 13b0ae80-3603-11eb-34df-df14c72ee168
# "./data/input4-test.txt"
p_data_str = read_passport_str("./data/input4.txt");

# ╔═╡ 5febf6b0-3608-11eb-348e-5f067b375a8a
function parse_passports(passports::Array{String, 1})
	parsed_passports = Array{Dict, 1}()
	for pass in passports
		parsed = Dict(split.(split(pass), ":"))
		push!(parsed_passports, parsed)
	end
	parsed_passports
end

# ╔═╡ e8d084f0-3608-11eb-1108-370ffd33fc62
p_data_dict = parse_passports(p_data_str)

# ╔═╡ 77279360-3609-11eb-3bfd-29342b3eec1f
function validate_pass(pass::Dict)
	required_keys = ["ecl", "pid", "eyr", "hcl", "byr", "iyr", "hgt"]
	# "cid" not for now
	all(in.(required_keys, Ref(keys(pass))))
end

# ╔═╡ cf8e8990-360a-11eb-3093-4dcade721bcc
sum(validate_pass.(p_data_dict))

# ╔═╡ Cell order:
# ╠═dc8acad0-3602-11eb-3f10-47134ce39c40
# ╠═13b0ae80-3603-11eb-34df-df14c72ee168
# ╠═5febf6b0-3608-11eb-348e-5f067b375a8a
# ╠═e8d084f0-3608-11eb-1108-370ffd33fc62
# ╠═77279360-3609-11eb-3bfd-29342b3eec1f
# ╠═cf8e8990-360a-11eb-3093-4dcade721bcc
