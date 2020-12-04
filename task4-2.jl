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

# ╔═╡ 8cd8114e-360c-11eb-3efc-ed6e0bde6ce4
begin
	data_files = [
		"./data/input4.txt",
		"./data/input4-test.txt",
		"./data/input4-test-inv.txt",
		"./data/input4-test-val.txt"
		]
	data_file = data_files[1]
end

# ╔═╡ 13b0ae80-3603-11eb-34df-df14c72ee168
p_data_str = read_passport_str(data_file);

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

# ╔═╡ 10932790-3613-11eb-3181-47393692f3c9
function validate_hgt(hgt::RegexMatch, lo::Int64, hi::Int64)
	@assert hgt !== nothing
	
	height = parse(Int64,  hgt.captures[1])
	if !(lo <= height <= hi)
		return false
	end
	return true
end

# ╔═╡ 97e52bc0-360f-11eb-0ddc-5fe2e918c12c
function validate_year(year::AbstractString, from::Int64, to::Int64)
	m = match(r"\d\d\d\d", year)
	if m === nothing || m.match != year
		return false
	end
	y = parse(Int64, year)
	if !(from <= y <= to)
		return false
	end
	return true
end	

# ╔═╡ 77279360-3609-11eb-3bfd-29342b3eec1f
function validate_pass(pass::Dict)
	required_keys = ["ecl", "pid", "eyr", "hcl", "byr", "iyr", "hgt"]
	# "cid" not for now
	if !all(in.(required_keys, Ref(keys(pass))))
		return false
	end
	
	#years
	if !validate_year(pass["byr"], 1920, 2002)
		return false
	end
	
	if !validate_year(pass["iyr"], 2010, 2020)
		return false
	end
	
	if !validate_year(pass["eyr"], 2020, 2030)
		return false
	end
	
	# hgt
	m_cm = match(r"(\d*)cm", pass["hgt"])
	m_in = match(r"(\d*)in", pass["hgt"])
	
	if m_cm === nothing && m_in === nothing
		return false
	end
	
	if m_cm !== nothing
		if m_cm.match != pass["hgt"] || !validate_hgt(m_cm, 150, 193)
			return false
		end
	end
	
	if m_in !== nothing
		if m_in.match != pass["hgt"] || !validate_hgt(m_in, 59, 76)
			return false
		end
	end
	
	# hcl
	hcl = match(r"#[a-f0-9]{6}", pass["hcl"])
	if hcl === nothing || hcl.match != pass["hcl"]
		return false
	end
	
	# ecl
	eye_colors = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
	if !in(pass["ecl"], eye_colors)
		return false
	end
	
	# pid
	pid = match(r"\d{9}", pass["pid"])
	if pid === nothing || pid.match != pass["pid"]
		return false
	end
	
	return true
end

# ╔═╡ cf8e8990-360a-11eb-3093-4dcade721bcc
sum(validate_pass.(p_data_dict))

# ╔═╡ Cell order:
# ╠═dc8acad0-3602-11eb-3f10-47134ce39c40
# ╠═8cd8114e-360c-11eb-3efc-ed6e0bde6ce4
# ╠═13b0ae80-3603-11eb-34df-df14c72ee168
# ╟─5febf6b0-3608-11eb-348e-5f067b375a8a
# ╠═e8d084f0-3608-11eb-1108-370ffd33fc62
# ╠═77279360-3609-11eb-3bfd-29342b3eec1f
# ╠═10932790-3613-11eb-3181-47393692f3c9
# ╠═97e52bc0-360f-11eb-0ddc-5fe2e918c12c
# ╠═cf8e8990-360a-11eb-3093-4dcade721bcc
