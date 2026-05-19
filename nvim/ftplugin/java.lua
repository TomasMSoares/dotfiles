local home = os.getenv("HOME")
if not home then
  home = vim.fn.expand("~")
end

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = home .. '/.cache/jdtls/workspace/' .. project_name

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local jdtls_bin = vim.fn.stdpath("data") .. "/mason/bin/jdtls"

local config = {
  cmd = {
    jdtls_bin,
    "-data", workspace_dir,
    "--jvm-arg=-Djava.import.generatesMetadataFilesAtProjectRoot=false",
  },

  root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'pom.xml', 'build.gradle'}),
  capabilities = capabilities,
}

require('jdtls').start_or_attach(config)
