#!/usr/bin/env python3
# /// script
# requires-python = ">=3.11"
# dependencies = [
#     "typer",
#     "rich",
#     "platformdirs",
#     "readchar",
#     "httpx",
# ]
# ///
"""
Specify CLI - Setup tool for Specify projects

Usage:
    uvx specify-cli.py init <project-name>
    uvx specify-cli.py init --here

Or install globally:
    uv tool install --from specify-cli.py specify-cli
    specify init <project-name>
    specify init --here
"""

import os
import subprocess
import sys
import zipfile
import tempfile
import shutil
import json
from pathlib import Path
from typing import Optional

import typer
import httpx
from rich.console import Console
from rich.panel import Panel
from rich.progress import Progress, SpinnerColumn, TextColumn
from rich.text import Text
from rich.live import Live
from rich.align import Align
from rich.table import Table
from rich.tree import Tree
from typer.core import TyperGroup

# For cross-platform keyboard input
import readchar
import ssl
import truststore

ssl_context = truststore.SSLContext(ssl.PROTOCOL_TLS_CLIENT)
client = httpx.Client(verify=ssl_context)

# Constants - AUGGIE-Only Enhanced Spec-Kit
AI_CHOICES = {
    "auggie": "Augment AUGGIE CLI - Enhanced Spec-Driven Development"
}

# Claude CLI local installation path after migrate-installer
CLAUDE_LOCAL_PATH = Path.home() / ".claude" / "local" / "claude"

# ASCII Art Banner
BANNER = """
███████╗██████╗ ███████╗ ██████╗██╗███████╗██╗   ██╗
██╔════╝██╔══██╗██╔════╝██╔════╝██║██╔════╝╚██╗ ██╔╝
███████╗██████╔╝█████╗  ██║     ██║█████╗   ╚████╔╝ 
╚════██║██╔═══╝ ██╔══╝  ██║     ██║██╔══╝    ╚██╔╝  
███████║██║     ███████╗╚██████╗██║██║        ██║   
╚══════╝╚═╝     ╚══════╝ ╚═════╝╚═╝╚═╝        ╚═╝   
"""

TAGLINE = "Spec-Driven Development Toolkit"
class StepTracker:
    """Track and render hierarchical steps without emojis, similar to Claude Code tree output.
    Supports live auto-refresh via an attached refresh callback.
    """
    def __init__(self, title: str):
        self.title = title
        self.steps = []  # list of dicts: {key, label, status, detail}
        self.status_order = {"pending": 0, "running": 1, "done": 2, "error": 3, "skipped": 4}
        self._refresh_cb = None  # callable to trigger UI refresh

    def attach_refresh(self, cb):
        self._refresh_cb = cb

    def add(self, key: str, label: str):
        if key not in [s["key"] for s in self.steps]:
            self.steps.append({"key": key, "label": label, "status": "pending", "detail": ""})
            self._maybe_refresh()

    def start(self, key: str, detail: str = ""):
        self._update(key, status="running", detail=detail)

    def complete(self, key: str, detail: str = ""):
        self._update(key, status="done", detail=detail)

    def error(self, key: str, detail: str = ""):
        self._update(key, status="error", detail=detail)

    def skip(self, key: str, detail: str = ""):
        self._update(key, status="skipped", detail=detail)

    def _update(self, key: str, status: str, detail: str):
        for s in self.steps:
            if s["key"] == key:
                s["status"] = status
                if detail:
                    s["detail"] = detail
                self._maybe_refresh()
                return
        # If not present, add it
        self.steps.append({"key": key, "label": key, "status": status, "detail": detail})
        self._maybe_refresh()

    def _maybe_refresh(self):
        if self._refresh_cb:
            try:
                self._refresh_cb()
            except Exception:
                pass

    def render(self):
        tree = Tree(f"[bold cyan]{self.title}[/bold cyan]", guide_style="grey50")
        for step in self.steps:
            label = step["label"]
            detail_text = step["detail"].strip() if step["detail"] else ""

            # Circles (unchanged styling)
            status = step["status"]
            if status == "done":
                symbol = "[green]●[/green]"
            elif status == "pending":
                symbol = "[green dim]○[/green dim]"
            elif status == "running":
                symbol = "[cyan]○[/cyan]"
            elif status == "error":
                symbol = "[red]●[/red]"
            elif status == "skipped":
                symbol = "[yellow]○[/yellow]"
            else:
                symbol = " "

            if status == "pending":
                # Entire line light gray (pending)
                if detail_text:
                    line = f"{symbol} [bright_black]{label} ({detail_text})[/bright_black]"
                else:
                    line = f"{symbol} [bright_black]{label}[/bright_black]"
            else:
                # Label white, detail (if any) light gray in parentheses
                if detail_text:
                    line = f"{symbol} [white]{label}[/white] [bright_black]({detail_text})[/bright_black]"
                else:
                    line = f"{symbol} [white]{label}[/white]"

            tree.add(line)
        return tree



MINI_BANNER = """
╔═╗╔═╗╔═╗╔═╗╦╔═╗╦ ╦
╚═╗╠═╝║╣ ║  ║╠╣ ╚╦╝
╚═╝╩  ╚═╝╚═╝╩╚   ╩ 
"""

def get_key():
    """Get a single keypress in a cross-platform way using readchar."""
    key = readchar.readkey()
    
    # Arrow keys
    if key == readchar.key.UP:
        return 'up'
    if key == readchar.key.DOWN:
        return 'down'
    
    # Enter/Return
    if key == readchar.key.ENTER:
        return 'enter'
    
    # Escape
    if key == readchar.key.ESC:
        return 'escape'
        
    # Ctrl+C
    if key == readchar.key.CTRL_C:
        raise KeyboardInterrupt

    return key



