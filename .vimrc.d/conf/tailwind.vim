lua << EOF
require("tailwind-highlight").setup({
  -- Automatically attach to these filetypes
  filetypes = { "html", "css", "javascript", "typescript", "javascriptreact", "typescriptreact" },
  -- Optional: show subtle highlights instead of full color blocks
  mode = "bg",  -- "fg" for text color, "bg" for background color
})
EOF
