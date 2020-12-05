### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ e51c5680-36cc-11eb-372a-17f2255a6a2c
passes = readlines("./data/input5.txt")

# ╔═╡ 75888952-36cd-11eb-13f8-1bd2cbfe74ac
function pass2seat_ID(pass::String)
	@assert length(pass) == 10
	
	pass_bin = pass |> x->replace(x, 'F'=>'0') |> x->replace(x, 'B'=>'1') |>
	x->replace(x, 'L' =>'0') |> x->replace(x, 'R'=>'1')
	
	code = parse(Int, pass_bin; base=2)
	row = parse(Int, pass_bin[begin:7]; base=2)
	seat = parse(Int, pass_bin[7:end]; base=2)
	return row, seat, code
end

# ╔═╡ b8e44570-36cf-11eb-3f9d-4f6e33225ac9
begin
	@assert pass2seat_ID("BFFFBBFRRR") == (70, 7, 567)
	@assert pass2seat_ID("FBFBBFFRLR") == (44, 5, 357)
	@assert pass2seat_ID("FFFBBBFRRR") == (14, 7, 119)
	@assert pass2seat_ID("BBFFBBFRLL") == (102, 4, 820)
end

# ╔═╡ 1c1b7b80-36d1-11eb-2251-259cc3b412a5
pass2seat_ID.(passes) |> codes -> [x[3] for x in codes] |> x->max(x...)

# ╔═╡ Cell order:
# ╠═e51c5680-36cc-11eb-372a-17f2255a6a2c
# ╠═75888952-36cd-11eb-13f8-1bd2cbfe74ac
# ╠═b8e44570-36cf-11eb-3f9d-4f6e33225ac9
# ╠═1c1b7b80-36d1-11eb-2251-259cc3b412a5
