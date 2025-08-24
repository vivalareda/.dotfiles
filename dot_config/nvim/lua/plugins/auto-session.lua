return {
  "rmagatti/auto-session",
  lazy = false,

  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    auto_session_enabled = true,
    auto_save_enabled = true,
    auto_restore_enabled = false,
    auto_restore_last_session = false,
    -- allowed_dirs = { '~/github', '~/Document/github' },
    -- log_level = 'debug',
  },
}
