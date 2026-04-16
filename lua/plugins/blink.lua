return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    opts.completion = opts.completion or {}
    opts.completion.menu = opts.completion.menu or {}

    -- Disable automatic popup
    opts.completion.menu.auto_show = false

    -- Optional: disable ghost text too (the inline gray suggestion)
    opts.completion.ghost_text = opts.completion.ghost_text or {}
    opts.completion.ghost_text.enabled = false

    return opts
  end,
}