def select_with_arrows(options: dict, prompt_text: str = "Select an option", default_key: str = None) -> str:
    """
    Interactive selection using arrow keys with Rich Live display.
    
    Args:
        options: Dict with keys as option keys and values as descriptions
        prompt_text: Text to show above the options
        default_key: Default option key to start with
        
    Returns:
        Selected option key
    """
    option_keys = list(options.keys())
    if default_key and default_key in option_keys:
        selected_index = option_keys.index(default_key)
    else:
        selected_index = 0
    
    selected_key = None

    def create_selection_panel():
        """Create the selection panel with current selection highlighted."""
        table = Table.grid(padding=(0, 2))
        table.add_column(style="bright_cyan", justify="left", width=3)
        table.add_column(style="white", justify="left")
        
        for i, key in enumerate(option_keys):
            if i == selected_index:
                table.add_row("▶", f"[bright_cyan]{key}: {options[key]}[/bright_cyan]")
            else:
                table.add_row(" ", f"[white]{key}: {options[key]}[/white]")
        
        table.add_row("", "")
        table.add_row("", "[dim]Use ↑/↓ to navigate, Enter to select, Esc to cancel[/dim]")
        
        return Panel(
            table,
            title=f"[bold]{prompt_text}[/bold]",
            border_style="cyan",
            padding=(1, 2)
        )
    
    console.print()

    def run_selection_loop():
        nonlocal selected_key, selected_index
        with Live(create_selection_panel(), console=console, transient=True, auto_refresh=False) as live:
            while True:
                try:
                    key = get_key()
                    if key == 'up':
                        selected_index = (selected_index - 1) % len(option_keys)
                    elif key == 'down':
                        selected_index = (selected_index + 1) % len(option_keys)
                    elif key == 'enter':
                        selected_key = option_keys[selected_index]
                        break
                    elif key == 'escape':
                        console.print("\n[yellow]Selection cancelled[/yellow]")
                        raise typer.Exit(1)
                    
                    live.update(create_selection_panel(), refresh=True)

                except KeyboardInterrupt:
                    console.print("\n[yellow]Selection cancelled[/yellow]")
                    raise typer.Exit(1)

    run_selection_loop()

    if selected_key is None:
        console.print("\n[red]Selection failed.[/red]")
        raise typer.Exit(1)

    # Suppress explicit selection print; tracker / later logic will report consolidated status
    return selected_key



console = Console()


class BannerGroup(TyperGroup):
    """Custom group that shows banner before help."""
    
    def format_help(self, ctx, formatter):
        # Show banner before help
        show_banner()
        super().format_help(ctx, formatter)


app = typer.Typer(
    name="specify",
    help="Setup tool for Specify spec-driven development projects",
    add_completion=False,
    invoke_without_command=True,
    cls=BannerGroup,
)


def show_banner():
    """Display the ASCII art banner."""
    # Create gradient effect with different colors
    banner_lines = BANNER.strip().split('\n')
    colors = ["bright_blue", "blue", "cyan", "bright_cyan", "white", "bright_white"]
    
    styled_banner = Text()
    for i, line in enumerate(banner_lines):
        color = colors[i % len(colors)]
        styled_banner.append(line + "\n", style=color)
    
    console.print(Align.center(styled_banner))
    console.print(Align.center(Text(TAGLINE, style="italic bright_yellow")))
    console.print()


@app.callback()
def callback(ctx: typer.Context):
    """Show banner when no subcommand is provided."""
    # Show banner only when no subcommand and no help flag
    # (help is handled by BannerGroup)
    if ctx.invoked_subcommand is None and "--help" not in sys.argv and "-h" not in sys.argv:
        show_banner()
        console.print(Align.center("[dim]Run 'specify --help' for usage information[/dim]"))
        console.print()


def run_command(cmd: list[str], check_return: bool = True, capture: bool = False, shell: bool = False) -> Optional[str]:
    """Run a shell command and optionally capture output."""
    try:
        if capture:
            result = subprocess.run(cmd, check=check_return, capture_output=True, text=True, shell=shell)
            return result.stdout.strip()
        else:
            subprocess.run(cmd, check=check_return, shell=shell)
            return None
    except subprocess.CalledProcessError as e:
        if check_return:
            console.print(f"[red]Error running command:[/red] {' '.join(cmd)}")
            console.print(f"[red]Exit code:[/red] {e.returncode}")
            if hasattr(e, 'stderr') and e.stderr:
                console.print(f"[red]Error output:[/red] {e.stderr}")
            raise
        return None


def check_tool(tool: str, install_hint: str) -> bool:
    """Check if a tool is installed."""
    
    # Special handling for Claude CLI after `claude migrate-installer`
    # See: https://github.com/github/spec-kit/issues/123
    # The migrate-installer command REMOVES the original executable from PATH
    # and creates an alias at ~/.claude/local/claude instead
    # This path should be prioritized over other claude executables in PATH
    if tool == "claude":
        if CLAUDE_LOCAL_PATH.exists() and CLAUDE_LOCAL_PATH.is_file():
            return True
    
    if shutil.which(tool):
        return True
    else:
        console.print(f"[yellow]⚠️  {tool} not found[/yellow]")
        console.print(f"   Install with: [cyan]{install_hint}[/cyan]")
        return False


def is_git_repo(path: Path = None) -> bool:
    """Check if the specified path is inside a git repository."""
    if path is None:
        path = Path.cwd()
    
    if not path.is_dir():
        return False

    try:
        # Use git command to check if inside a work tree
        subprocess.run(
            ["git", "rev-parse", "--is-inside-work-tree"],
            check=True,
            capture_output=True,
            cwd=path,
        )
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        return False


def init_git_repo(project_path: Path, quiet: bool = False) -> bool:
    """Initialize a git repository in the specified path.
    quiet: if True suppress console output (tracker handles status)
    """
    try:
        original_cwd = Path.cwd()
        os.chdir(project_path)
        if not quiet:
            console.print("[cyan]Initializing git repository...[/cyan]")
        subprocess.run(["git", "init"], check=True, capture_output=True)
        subprocess.run(["git", "add", "."], check=True, capture_output=True)
        subprocess.run(["git", "commit", "-m", "Initial commit from Specify template"], check=True, capture_output=True)
        if not quiet:
            console.print("[green]✓[/green] Git repository initialized")
        return True
        
    except subprocess.CalledProcessError as e:
        if not quiet:
            console.print(f"[red]Error initializing git repository:[/red] {e}")
        return False
    finally:
        os.chdir(original_cwd)


