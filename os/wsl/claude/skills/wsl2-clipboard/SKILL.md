---
name: wsl2-clipboard
description: This skill should be used when the user asks to "copy to clipboard", "put in clipboard", "クリップボードに入れて", "コピーして", or wants to copy text content to the system clipboard from WSL2.
---

# WSL2 Clipboard

Copy text to the Windows clipboard from WSL2 using `win32yank.exe`.

## Usage

Pipe text to `win32yank.exe -i`:

```bash
printf '%s' 'text content here' | win32yank.exe -i
```

For multi-line content, use a heredoc:

```bash
cat <<'EOF' | win32yank.exe -i
line 1
line 2
EOF
```

## Notes

- `win32yank.exe` handles UTF-8 natively — no encoding conversion needed.
- Installed via mise (`github:equalsraf/win32yank`); it resolves on `PATH`.
- Fallback if `win32yank.exe` is unavailable: `printf '%s' '...' | iconv -f UTF-8 -t UTF-16LE | clip.exe`

## Reading from Clipboard

To read clipboard content into WSL2:

```bash
win32yank.exe -o --lf
```

- `--lf` converts Windows CRLF line endings to LF; omit it and multi-line clipboard content will have trailing `\r` on each line.
