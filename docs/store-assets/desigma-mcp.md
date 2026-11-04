# Desigma MCP setup — 2026-11-03

Installed official source tag `v0.1.0-alpha.17`, commit `f9bb0a0`, matching `/Applications/desigma.app`. Built with `cargo build --locked --release -p desigma-mcp` using the upstream toolchain.

Persistent binary:
`/Users/jackiejensen/Library/Application Support/desigma/bin/desigma-mcp`

Registered through `codex mcp add desigma -- <binary> --workspace <Hint Master design library>` in the user's Codex configuration. The workspace is restricted to:
`/Users/jackiejensen/Library/CloudStorage/OneDrive-Personal/Programering/Flutter/Hint Master/Desigma Library`

The editor bridge is enabled with the official `agent_bridge` setting in the local Desigma library's settings.json. It is local to this Mac; no account or external service. Bridge credentials/discovery files must remain local and must not be copied into OneDrive or ordinary project notes.

## Verified behavior

The actual MCP JSON-RPC stdio handshake and tools/list succeed (27 tools). `desigma_get_document` returns `session: editor` and the actual open Header/Search path. This revision uses `desigma_set_text_style`, `desigma_update_node`, `desigma_set_appearance`, `desigma_save_file`, and selection through the live editor, sharing its undo stack.

This running Codex chat did not hot-load the new server into its original tool catalog. The connection was exercised using a local stdio MCP client, not a replacement editor API. The persistent registration is ready for Codex's next MCP reload/restart.

Live editor full-resolution export hit the editor bridge's fixed 5-second deadline. Read-back verified the saved document before proceeding. Exporting the saved documents through the same MCP server's supported isolated file session (`DESIGMA_BRIDGE_FILE` empty for that export client only) succeeds. This leaves the normal live bridge enabled. Large exports should use this file workflow if the live editor times out. Native file export can include an alpha channel; flatten to RGB for Apple.

Do not set discard_changes on a document with unrelated user edits. In this revision, switching Header→Search cleared only this agent's own undo history after explicitly saving and verifying the updated Header. Backups preserve the prior versions.

Sources: [Desigma MCP documentation](https://github.com/deepfounder-ai/desigma/tree/v0.1.0-alpha.17/crates/desigma-mcp), [Codex MCP configuration](https://learn.chatgpt.com/docs/extend/mcp).