def download_template_from_github(ai_assistant: str, download_dir: Path, *, verbose: bool = True, show_progress: bool = True, client: httpx.Client = None):
    repo_owner = "github"
    repo_name = "spec-kit"
    if client is None:
        client = httpx.Client(verify=ssl_context)
    
    if verbose:
        console.print("[cyan]Fetching latest release information...[/cyan]")
    api_url = f"https://api.github.com/repos/{repo_owner}/{repo_name}/releases/latest"
    
    try:
        response = client.get(api_url, timeout=30, follow_redirects=True)
        response.raise_for_status()
        release_data = response.json()
    except httpx.RequestError as e:
        if verbose:
            console.print(f"[red]Error fetching release information:[/red] {e}")
        raise typer.Exit(1)
    
    # Find the template asset for the specified AI assistant
    pattern = f"spec-kit-template-{ai_assistant}"
    matching_assets = [
        asset for asset in release_data.get("assets", [])
        if pattern in asset["name"] and asset["name"].endswith(".zip")
    ]
    
    if not matching_assets:
        if verbose:
            console.print(f"[red]Error:[/red] No template found for AI assistant '{ai_assistant}'")
            console.print(f"[yellow]Available assets:[/yellow]")
            for asset in release_data.get("assets", []):
                console.print(f"  - {asset['name']}")
        raise typer.Exit(1)
    
    # Use the first matching asset
    asset = matching_assets[0]
    download_url = asset["browser_download_url"]
    filename = asset["name"]
    file_size = asset["size"]
    
    if verbose:
        console.print(f"[cyan]Found template:[/cyan] {filename}")
        console.print(f"[cyan]Size:[/cyan] {file_size:,} bytes")
        console.print(f"[cyan]Release:[/cyan] {release_data['tag_name']}")
    
    # Download the file
    zip_path = download_dir / filename
    if verbose:
        console.print(f"[cyan]Downloading template...[/cyan]")
    
    try:
        with client.stream("GET", download_url, timeout=30, follow_redirects=True) as response:
            response.raise_for_status()
            total_size = int(response.headers.get('content-length', 0))
            with open(zip_path, 'wb') as f:
                if total_size == 0:
                    for chunk in response.iter_bytes(chunk_size=8192):
                        f.write(chunk)
                else:
                    if show_progress:
                        with Progress(
                            SpinnerColumn(),
                            TextColumn("[progress.description]{task.description}"),
                            TextColumn("[progress.percentage]{task.percentage:>3.0f}%"),
                            console=console,
                        ) as progress:
                            task = progress.add_task("Downloading...", total=total_size)
                            downloaded = 0
                            for chunk in response.iter_bytes(chunk_size=8192):
                                f.write(chunk)
                                downloaded += len(chunk)
                                progress.update(task, completed=downloaded)
                    else:
                        for chunk in response.iter_bytes(chunk_size=8192):
                            f.write(chunk)
    except httpx.RequestError as e:
        if verbose:
            console.print(f"[red]Error downloading template:[/red] {e}")
        if zip_path.exists():
            zip_path.unlink()
        raise typer.Exit(1)
    if verbose:
        console.print(f"Downloaded: {filename}")
    metadata = {
        "filename": filename,
        "size": file_size,
        "release": release_data["tag_name"],
        "asset_url": download_url
    }
    return zip_path, metadata


