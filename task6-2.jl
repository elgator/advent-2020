### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ b63d8930-37b0-11eb-34dc-d93e73379bbc
forms = read("./data/input6.txt", String)

# ╔═╡ 4af0546e-37b3-11eb-109c-5d2100e5cd1c
test_str="abc

a
b
c

ab
ac

a
a
a
a

b"

# ╔═╡ c0e3fd20-37b4-11eb-26c5-0baac88e97a5
function count_answers(input)
	parsed = input |> x-> split(x, "\n\n") .|> 
	Set .|> x-> filter(!=('\n'), x) |> length
	sum(parsed)
end

# ╔═╡ d609d1d0-37b8-11eb-3ce2-3f6444000ce3
@assert count_answers(test_str) == 11

# ╔═╡ 182afd00-37b9-11eb-0cf5-0be300993c59
count_answers(forms)

# ╔═╡ d5f6fb32-37ba-11eb-0edd-4dfac12e9f35
function count_answers2(input)
	parsed = input |> x-> split(x, "\n\n") .|> x-> split(x, '\n') |>
	x-> filter(!=(""), x) .|> Set
	sum([length(intersect(group...)) for group in parsed])
end

# ╔═╡ ec2a6c20-37ba-11eb-12ad-8b4bd49d6bbc
@assert count_answers2(test_str) == 6

# ╔═╡ fbb46380-37ba-11eb-1677-0b2dc39b3735
count_answers2(forms)

# ╔═╡ Cell order:
# ╠═b63d8930-37b0-11eb-34dc-d93e73379bbc
# ╠═4af0546e-37b3-11eb-109c-5d2100e5cd1c
# ╠═c0e3fd20-37b4-11eb-26c5-0baac88e97a5
# ╠═d609d1d0-37b8-11eb-3ce2-3f6444000ce3
# ╠═182afd00-37b9-11eb-0cf5-0be300993c59
# ╠═d5f6fb32-37ba-11eb-0edd-4dfac12e9f35
# ╠═ec2a6c20-37ba-11eb-12ad-8b4bd49d6bbc
# ╠═fbb46380-37ba-11eb-1677-0b2dc39b3735
