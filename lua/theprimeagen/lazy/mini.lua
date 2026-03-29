return{

    "echasnovski/mini.nvim",
    config = function()
        require("mini.test").setup()
    end,
  lazy = false,  -- ensures it's loaded immediately
}