def download_and_extract_template(project_path: Path, ai_assistant: str, is_current_dir: bool = False, *, verbose: bool = True, tracker: StepTracker | None = None, client: httpx.Client = None) -> Path:
    """Download the latest release and extract it to create a new project.
    Returns project_path. Uses tracker if provided (with keys: fetch, download, extract, cleanup)
    """
    current_dir = Path.cwd()
    
    # Step: fetch + download combined
    if tracker:
        tracker.start("fetch", "contacting GitHub API")
    try:
        zip_path, meta = download_template_from_github(
            ai_assistant,
            current_dir,
            verbose=verbose and tracker is None,
            show_progress=(tracker is None),
            client=client
        )
        if tracker:
            tracker.complete("fetch", f"release {meta['release']} ({meta['size']:,} bytes)")
            tracker.add("download", "Download template")
            tracker.complete("download", meta['filename'])
    except Exception as e:
        if tracker:
            tracker.error("fetch", str(e))
        else:
            if verbose:
                console.print(f"[red]Error downloading template:[/red] {e}")
        raise
    
    if tracker:
        tracker.add("extract", "Extract template")
        tracker.start("extract")
    elif verbose:
        console.print("Extracting template...")
    
    try:
        # Create project directory only if not using current directory
        if not is_current_dir:
            project_path.mkdir(parents=True)
        
        with zipfile.ZipFile(zip_path, 'r') as zip_ref:
            # List all files in the ZIP for debugging
            zip_contents = zip_ref.namelist()
            if tracker:
                tracker.start("zip-list")
                tracker.complete("zip-list", f"{len(zip_contents)} entries")
            elif verbose:
                console.print(f"[cyan]ZIP contains {len(zip_contents)} items[/cyan]")
            
            # For current directory, extract to a temp location first
            if is_current_dir:
                with tempfile.TemporaryDirectory() as temp_dir:
                    temp_path = Path(temp_dir)
                    zip_ref.extractall(temp_path)
                    
                    # Check what was extracted
                    extracted_items = list(temp_path.iterdir())
                    if tracker:
                        tracker.start("extracted-summary")
                        tracker.complete("extracted-summary", f"temp {len(extracted_items)} items")
                    elif verbose:
                        console.print(f"[cyan]Extracted {len(extracted_items)} items to temp location[/cyan]")
                    
                    # Handle GitHub-style ZIP with a single root directory
                    source_dir = temp_path
                    if len(extracted_items) == 1 and extracted_items[0].is_dir():
                        source_dir = extracted_items[0]
                        if tracker:
                            tracker.add("flatten", "Flatten nested directory")
                            tracker.complete("flatten")
                        elif verbose:
                            console.print(f"[cyan]Found nested directory structure[/cyan]")
                    
                    # Copy contents to current directory
                    for item in source_dir.iterdir():
                        dest_path = project_path / item.name
                        if item.is_dir():
                            if dest_path.exists():
                                if verbose and not tracker:
                                    console.print(f"[yellow]Merging directory:[/yellow] {item.name}")
                                # Recursively copy directory contents
                                for sub_item in item.rglob('*'):
                                    if sub_item.is_file():
                                        rel_path = sub_item.relative_to(item)
                                        dest_file = dest_path / rel_path
                                        dest_file.parent.mkdir(parents=True, exist_ok=True)
                                        shutil.copy2(sub_item, dest_file)
                            else:
                                shutil.copytree(item, dest_path)
                        else:
                            if dest_path.exists() and verbose and not tracker:
                                console.print(f"[yellow]Overwriting file:[/yellow] {item.name}")
                            shutil.copy2(item, dest_path)
                    if verbose and not tracker:
                        console.print(f"[cyan]Template files merged into current directory[/cyan]")
            else:
                # Extract directly to project directory (original behavior)
                zip_ref.extractall(project_path)
                
                # Check what was extracted
                extracted_items = list(project_path.iterdir())
                if tracker:
                    tracker.start("extracted-summary")
                    tracker.complete("extracted-summary", f"{len(extracted_items)} top-level items")
                elif verbose:
                    console.print(f"[cyan]Extracted {len(extracted_items)} items to {project_path}:[/cyan]")
                    for item in extracted_items:
                        console.print(f"  - {item.name} ({'dir' if item.is_dir() else 'file'})")
                
                # Handle GitHub-style ZIP with a single root directory
                if len(extracted_items) == 1 and extracted_items[0].is_dir():
                    # Move contents up one level
                    nested_dir = extracted_items[0]
                    temp_move_dir = project_path.parent / f"{project_path.name}_temp"
                    # Move the nested directory contents to temp location
                    shutil.move(str(nested_dir), str(temp_move_dir))
                    # Remove the now-empty project directory
                    project_path.rmdir()
                    # Rename temp directory to project directory
                    shutil.move(str(temp_move_dir), str(project_path))
                    if tracker:
                        tracker.add("flatten", "Flatten nested directory")
                        tracker.complete("flatten")
                    elif verbose:
                        console.print(f"[cyan]Flattened nested directory structure[/cyan]")
                    
    except Exception as e:
        if tracker:
            tracker.error("extract", str(e))
        else:
            if verbose:
                console.print(f"[red]Error extracting template:[/red] {e}")
        # Clean up project directory if created and not current directory
        if not is_current_dir and project_path.exists():
            shutil.rmtree(project_path)
        raise typer.Exit(1)
    else:
        if tracker:
            tracker.complete("extract")
    finally:
        if tracker:
            tracker.add("cleanup", "Remove temporary archive")
        # Clean up downloaded ZIP file
        if zip_path.exists():
            zip_path.unlink()
            if tracker:
                tracker.complete("cleanup")
            elif verbose:
                console.print(f"Cleaned up: {zip_path.name}")
    
    return project_path


def initialize_brownfield_project(project_path: Path, project_name: str, no_git: bool, git_available: bool):
    """Initialize Spec-Kit in an existing project (brownfield)."""
    console.print(Panel.fit(
        "[bold cyan]Brownfield Spec-Kit Integration[/bold cyan]\n"
        f"Adding Spec-Kit to existing project: [green]{project_name}[/green]\n"
        f"[dim]Path: {project_path}[/dim]",
        border_style="cyan"
    ))

    # Create brownfield directory structure
    console.print("\n[bold]Setting up Spec-Kit directories...[/bold]")

    # Create .augment directory
    augment_dir = project_path / ".augment"
    augment_dir.mkdir(exist_ok=True)

    # Create context directory
    context_dir = augment_dir / "context"
    context_dir.mkdir(exist_ok=True)

    # Create specs directory
    specs_dir = project_path / "specs"
    specs_dir.mkdir(exist_ok=True)

    # Create memory directory
    memory_dir = project_path / "memory"
    memory_dir.mkdir(exist_ok=True)

    console.print("[green]✓[/green] Created directory structure")

    # Create brownfield-specific files
    create_brownfield_files(project_path, project_name)

    # Initialize git if needed
    if not no_git and git_available and not is_git_repo(project_path):
        console.print("\n[bold]Initializing git repository...[/bold]")
        if init_git_repo(project_path):
            console.print("[green]✓[/green] Git repository initialized")
        else:
            console.print("[yellow]⚠[/yellow] Git initialization failed")

    # Show next steps
    show_brownfield_next_steps(project_path, project_name)


