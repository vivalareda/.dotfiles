local M = {}

local uv = vim.uv

local state = {
	-- keyed by vtsls root_dir (or client id fallback)
	applied_tsdk = {},
	missing_notified = {},
}

local function fs_exists(path)
	return uv.fs_stat(path) ~= nil
end

local function read_file(path)
	local f = io.open(path, "r")
	if not f then
		return nil
	end
	local ok, content = pcall(f.read, f, "*a")
	f:close()
	if not ok then
		return nil
	end
	return content
end

local function read_ts_version(typescript_pkg_json)
	local content = read_file(typescript_pkg_json)
	if not content then
		return nil
	end
	return content:match('"version"%s*:%s*"([^"]+)"')
end

local function find_nearest_tsdk(start_dir, stop_dir)
	local dir = vim.fs.normalize(start_dir)
	local stop = stop_dir and vim.fs.normalize(stop_dir) or nil

	while dir do
		local tsserver = dir .. "/node_modules/typescript/lib/tsserver.js"
		if fs_exists(tsserver) then
			return dir .. "/node_modules/typescript/lib", dir .. "/node_modules/typescript/package.json"
		end

		if stop and dir == stop then
			break
		end

		local parent = vim.fs.dirname(dir)
		if not parent or parent == dir then
			break
		end
		dir = parent
	end

	return nil
end

local function get_vtsls_root(client)
	if client.config and client.config.root_dir and client.config.root_dir ~= "" then
		return client.config.root_dir
	end
	local folders = client.workspace_folders
	if folders and folders[1] and folders[1].name and folders[1].name ~= "" then
		return folders[1].name
	end
	return nil
end

function M.ensure(client, bufnr)
	if not client or client.name ~= "vtsls" then
		return
	end

	local bufname = vim.api.nvim_buf_get_name(bufnr)
	if bufname == "" then
		return
	end

	local root = get_vtsls_root(client)
	local key = root or tostring(client.id)

	local start_dir = vim.fs.dirname(bufname)
	local tsdk_path, pkg_json = find_nearest_tsdk(start_dir, root)

	if not tsdk_path then
		if root and not state.missing_notified[key] then
			state.missing_notified[key] = true
			vim.notify(
				"vtsls: no workspace TypeScript found; using bundled TypeScript",
				vim.log.levels.WARN,
				{ title = "vtsls" }
			)
		end
		return
	end

	if state.applied_tsdk[key] == tsdk_path then
		return
	end

	state.applied_tsdk[key] = tsdk_path
	state.missing_notified[key] = nil

	client.config.settings = client.config.settings or {}
	client.config.settings["typescript.tsdk"] = tsdk_path
	client.config.settings["vtsls.autoUseWorkspaceTsdk"] = true

	client:notify("workspace/didChangeConfiguration", { settings = client.config.settings })
	client:exec_cmd({ command = "typescript.restartTsServer", title = "Restart TS Server" })

	local version = pkg_json and read_ts_version(pkg_json) or nil
	local msg = version and ("vtsls: set workspace TypeScript " .. version .. " (" .. tsdk_path .. ")")
		or ("vtsls: set workspace TypeScript (" .. tsdk_path .. ")")
	vim.notify(msg, vim.log.levels.INFO, { title = "vtsls" })
end

return M
