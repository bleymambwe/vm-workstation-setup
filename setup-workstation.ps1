# ============================================================
# Full Automation Workstation Setup
# ============================================================

$ErrorActionPreference = "Continue"
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

function Log($msg) { Write-Host "`n==> $msg" -ForegroundColor Cyan }
function RefreshPath {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# ── 1. Chocolatey ────────────────────────────────────────────
Log "Installing Chocolatey..."
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    RefreshPath
}

# ── 2. Core tools via Chocolatey ─────────────────────────────
Log "Installing core tools (Chrome, Git, VS Code, Node, Python)..."
choco install -y `
    googlechrome `
    git `
    github-desktop `
    vscode `
    python `
    nodejs-lts `
    powershell-core `
    gh `
    windows-terminal `
    7zip `
    curl

RefreshPath

# ── 3. Python packages ───────────────────────────────────────
Log "Installing Python automation packages..."
python -m pip install --upgrade pip
pip install `
    playwright `
    selenium `
    webdriver-manager `
    requests `
    beautifulsoup4 `
    pandas `
    Pillow `
    pyautogui `
    python-dotenv `
    openai `
    anthropic `
    google-generativeai

# Install Playwright browsers (Chromium + Firefox)
Log "Installing Playwright browsers..."
python -m playwright install chromium firefox

# ── 4. Claude CLI (Claude Code) ──────────────────────────────
Log "Installing Claude CLI..."
npm install -g @anthropic-ai/claude-code

# ── 5. Gemini CLI ────────────────────────────────────────────
Log "Installing Gemini CLI..."
npm install -g @google/gemini-cli

# ── 6. OpenAI Codex CLI ──────────────────────────────────────
Log "Installing OpenAI Codex CLI..."
npm install -g @openai/codex

# ── 7. Claude Desktop ────────────────────────────────────────
Log "Downloading Claude Desktop..."
$claudeDest = "$env:TEMP\ClaudeSetup.exe"
Invoke-WebRequest -Uri "https://claude.ai/download/windows/latest" -OutFile $claudeDest -UseBasicParsing
if (Test-Path $claudeDest) {
    Log "Installing Claude Desktop silently..."
    Start-Process $claudeDest -ArgumentList "--silent" -Wait
}

# ── 8. GitHub CLI auth prompt ────────────────────────────────
Log "GitHub CLI installed. Run 'gh auth login' to authenticate."

# ── 9. VS Code extensions ────────────────────────────────────
Log "Installing VS Code extensions..."
$extensions = @(
    "ms-python.python",
    "ms-python.vscode-pylance",
    "esbenp.prettier-vscode",
    "github.copilot",
    "github.vscode-pull-request-github",
    "ms-vscode.powershell",
    "hediet.vscode-drawio"
)
foreach ($ext in $extensions) {
    code --install-extension $ext --force
}

# ── 10. Git global config ────────────────────────────────────
Log "Configuring Git..."
git config --global user.email "bleymambwe@gmail.com"
git config --global user.name "Blessing Mambwe"
git config --global core.autocrlf true

# ── Done ─────────────────────────────────────────────────────
Log "Setup complete! Installed:"
Write-Host @"

  Chrome          - browser & automation target
  Git + GitHub Desktop + GitHub CLI  - source control
  VS Code         - editor (with Python, Copilot, PS extensions)
  Python 3        - with Playwright, Selenium, BeautifulSoup, OpenAI, Anthropic SDKs
  Node.js         - runtime
  Claude CLI      - 'claude' command in terminal
  Claude Desktop  - GUI app
  Gemini CLI      - 'gemini' command in terminal
  OpenAI Codex    - 'codex' command in terminal
  PowerShell 7    - modern shell
  Windows Terminal - better terminal

  Next steps:
    1. Run: gh auth login          (GitHub)
    2. Run: claude                 (Claude CLI login)
    3. Run: gemini                 (Gemini CLI login)
    4. Run: codex                  (Codex CLI login)
    5. Open Claude Desktop app and sign in
"@
