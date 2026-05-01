# Windows Automation Workstation — GCP Setup

Restore the full Windows research/automation VM in ~15 minutes with one command.

## VM Specs
| | |
|---|---|
| **Machine type** | e2-standard-4 (4 vCPU, 16GB RAM) |
| **OS** | Windows Server 2022 Datacenter |
| **Disk** | 100GB pd-ssd |
| **Zone** | us-central1-c |
| **Project** | eve-ai-460dd |

## Recreate the VM

```bash
# 1. Create the VM
gcloud compute instances create windows-automation \
  --project=eve-ai-460dd \
  --zone=us-central1-c \
  --machine-type=e2-standard-4 \
  --image-family=windows-2022 \
  --image-project=windows-cloud \
  --boot-disk-size=100GB \
  --boot-disk-type=pd-ssd \
  --tags=rdp-server \
  --description="Windows VM for web automation and research"

# 2. Attach static IP
gcloud compute instances delete-access-config windows-automation \
  --zone=us-central1-c --project=eve-ai-460dd \
  --access-config-name="External NAT"

gcloud compute instances add-access-config windows-automation \
  --zone=us-central1-c --project=eve-ai-460dd \
  --access-config-name="External NAT" \
  --address=34.31.125.73

# 3. Set password to todaytoday (run after VM boots ~3 min)
gcloud compute instances add-metadata windows-automation \
  --zone=us-central1-c --project=eve-ai-460dd \
  --metadata-from-file=windows-startup-script-ps1=set-password.ps1

gcloud compute instances reset windows-automation \
  --zone=us-central1-c --project=eve-ai-460dd
```

## Install All Software

Once connected via RDP (`34.31.125.73:3389`, user: `bleymambwe`, pass: `todaytoday`):

Open **PowerShell as Administrator** and run:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/bleymambwe/vm-workstation-setup/main/setup-workstation.ps1" -UseBasicParsing | Invoke-Expression
```

## What Gets Installed
- Chrome, Git, GitHub Desktop, GitHub CLI
- VS Code (Python, Copilot, PowerShell extensions)
- Python 3 + Playwright, Selenium, BeautifulSoup, Anthropic/OpenAI SDKs
- Node.js
- Claude CLI (`claude`)
- Claude Desktop
- Gemini CLI (`gemini`)
- OpenAI Codex (`codex`)
- PowerShell 7, Windows Terminal

## Connect via Termius (RDP)
| Field | Value |
|---|---|
| Host | `34.31.125.73` |
| Port | `3389` |
| Username | `bleymambwe` |
| Password | `todaytoday` |
