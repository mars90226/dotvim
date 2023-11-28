local job = {}

-- TODO: Use plenary.job, but it seems not supporting pipe
--- Find Neovim child process by pattern and call callback with pid
---@param pattern string pattern for filtering child process
---@param callback fun(pid: integer): nil function to be called with child process pid
job.find_neovim_child_process = function(pattern, callback)
  local command = string.format(
    [[ps -ef | awk '$3 == "%d" { print $0 } ' | grep '%s' | awk '{ print $2 }']],
    vim.fn.getpid(),
    pattern
  )
  vim.fn.jobstart(command, {
    on_stdout = function(_, data)
      for _, line in ipairs(data) do
        local child_process_pid = line:match('(%d+)')
        if child_process_pid ~= nil then
          callback(child_process_pid)
        end
      end
    end,
    on_stderr = function(_, errors)
      local err_msg = ""
      for _, err in ipairs(errors) do
        if err ~= "" and err ~= nil then
          err_msg = err_msg .. err .. "\n"
        end
      end

      if err_msg ~= "" then
        vim.notify(err_msg, vim.log.levels.ERROR)
      end
    end,
  })
end

--- Kill process by pid
---@param pid integer process id
---@param callback fun(): nil function to be called after killing process
job.kill_pid = function(pid, callback)
  local command = string.format("kill -9 %d", pid)
  vim.fn.jobstart(command, {
    on_exit = function(_, _)
      if callback ~= nil then
        callback()
      end
    end,
    on_stderr = function(_, errors)
      local err_msg = ""
      for _, err in ipairs(errors) do
        if err ~= "" and err ~= nil then
          err_msg = err_msg .. err .. "\n"
        end
      end

      if err_msg ~= "" then
        vim.notify(err_msg, vim.log.levels.ERROR)
      end
    end,
  })
end

return job
