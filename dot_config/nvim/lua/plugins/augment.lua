return {
  'augmentcode/augment.vim',
  config = function()
    vim.g.augment_workspace_folders = {'~/github/ocr-text-toolkit-frontend/', '~/github/BookScanOrderConvex/', '~/github/pfe/'}
    vim.g.augment_disable_completions = true
  end
}