def create_brownfield_files(project_path: Path, project_name: str):
    """Create brownfield-specific configuration files."""

    # Create .augment/guidelines.md
    guidelines_content = f"""# {project_name} - AUGGIE Guidelines

## Project Context
This is a brownfield integration of Spec-Kit into an existing project.

## Key Principles
1. **Analyze Existing Codebase**: Always use codebase-retrieval to understand current architecture
2. **Respect Existing Patterns**: Generate specifications that fit existing code style and structure
3. **Incremental Enhancement**: Add features that complement existing functionality
4. **Context-Aware Planning**: Reference existing files and patterns in specifications

## Available Commands
- `specify scope-spec "feature description" --complexity=simple|enterprise`
- `specify design-spec "UI/UX description"`
- `specify plan "technical implementation details"`
- `specify tasks "additional context"`

## Workflow
1. Use codebase-retrieval to understand existing architecture
2. Generate specifications that fit existing patterns
3. Create implementation plans that leverage existing infrastructure
4. Generate realistic tasks based on current codebase complexity

---
*Generated by Spec-Kit Brownfield Integration*
"""

    (project_path / ".augment" / "guidelines.md").write_text(guidelines_content)

    # Create memory/constitution.md
    constitution_content = f"""# {project_name} - Project Constitution

## Core Principles

### 1. Existing Architecture Respect
- **Analyze before adding**: Use codebase-retrieval to understand current patterns
- **Consistent with existing**: New features must match existing code style and architecture
- **Incremental enhancement**: Build upon existing infrastructure, don't replace it

### 2. Quality Standards
- **Professional specifications**: Mark ambiguities with [NEEDS CLARIFICATION]
- **Context-aware implementation**: Reference existing files and patterns
- **Realistic planning**: Consider existing technical debt and constraints

### 3. Development Approach
- **Pragmatic solutions**: Choose appropriate complexity for existing project maturity
- **Maintainable code**: Follow existing patterns and conventions
- **Documentation**: Update existing documentation when adding features

## Technical Constraints
- Must work with existing technology stack
- Must respect existing database schema and migrations
- Must follow existing testing patterns
- Must maintain existing deployment processes

## Non-Negotiables
- No breaking changes to existing functionality
- All new features must have proper error handling
- Security considerations for existing user data
- Performance impact assessment for existing features

---
*This constitution guides all specification and implementation decisions*
"""

    (project_path / "memory" / "constitution.md").write_text(constitution_content)

    # Create .augment/context/README.md
    context_readme = """# Project Context Materials

This directory contains comprehensive planning documents that provide context for AUGGIE when generating specifications.

## Recommended Documents

### Business Context
- `business-requirements.md` - Core business needs and objectives
- `user-personas.md` - Target user profiles and use cases
- `market-analysis.md` - Competitive landscape and positioning

### Technical Context
- `existing-architecture.md` - Current system architecture and patterns
- `technical-constraints.md` - Technology stack, performance requirements, limitations
- `integration-requirements.md` - Third-party services and API requirements

### Project Context
- `project-timeline.md` - Development phases and milestones
- `team-structure.md` - Development team roles and responsibilities
- `quality-standards.md` - Code quality, testing, and review standards

## Usage

AUGGIE will automatically read and analyze all documents in this directory when generating specifications. The more comprehensive your context materials, the better the generated specifications will be.

Add your project-specific documents here to ensure AUGGIE understands your existing project's needs and constraints.
"""

    (project_path / ".augment" / "context" / "README.md").write_text(context_readme)

    console.print("[green]✓[/green] Created configuration files")


def show_brownfield_next_steps(project_path: Path, project_name: str):
    """Show next steps for brownfield integration."""

    steps_lines = []
    steps_lines.append("1. Add project context materials to .augment/context/")
    steps_lines.append("   - Document your existing architecture and constraints")
    steps_lines.append("   - Add business requirements and user personas")
    steps_lines.append("   - Include technical documentation and API specs")
    steps_lines.append("")
    steps_lines.append("2. Generate your first feature specification:")
    steps_lines.append("   specify scope-spec \"Your new feature description\" --complexity=simple")
    steps_lines.append("")
    steps_lines.append("3. Create implementation plan:")
    steps_lines.append("   specify plan \"Technical approach that fits your existing stack\"")
    steps_lines.append("")
    steps_lines.append("4. Generate development tasks:")
    steps_lines.append("   specify tasks \"Additional context for task generation\"")
    steps_lines.append("")
    steps_lines.append("5. Review and refine:")
    steps_lines.append("   - Check specs/ directory for generated specifications")
    steps_lines.append("   - Resolve any [NEEDS CLARIFICATION] items")
    steps_lines.append("   - Update memory/constitution.md with project-specific constraints")

    steps_panel = Panel("\n".join(steps_lines), title="Next steps", border_style="cyan", padding=(1,2))
    console.print()
    console.print(steps_panel)

    console.print(f"\n[green]✅ Spec-Kit successfully integrated into {project_name}![/green]")
    console.print("[dim]Your existing project files remain unchanged.[/dim]")


