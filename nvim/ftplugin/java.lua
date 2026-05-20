local home = os.getenv("HOME")
local mason_path = home .. "/.local/share/nvim/mason/packages/jdtls"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = home .. '/.cache/jdtls/workspace/' .. project_name

local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",

    -- Mason-specific paths
    "-jar", vim.fn.glob(mason_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration", mason_path .. "/config_linux",
    "-data", workspace_dir
  },
  root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'pom.xml'}),
}

require('jdtls').start_or_attach(config)

