### A Pluto.jl notebook ###
# v0.12.15

using Markdown
using InteractiveUtils

# ╔═╡ 72342510-33d6-11eb-35d9-e79acc2258b0
using CSV, DataFrames

# ╔═╡ 03f73452-33e2-11eb-00e3-81951a7975f4
df = CSV.read("./data/input1.txt"; header=[:val1]);

# ╔═╡ 3917d220-33e2-11eb-00c6-33a51f11aecf
df["val2"] = 2020 .- df["val1"];

# ╔═╡ b3f70d30-33e2-11eb-165c-ab7d22291768
df["match"] = in.(df["val2"], Ref(df["val1"]));

# ╔═╡ 14dd91f0-33e3-11eb-225c-010bdbf4d229
filtered = df[(df["match"] .== true) .& (df["val1"] .< df["val2"]), :]

# ╔═╡ 53b31f20-33e4-11eb-3f20-07fab88ed997
filtered[1, "val1"] * filtered[1, "val2"]

# ╔═╡ Cell order:
# ╠═72342510-33d6-11eb-35d9-e79acc2258b0
# ╠═03f73452-33e2-11eb-00e3-81951a7975f4
# ╠═3917d220-33e2-11eb-00c6-33a51f11aecf
# ╠═b3f70d30-33e2-11eb-165c-ab7d22291768
# ╠═14dd91f0-33e3-11eb-225c-010bdbf4d229
# ╠═53b31f20-33e4-11eb-3f20-07fab88ed997
