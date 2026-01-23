# Read JSON input from stdin
$jsonInput = [Console]::In.ReadToEnd() | ConvertFrom-Json

# Project name (last folder name only)
$dir = Split-Path -Leaf $jsonInput.workspace.current_dir

# Git branch with dirty indicator
$git = git branch --show-current 2>$null
if ($git) {
    $dirty = if (git status --porcelain 2>$null) { "*" } else { "" }
    $git = " ($git$dirty)"
} else {
    $git = ""
}

# Token usage in k format (used/total)
$usage = $jsonInput.context_window.current_usage
$usedTokens = $usage.input_tokens + $usage.output_tokens + $usage.cache_creation_input_tokens + $usage.cache_read_input_tokens
$totalTokens = $jsonInput.context_window.context_window_size
$usedK = [math]::Round($usedTokens / 1000)
$totalK = [math]::Round($totalTokens / 1000)

# Model name
$model = $jsonInput.model.display_name

# MCP servers
$mcpCount = 0
if ($jsonInput.mcp -and $jsonInput.mcp.servers) {
    $mcpCount = ($jsonInput.mcp.servers | Where-Object { $_.status -eq "connected" }).Count
}
$mcp = if ($mcpCount -gt 0) { " | MCP: $mcpCount active" } else { "" }

# Output status line
Write-Host "${dir}${git} | Tokens: ${usedK}k/${totalK}k | $model$mcp"