@app.command()
def init(
    project_name: str = typer.Argument(None, help="Name for your new project directory (optional if using --here or --brownfield)"),
    ai_assistant: str = typer.Option("auggie", "--ai", help="AI assistant (AUGGIE-only enhanced version)"),
    ignore_agent_tools: bool = typer.Option(False, "--ignore-agent-tools", help="Skip checks for AI agent tools like Claude Code"),
    no_git: bool = typer.Option(False, "--no-git", help="Skip git repository initialization"),
    here: bool = typer.Option(False, "--here", help="Initialize project in the current directory instead of creating a new one"),
    brownfield: bool = typer.Option(False, "--brownfield", help="Initialize Spec-Kit in existing project (lightweight integration)"),
    skip_tls: bool = typer.Option(False, "--skip-tls", help="Skip SSL/TLS verification (not recommended)"),
):
    """
    Initialize a new Specify project or add Spec-Kit to existing project.

    GREENFIELD (New Project):
    1. Check that AUGGIE CLI is installed and ready
    2. Download the enhanced AUGGIE template from GitHub
    3. Extract the template to a new project directory or current directory
    4. Initialize a fresh git repository (if not --no-git and no existing repo)
    5. Set up enhanced AUGGIE commands for complete project development
    6. Configure design, UX, and pragmatic development specifications

    BROWNFIELD (Existing Project):
    1. Check that AUGGIE CLI is installed and ready
    2. Create lightweight .augment/, specs/, and memory/ directories
    3. Set up AUGGIE commands that work with existing codebase
    4. Enable context-aware specification generation

    Examples:
        # Greenfield (new projects)
        specify init my-project
        specify init --here

        # Brownfield (existing projects)
        specify init --brownfield
        specify init --brownfield --no-git
    """
    # Show banner first
    show_banner()
    
    # Validate arguments
    if brownfield and (here or project_name):
        console.print("[red]Error:[/red] --brownfield cannot be used with project name or --here flag")
        console.print("[yellow]Tip:[/yellow] Run 'specify init --brownfield' in your existing project directory")
        raise typer.Exit(1)

    if not brownfield:
        if here and project_name:
            console.print("[red]Error:[/red] Cannot specify both project name and --here flag")
            raise typer.Exit(1)

        if not here and not project_name:
            console.print("[red]Error:[/red] Must specify either a project name or use --here flag")
            raise typer.Exit(1)
    
    # Determine project directory
    if brownfield:
        project_name = Path.cwd().name
        project_path = Path.cwd()

        # Check if already has Spec-Kit integration
        if (project_path / ".augment").exists():
            console.print(f"[yellow]Warning:[/yellow] Spec-Kit already initialized in '{project_name}'")
            response = typer.confirm("Do you want to reinitialize?")
            if not response:
                console.print("[yellow]Operation cancelled[/yellow]")
                raise typer.Exit(0)

        # Validate it's a real project directory
        existing_items = list(project_path.iterdir())
        if not existing_items:
            console.print("[red]Error:[/red] Current directory is empty - not a valid project")
            console.print("[yellow]Tip:[/yellow] Run this command in your existing project directory")
            raise typer.Exit(1)

    elif here:
        project_name = Path.cwd().name
        project_path = Path.cwd()

        # Check if current directory has any files
        existing_items = list(project_path.iterdir())
        if existing_items:
            console.print(f"[yellow]Warning:[/yellow] Current directory is not empty ({len(existing_items)} items)")
            console.print("[yellow]Template files will be merged with existing content and may overwrite existing files[/yellow]")

            # Ask for confirmation
            response = typer.confirm("Do you want to continue?")
            if not response:
                console.print("[yellow]Operation cancelled[/yellow]")
                raise typer.Exit(0)
    else:
        project_path = Path(project_name).resolve()
        # Check if project directory already exists
        if project_path.exists():
            console.print(f"[red]Error:[/red] Directory '{project_name}' already exists")
            raise typer.Exit(1)
    
    console.print(Panel.fit(
        "[bold cyan]Specify Project Setup[/bold cyan]\n"
        f"{'Initializing in current directory:' if here else 'Creating new project:'} [green]{project_path.name}[/green]"
        + (f"\n[dim]Path: {project_path}[/dim]" if here else ""),
        border_style="cyan"
    ))
    
    # Check git only if we might need it (not --no-git)
    git_available = True
    if not no_git:
        git_available = check_tool("git", "https://git-scm.com/downloads")
        if not git_available:
            console.print("[yellow]Git not found - will skip repository initialization[/yellow]")

    # AI assistant selection
    if ai_assistant:
        if ai_assistant not in AI_CHOICES:
            console.print(f"[red]Error:[/red] Invalid AI assistant '{ai_assistant}'. Choose from: {', '.join(AI_CHOICES.keys())}")
            raise typer.Exit(1)
        selected_ai = ai_assistant
    else:
        # Use arrow-key selection interface
        selected_ai = select_with_arrows(
            AI_CHOICES, 
            "Choose your AI assistant:", 
            "copilot"
        )
    
    # Check AUGGIE CLI unless ignored
    if not ignore_agent_tools:
        if not check_tool("auggie", "Install with: npm install -g @augmentcode/auggie"):
            console.print("[red]Error:[/red] AUGGIE CLI is required for enhanced Spec-Kit")
            console.print("[yellow]Install with:[/yellow] npm install -g @augmentcode/auggie")
            console.print("[yellow]Tip:[/yellow] Use --ignore-agent-tools to skip this check")
            raise typer.Exit(1)
        console.print("[green]✓[/green] AUGGIE CLI detected and ready")

    # Branch: Brownfield vs Greenfield initialization
    if brownfield:
        initialize_brownfield_project(project_path, project_name, no_git, git_available)
        return

    # Download and set up project
    # New tree-based progress (no emojis); include earlier substeps
    tracker = StepTracker("Initialize Specify Project")
    # Flag to allow suppressing legacy headings
    sys._specify_tracker_active = True
    # Pre steps recorded as completed before live rendering
    tracker.add("precheck", "Check required tools")
    tracker.complete("precheck", "ok")
    tracker.add("ai-select", "Select AI assistant")
    tracker.complete("ai-select", f"{selected_ai}")
    for key, label in [
        ("fetch", "Fetch latest release"),
        ("download", "Download template"),
        ("extract", "Extract template"),
        ("zip-list", "Archive contents"),
        ("extracted-summary", "Extraction summary"),
        ("cleanup", "Cleanup"),
        ("git", "Initialize git repository"),
        ("final", "Finalize")
    ]:
        tracker.add(key, label)

    # Use transient so live tree is replaced by the final static render (avoids duplicate output)
    with Live(tracker.render(), console=console, refresh_per_second=8, transient=True) as live:
        tracker.attach_refresh(lambda: live.update(tracker.render()))
        try:
            # Create a httpx client with verify based on skip_tls
            verify = not skip_tls
            local_ssl_context = ssl_context if verify else False
            local_client = httpx.Client(verify=local_ssl_context)

            download_and_extract_template(project_path, selected_ai, here, verbose=False, tracker=tracker, client=local_client)

            # Git step
            if not no_git:
                tracker.start("git")
                if is_git_repo(project_path):
                    tracker.complete("git", "existing repo detected")
                elif git_available:
                    if init_git_repo(project_path, quiet=True):
                        tracker.complete("git", "initialized")
                    else:
                        tracker.error("git", "init failed")
                else:
                    tracker.skip("git", "git not available")
            else:
                tracker.skip("git", "--no-git flag")

            tracker.complete("final", "project ready")
        except Exception as e:
            tracker.error("final", str(e))
            if not here and project_path.exists():
                shutil.rmtree(project_path)
            raise typer.Exit(1)
        finally:
            # Force final render
            pass

    # Final static tree (ensures finished state visible after Live context ends)
    console.print(tracker.render())
    console.print("\n[bold green]Project ready.[/bold green]")
    
    # Boxed "Next steps" section
    steps_lines = []
    if not here:
        steps_lines.append(f"1. [bold green]cd {project_name}[/bold green]")
        step_num = 2
    else:
        steps_lines.append("1. You're already in the project directory!")
        step_num = 2

    # Enhanced AUGGIE-only workflow
    steps_lines.append(f"{step_num}. Load enhanced AUGGIE commands and start developing")
    steps_lines.append("   - Run: source templates/auggie-commands.sh")
    steps_lines.append("   - Use auggie-specify for complete specifications")
    steps_lines.append("   - Use auggie-design-spec for UI/UX specifications")
    steps_lines.append("   - Use auggie-plan for pragmatic implementation plans")
    steps_lines.append("   - Use auggie-tasks for detailed task breakdowns")
    steps_lines.append("   - See README.md for complete enhanced workflow")

    step_num += 1
    steps_lines.append(f"{step_num}. Update [bold magenta]CONSTITUTION.md[/bold magenta] with your project's non-negotiable principles")

    steps_panel = Panel("\n".join(steps_lines), title="Next steps", border_style="cyan", padding=(1,2))
    console.print()  # blank line
    console.print(steps_panel)
    
    # Removed farewell line per user request


