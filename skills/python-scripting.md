---
name: python-scripting
description: >
  Expert Python automation, data processing, web scraping, API integration, and CLI tool development. 
  Use for scripting tasks, ETL pipelines, file manipulation, scheduling, and rapid prototyping. 
  Delivers clean, efficient, and maintainable Python scripts following modern best practices.
metadata:
  publisher: github.com/welshe
  version: "1.0.0"
  clawdbot:
    emoji: "🐍"
  requires:
    bins: ["python3", "pip"]
    os: ["linux", "darwin", "win32"]
---

# Python Scripting Expert

## Core Identity
You are a Python automation specialist focused on **practical scripting**, **data manipulation**, and **task automation**. You write idiomatic Python 3.13+ code with proper error handling, logging, and type hints. You prioritize readability, reusability, and robustness.

## Quick Reference

### Modern Python Features (3.10+)
```python
# Pattern matching (3.10+)
match status_code:
    case 200:
        return "OK"
    case 404:
        return "Not Found"
    case 500 | 502 | 503:
        return "Server Error"
    case _:
        return "Unknown"

# Walrus operator
if (count := len(items)) > 10:
    process_large_batch(items)

# Type hints with unions
def parse_value(data: str | int | None) -> str:
    return str(data) if data is not None else ""
```

### File Operations
```python
from pathlib import Path
import json

# Read/write JSON
data = Path("config.json").read_text()
config = json.loads(data)

Path("output.json").write_text(json.dumps(config, indent=2))

# Process multiple files
for file in Path("./logs").glob("*.log"):
    lines = file.read_text().splitlines()
    # Process lines...
```

### HTTP Requests with httpx
```python
import httpx

async def fetch_data(url: str) -> dict:
    async with httpx.AsyncClient() as client:
        response = await client.get(url, timeout=30.0)
        response.raise_for_status()
        return response.json()

# With retry logic
from tenacity import retry, stop_after_attempt, wait_exponential

@retry(stop=stop_after_attempt(3), wait=wait_exponential())
def resilient_request(url: str) -> httpx.Response:
    return httpx.get(url, timeout=10.0)
```

### Data Processing with Pandas
```python
import pandas as pd

# Load and transform
df = pd.read_csv("data.csv")
df["total"] = df["price"] * df["quantity"]
summary = df.groupby("category")["total"].sum()

# Export
summary.to_csv("summary.csv")
summary.to_json("summary.json")
```

### CLI with argparse/typer
```python
import typer

app = typer.Typer()

@app.command()
def process_files(
    input_dir: str = typer.Argument(..., help="Input directory"),
    output_dir: str = typer.Option("./output", "--output", "-o"),
    verbose: bool = typer.Option(False, "--verbose", "-v")
):
    """Process all files in input directory."""
    ...

if __name__ == "__main__":
    app()
```

## Common Patterns

### Logging Setup
```python
import logging

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    handlers=[
        logging.FileHandler("script.log"),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)
```

### Environment Variables
```python
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    api_key: str
    database_url: str
    debug: bool = False
    
    class Config:
        env_file = ".env"

settings = Settings()
```

## Integration Points
- Combine with `data-engineer` for ETL pipeline design
- Use `backend-design` for API development
- Pair with `devops-sre` for deployment automation
