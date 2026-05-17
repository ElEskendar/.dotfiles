#!/usr/bin/fish

# set the languages you want to install over here
set treesitters tree-sitter/tree-sitter-python tris203/tree-sitter-razor tree-sitter/tree-sitter-json tree-sitter/tree-sitter-css tree-sitter/tree-sitter-html tree-sitter/tree-sitter-cpp tree-sitter/tree-sitter-c-sharp
set languages python razor json css html cpp cs

# create temp directory

echo Creating temp directory...
set TEMP_DIR (mktemp -d)

# check for neovim config
if test -d ~/.config/nvim
	for i in (seq 1 (count $treesitters))
		cd $TEMP_DIR
		set url $treesitters[$i]
		set language $languages[$i]

		# clone git repository
		git clone "https://github.com/$url"

		set treesitter_folder (string split "/" $url)[2]
		echo going too $treesitter_folder
		
		cd $treesitter_folder

		echo (ls)
		# language specific problemes
		if string match $language "cs"
			echo Csharp specific renaming all c_sharp functions into cs
			sed -i -e "s/c_sharp/cs/g" src/parser.c src/scanner.c
		end

		# compile treesitter
		echo Compiling treesitter for $language...
		make

		# check if parser folder exists and if yes, check if treesitter.so already exists and delete it
		echo Cleaning current neovim config
		if not test -d ~/.config/nvim/parser/
			mkdir parser
		end
		if test -e ~/.config/nvim/parser/$language.so
			echo removing parser for $language
			rm ~/.config/nvim/parser/$language.so
		end
		# same things for queries
		if not test -d ~/.config/nvim/queries/
			mkdir parser
		end
		
		if test -d ~/.config/nvim/queries/$language
			echo removing queries for $language
			rm -r ~/.config/nvim/queries/$language
		end

		# move parser too directory
		echo installing $language.so
		mv lib$treesitter_folder.so ~/.config/nvim/parser/$language.so
		mv queries ~/.config/nvim/queries/$language

		echo "Done installing treesitter for $language"
	end
else
	echo nvim config directory does not exists, exiting... >&2
end
 
function cleanup
	rm -fr $TEMP_DIR
end

trap cleanup EXIT
