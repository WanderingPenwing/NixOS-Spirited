{ config, pkgs, ... }:

{
	programs = {
		git = {
			enable = true;
			userName = "WanderingPenwing";
			userEmail = "wandering.penwing@gmail.com";
			extraConfig = {
				init.defaultBranch = "main";
			};
		};

		neovim = 
			let
				toLua = str: "lua << EOF\n${str}\nEOF\n";
				toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
			in
				{
				enable = true;
				extraLuaConfig = builtins.readFile ../apps/nvim/options.lua;

				viAlias = true;
				vimAlias = true;
				vimdiffAlias = true;

				extraPackages = with pkgs; [
					nil
					bash-language-server
					rust-analyzer
					lua-language-server
				];

				plugins = with pkgs.vimPlugins; [
					#	 		nvim-lspconfig
					# 
					#	 		comment-nvim
					{
						plugin = nvim-lspconfig;
						config = toLuaFile ../apps/nvim/plugin/lsp.lua; 
					}

					{
						plugin = nvim-cmp;
						config = toLuaFile ../apps/nvim/plugin/cmp.lua;
					}
					nvim-cmp
					cmp-buffer
					cmp-path
					cmp_luasnip
					cmp-nvim-lsp
					luasnip
					friendly-snippets

					{
						plugin = smear-cursor-nvim;
						config = toLua ''
							require('smear_cursor').enabled = true
							require('smear_cursor').setup({
								stiffness = 0.8,
								trailing_stiffness = 0.5,
								never_draw_over_target = false,
							})
						'';
					}

					mini-icons

					{
						plugin = mini-pairs;
						config = toLua ''
							require('mini.pairs').setup()
						'';
					}

					{
						plugin = lualine-nvim;
						config = toLuaFile ../apps/nvim/plugin/lualine.lua;
					}

					{
						plugin = which-key-nvim;
						config = toLua ''
					--require("which-key").show()
						'';
					}
					nvim-web-devicons

					{
						plugin = sonokai;
						config = toLua ''
					vim.g.sonokai_style = 'andromeda'
					vim.cmd.colorscheme("sonokai")
						'';
					}
					{
						plugin = undotree;
						config = toLua ''
					vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)	
						'';
					}
					{
						plugin = (nvim-treesitter.withPlugins (p: [
							p.tree-sitter-nix
							p.tree-sitter-bash
							p.tree-sitter-lua
							p.tree-sitter-python
							p.tree-sitter-json
							p.tree-sitter-rust
						]));
						config = toLuaFile ../apps/nvim/plugin/treesitter.lua;
					}
					{
						plugin = telescope-nvim;
						config = toLuaFile ../apps/nvim/plugin/telescope.lua;
					}

					{
						plugin = barbar-nvim;
						config = toLuaFile ../apps/nvim/plugin/barbar.lua;
					}

					telescope-fzf-native-nvim

					{
						plugin = dashboard-nvim;
						config = toLuaFile ../apps/nvim/plugin/dashboard.lua;
					}

					# plenary-nvim
					# {
					# 	plugin = yazi-nvim;
					# 	config = toLua ''
					# 		vim.keymap.set('n', '<leader>-', function()
					# 			require("yazi").yazi()
					# 		end)
					# 	'';
					# }
				];
			};
	};
	# gtk = {
	#   enable = true;
	#   theme = {
	#	 name = "Breeze-Dark";
	#	 package = pkgs.libsForQt5.breeze-gtk;
	#   };
	# };
	home.stateVersion = "24.05";
}