# Add skip_tls option to check
@app.command()
def check(skip_tls: bool = typer.Option(False, "--skip-tls", help="Skip SSL/TLS verification (not recommended)")):
    """Check that all required tools are installed."""
    show_banner()
    console.print("[bold]Checking Specify requirements...[/bold]\n")

    # Check if we have internet connectivity by trying to reach GitHub API
    console.print("[cyan]Checking internet connectivity...[/cyan]")
    verify = not skip_tls
    local_ssl_context = ssl_context if verify else False
    local_client = httpx.Client(verify=local_ssl_context)
    try:
        response = local_client.get("https://api.github.com", timeout=5, follow_redirects=True)
        console.print("[green]✓[/green] Internet connection available")
    except httpx.RequestError:
        console.print("[red]✗[/red] No internet connection - required for downloading templates")
        console.print("[yellow]Please check your internet connection[/yellow]")

    console.print("\n[cyan]Optional tools:[/cyan]")
    git_ok = check_tool("git", "https://git-scm.com/downloads")
    
    console.print("\n[cyan]Required AI tool:[/cyan]")
    auggie_ok = check_tool("auggie", "Install with: npm install -g @augmentcode/auggie")
    
    console.print("\n[green]✓ Enhanced Spec-Kit is ready to use![/green]")
    if not git_ok:
        console.print("[yellow]Consider installing git for repository management[/yellow]")
    if not auggie_ok:
        console.print("[yellow]AUGGIE CLI is required for enhanced Spec-Kit functionality[/yellow]")
        console.print("[yellow]Install with: npm install -g @augmentcode/auggie[/yellow]")


# ============================================================================
# BROWNFIELD CLI COMMANDS
# ============================================================================

def detect_project_context():
    """Detect what type of project we're in."""
    cwd = Path.cwd()

    # Check for Spec-Kit multi-project workspace
    if (cwd / "projects").exists() and (cwd / "templates").exists():
        return "greenfield_workspace"

    # Check for brownfield Spec-Kit integration
    if (cwd / ".augment").exists():
        return "brownfield_project"

    # Check if we're inside a multi-project
    parent = cwd
    while parent != parent.parent:
        if (parent / "projects").exists():
            return "inside_greenfield_project"
        parent = parent.parent

    # Regular project directory
    return "regular_project"


def require_brownfield_context():
    """Ensure we're in a brownfield project context."""
    context = detect_project_context()

    if context == "greenfield_workspace":
        console.print("[red]Error:[/red] You're in a Spec-Kit workspace. Use auggie-* commands instead:")
        console.print("[yellow]Example:[/yellow] auggie-scope-spec \"project-name\" \"feature description\"")
        raise typer.Exit(1)

    if context == "inside_greenfield_project":
        console.print("[red]Error:[/red] You're inside a greenfield project. Use auggie-* commands instead.")
        raise typer.Exit(1)

    if context == "regular_project":
        console.print("[red]Error:[/red] Spec-Kit not initialized in this project.")
        console.print("[yellow]Run:[/yellow] specify init --brownfield")
        raise typer.Exit(1)

    return context == "brownfield_project"


def execute_auggie_command(command_template: str, context: str = ""):
    """Execute AUGGIE command with proper context."""
    cwd = Path.cwd()

    # Ensure AUGGIE is available
    if not shutil.which("auggie"):
        console.print("[red]Error:[/red] AUGGIE CLI not found")
        console.print("[yellow]Install with:[/yellow] npm install -g @augmentcode/auggie")
        raise typer.Exit(1)

    # Execute AUGGIE with context
    full_command = f"""
    {command_template}

    PROJECT CONTEXT:
    - Project Directory: {cwd} (current working directory)
    - Context Materials: Available in .augment/context/ directory
    - Project Guidelines: Available in .augment/guidelines.md
    - Existing Specifications: Available in specs/ directory
    - Project Constitution: Available in memory/constitution.md

    Additional Context: {context}

    IMPORTANT: This is a brownfield project integration. Use codebase-retrieval to understand existing architecture and generate specifications that fit the existing codebase.
    """

    # Run AUGGIE command
    try:
        result = subprocess.run(
            ["auggie", "--quiet", "--print", full_command],
            cwd=cwd,
            check=True,
            capture_output=False
        )
        return result.returncode == 0
    except subprocess.CalledProcessError as e:
        console.print(f"[red]Error:[/red] AUGGIE command failed with exit code {e.returncode}")
        return False


@app.command(name="scope-spec")
def scope_spec(
    description: str = typer.Argument(..., help="Feature description for scope specification"),
    complexity: str = typer.Option("simple", "--complexity", help="Complexity level: simple or enterprise"),
):
    """Generate pragmatic scope specification for existing project."""
    require_brownfield_context()

    console.print(f"[bold]Generating scope specification...[/bold]")
    console.print(f"Feature: {description}")
    console.print(f"Complexity: {complexity}")

    command_template = f"""
    Generate a comprehensive scope specification for a brownfield project.

    Use codebase-retrieval to analyze the existing codebase and understand:
    1. Current architecture and technology stack
    2. Existing patterns and conventions
    3. Current feature set and functionality
    4. Technical constraints and limitations

    Feature Description: {description}
    Complexity Level: {complexity}

    Generate a scope specification that:
    - Fits within the existing architecture
    - Respects current technical constraints
    - Builds upon existing functionality
    - Follows established patterns
    - Marks any ambiguities with [NEEDS CLARIFICATION]

    Save the specification in specs/ directory with proper feature numbering.
    """

    success = execute_auggie_command(command_template, f"Scope specification for: {description}")

    if success:
        console.print("[green]✅ Scope specification generated successfully![/green]")
        console.print("Check the specs/ directory for your new specification.")
    else:
        console.print("[red]❌ Failed to generate scope specification[/red]")


