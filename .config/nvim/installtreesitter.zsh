#!/bin/zsh

# list of treesitters github urls
treesitters=("tree-sitter/tree-sitter-python" "tree-sitter/tree-sitter-json" "tree-sitter/tree-sitter-css" "tree-sitter/tree-sitter-html" "tree-sitter/tree-sitter-cpp" "tree-sitter/tree-sitter-ocaml")

# list of languages installed, correspond too the treesitters on top
languages=("python" "json" "css" "html" "cpp" "ocaml")

echo Creating temp directory...
temp_dir=$(mktemp -d)

# check if config file exist
if [ -d ~/.config/nvim ]; then
	cd $temp_dir
	mkdir ~/.config/nvim/parser
	mkdir ~/.config/nvim/queries
	rm -rf ~/.config/nvim/parser/*
	rm -rf ~/.config/nvim/queries/*
	# loop all of the treesitters
	for i in {1..${#treesitters}}; do
		# compile treesitter
		folder_name=${treesitters[i]#*/}
		git clone "https://github.com/${treesitters[i]}"
		cd $folder_name
		make
		mv "lib${folder_name}.so" ~/.config/nvim/parser/${languages[i]}.so
		mv queries ~/.config/nvim/queries/${languages[i]}
		cd ..
	done
else
	echo create nvim config directory first, existing...
fi

rm -fr $temp_dir
