-- lua/plugins/dap.lua
return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
  },
  event = "VeryLazy",
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    require("nvim-dap-virtual-text").setup()
    dapui.setup()

    ------------------------------------------------------------------
    -- Python: debugpy adapter & configurations
    ------------------------------------------------------------------

    -- Detect project venv automatically
    local function get_python_path()
      local cwd = vim.fn.getcwd()

      -- 若專案根目錄有 ./venv/bin/python
      if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
        return cwd .. "/venv/bin/python"
      end

      -- 若專案根目錄有 ./.venv/bin/python
      if vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
        return cwd .. "/.venv/bin/python"
      end

      -- 若你習慣用 Python 工具建立 venv（pyproject.toml 也支援）

      -- 最後 fallback 到系統 Python
      return vim.fn.exepath("python3")
    end


    -- DAP Adapter
    dap.adapters.debugpy = {
      type = "executable",
      command = get_python_path(),     -- 這裡用的是專案自己的 python！
      args = { "-m", "debugpy.adapter" },
    }

    dap.configurations.python = {
      {
        type = "debugpy",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        pythonPath = get_python_path,  -- 讓被 debug 的程式也跑在專案 venv
      },
    }

    ------------------------------------------------------------------
    -- Dap and UI（你原本的設定保留）
    ------------------------------------------------------------------
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, {
        noremap = true,
        silent = true,
        desc = desc,
      })
    end

    -- Keymaps（照你原本的）
    map("n", "<F5>", dap.continue, "DAP: continue")
    map("n", "<F10>", dap.step_over, "DAP: step over")
    map("n", "<F11>", dap.step_into, "DAP: step into")
    map("n", "<S-F11>", dap.step_out, "DAP: step out")

    map("n", "<leader>db", dap.toggle_breakpoint, "DAP: toggle breakpoint")
    map("n", "<leader>dB", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, "DAP: conditional breakpoint")
    map("n", "<leader>dc", dap.continue, "DAP: continue")
    map("n", "<leader>dr", dap.restart, "DAP: restart")
    map("n", "<leader>dx", dap.terminate, "DAP: terminate")

    map("n", "<leader>du", dapui.toggle, "DAP: toggle UI")
    map("n", "<leader>de", function()
      dapui.eval(nil, { enter = true })
    end, "DAP: eval expression")
  end,
}