@app.command(name="design-spec")
def design_spec(
    description: str = typer.Argument(..., help="Design description for UI/UX specification"),
):
    """Generate design specification for existing project."""
    require_brownfield_context()

    console.print(f"[bold]Generating design specification...[/bold]")
    console.print(f"Design: {description}")

    command_template = f"""
    Generate a comprehensive design specification for a brownfield project.

    Use codebase-retrieval to analyze the existing codebase and understand:
    1. Current UI framework and component library
    2. Existing design patterns and styling approach
    3. Current color scheme, typography, and spacing
    4. Existing component structure and naming conventions

    Design Description: {description}

    Generate a design specification that:
    - Matches existing design system and patterns
    - Uses existing UI components where possible
    - Follows current styling conventions
    - Maintains visual consistency with existing features
    - Provides specific implementation guidance

    Save the design specification in specs/ directory.
    """

    success = execute_auggie_command(command_template, f"Design specification for: {description}")

    if success:
        console.print("[green]✅ Design specification generated successfully![/green]")
        console.print("Check the specs/ directory for your new design specification.")
    else:
        console.print("[red]❌ Failed to generate design specification[/red]")


@app.command(name="plan")
def plan(
    description: str = typer.Argument(..., help="Technical implementation details"),
):
    """Generate implementation plan for existing project."""
    require_brownfield_context()

    console.print(f"[bold]Generating implementation plan...[/bold]")
    console.print(f"Technical approach: {description}")

    command_template = f"""
    Generate a comprehensive implementation plan for a brownfield project.

    Use codebase-retrieval to analyze the existing codebase and understand:
    1. Current technology stack and dependencies
    2. Existing architecture patterns and structure
    3. Current database schema and data models
    4. Existing API patterns and endpoints
    5. Current testing and deployment setup

    Technical Implementation: {description}

    Generate an implementation plan that:
    - Leverages existing infrastructure and patterns
    - Respects current technology choices and constraints
    - Builds upon existing database schema
    - Follows established coding conventions
    - Considers existing performance and security patterns
    - Provides realistic effort estimates

    Save the implementation plan in specs/ directory.
    """

    success = execute_auggie_command(command_template, f"Implementation plan for: {description}")

    if success:
        console.print("[green]✅ Implementation plan generated successfully![/green]")
        console.print("Check the specs/ directory for your new implementation plan.")
    else:
        console.print("[red]❌ Failed to generate implementation plan[/red]")


@app.command(name="tasks")
def tasks(
    context: str = typer.Argument("", help="Additional context for task generation"),
):
    """Generate development tasks for existing project."""
    require_brownfield_context()

    console.print(f"[bold]Generating development tasks...[/bold]")
    if context:
        console.print(f"Context: {context}")

    command_template = f"""
    Generate comprehensive development tasks for a brownfield project.

    Use codebase-retrieval to analyze the existing codebase and understand:
    1. Current file structure and organization
    2. Existing development patterns and conventions
    3. Current testing setup and patterns
    4. Existing build and deployment processes

    Additional Context: {context}

    Generate development tasks that:
    - Work with existing file structure and patterns
    - Follow current development conventions
    - Integrate with existing testing framework
    - Consider existing deployment processes
    - Provide specific file paths and implementation details
    - Include realistic effort estimates
    - Mark parallel-safe tasks appropriately

    Save the tasks in specs/ directory as tasks.md or tasks.json.
    """

    success = execute_auggie_command(command_template, f"Development tasks with context: {context}")

    if success:
        console.print("[green]✅ Development tasks generated successfully![/green]")
        console.print("Check the specs/ directory for your new development tasks.")
    else:
        console.print("[red]❌ Failed to generate development tasks[/red]")


@app.command(name="status")
def status():
    """Check Spec-Kit status in current project."""
    context = detect_project_context()
    cwd = Path.cwd()

    console.print(f"[bold]Spec-Kit Status for {cwd.name}[/bold]\n")

    if context == "greenfield_workspace":
        console.print("[blue]Context:[/blue] Spec-Kit multi-project workspace")
        console.print("[yellow]Use auggie-* commands for project management[/yellow]")

    elif context == "brownfield_project":
        console.print("[blue]Context:[/blue] Brownfield Spec-Kit integration")

        # Check directory structure
        augment_exists = (cwd / ".augment").exists()
        specs_exists = (cwd / "specs").exists()
        memory_exists = (cwd / "memory").exists()

        console.print(f"[green]✓[/green] .augment/ directory: {'Present' if augment_exists else 'Missing'}")
        console.print(f"[green]✓[/green] specs/ directory: {'Present' if specs_exists else 'Missing'}")
        console.print(f"[green]✓[/green] memory/ directory: {'Present' if memory_exists else 'Missing'}")

        # Check for specifications
        if specs_exists:
            spec_files = list((cwd / "specs").glob("**/*.md"))
            console.print(f"[blue]Specifications:[/blue] {len(spec_files)} files found")

        # Check for context materials
        if augment_exists:
            context_dir = cwd / ".augment" / "context"
            if context_dir.exists():
                context_files = list(context_dir.glob("*.md"))
                console.print(f"[blue]Context materials:[/blue] {len(context_files)} files")
            else:
                console.print("[yellow]⚠[/yellow] No context materials found in .augment/context/")

        console.print("\n[green]Available commands:[/green]")
        console.print("  specify scope-spec \"feature description\"")
        console.print("  specify design-spec \"UI/UX description\"")
        console.print("  specify plan \"technical implementation\"")
        console.print("  specify tasks \"additional context\"")

    elif context == "inside_greenfield_project":
        console.print("[blue]Context:[/blue] Inside greenfield project")
        console.print("[yellow]Use auggie-* commands from the workspace root[/yellow]")

    else:
        console.print("[blue]Context:[/blue] Regular project (no Spec-Kit integration)")
        console.print("[yellow]Run 'specify init --brownfield' to add Spec-Kit[/yellow]")


def main():
    app()


if __name__ == "__main__":
    main()
