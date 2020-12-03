### A Pluto.jl notebook ###
# v0.12.15

using Markdown
using InteractiveUtils

# ╔═╡ 5875d700-3547-11eb-1e71-ffb37609c56c
function read_hash_dot_matrix(file_name)
	init_line = readline(file_name)
	line_size = length(init_line)
	hd_matrix = zeros(Int64, 1, line_size)
	
	for line in eachline(file_name)
		hd_matrix = vcat(hd_matrix, [(x=='#' ? 1 : 0)  for x in line]')
	end
	hd_matrix[2:end, :]
end

# ╔═╡ 75a9af90-3551-11eb-2123-c91da42ad4aa
tree_map = read_hash_dot_matrix("./data/input3.txt")

# ╔═╡ 19fc2f00-3552-11eb-1f03-a7e3136b1a3d
size(tree_map)

# ╔═╡ 2f95db80-3553-11eb-1546-4174322a3fa4
function count_trees(i_move, j_move)
	tree_count = 0
	i = j = 1
	n, m = size(tree_map)
	while true
		i += i_move
		if i > n break end
		j += j_move
		if j > m j -= m end
		if tree_map[i,j] == 1 tree_count += 1 end
	end
	tree_count
end

# ╔═╡ bf535af0-3557-11eb-31da-673f34e9ee47
count_trees(1, 3)

# ╔═╡ Cell order:
# ╠═5875d700-3547-11eb-1e71-ffb37609c56c
# ╠═75a9af90-3551-11eb-2123-c91da42ad4aa
# ╠═19fc2f00-3552-11eb-1f03-a7e3136b1a3d
# ╠═2f95db80-3553-11eb-1546-4174322a3fa4
# ╠═bf535af0-3557-11eb-31da-673f34e9ee47
