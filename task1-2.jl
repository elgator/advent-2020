### A Pluto.jl notebook ###
# v0.12.15

using Markdown
using InteractiveUtils

# ╔═╡ 54e030a0-33e8-11eb-2a66-d540e0d34aab
using CSV

# ╔═╡ 2455ee60-33e9-11eb-1f8a-3f9f1ed13885
payments = CSV.read("./data/input1.txt"; header=["val1"]);

# ╔═╡ 2fcc2ae0-33ec-11eb-2beb-35656fe95518
payments1 = Matrix(payments);

# ╔═╡ e8ac61e0-33e9-11eb-08c5-b9f8d9fc14e1
begin
	triplets = []
	for m in payments1
		for n in payments1
			n >= m && continue
			l = 2020 - (n + m)
			l >= n && continue
			if in(l, payments1)
				push!(triplets, (n, m, l))
			end
		end
	end
	triplets
end

# ╔═╡ de8fda40-33ec-11eb-37e8-b5b3f31ff6e7
triplets[1][1] * triplets[1][2] * triplets[1][3]

# ╔═╡ Cell order:
# ╠═54e030a0-33e8-11eb-2a66-d540e0d34aab
# ╠═2455ee60-33e9-11eb-1f8a-3f9f1ed13885
# ╠═2fcc2ae0-33ec-11eb-2beb-35656fe95518
# ╠═e8ac61e0-33e9-11eb-08c5-b9f8d9fc14e1
# ╠═de8fda40-33ec-11eb-37e8-b5b3f31ff6e7
