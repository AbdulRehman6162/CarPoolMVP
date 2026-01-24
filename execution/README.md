# Execution Scripts - Deterministic Tools

This directory contains **deterministic Python scripts** that do the actual work.

## Purpose
Execution scripts:
- Handle API calls
- Process data
- Interact with databases
- Run tests
- Generate reports

**Key principle:** These scripts should be reliable, testable, and fast. They implement the work described in directives.

## Current Scripts

### 1. [supabase_operations.py](supabase_operations.py)
Supabase database operations (CRUD + queries)

**Usage:**
```bash
python supabase_operations.py --operation select --table users --filter "id.eq.USER123"
python supabase_operations.py --operation select --table rides --filter "status.eq.active" --limit 20
```

### 2. [firebase_notifications.py](firebase_notifications.py)
Firebase Cloud Messaging for push notifications

**Usage:**
```bash
python firebase_notifications.py --type single --token TOKEN --title "Title" --body "Body"
python firebase_notifications.py --type topic --topic updates --title "Title" --body "Body"
```

### 3. [run_tests.py](run_tests.py)
Flutter test orchestration with coverage

**Usage:**
```bash
python run_tests.py --all --coverage
python run_tests.py --suite unit --watch
```

## Setup

### Install Dependencies
```bash
pip install -r requirements.txt
```

### Configure Environment
```bash
cp ../.env.example ../.env
# Edit .env with your credentials
```

## Creating New Scripts

### Template Structure
```python
"""
Script Description
Brief explanation of what this script does

Usage:
    python script_name.py --arg1 value1 --arg2 value2
"""

import argparse
import sys
from pathlib import Path
from dotenv import load_dotenv

load_dotenv()


class ScriptName:
    def __init__(self):
        """Initialize with environment variables"""
        pass
    
    def main_function(self, param1, param2):
        """Main logic here"""
        try:
            # Implementation
            return True
        except Exception as e:
            self._log_error(e)
            return False
    
    def _log_error(self, error: Exception):
        """Log errors to .tmp/"""
        error_log = Path('.tmp/error_log.txt')
        error_log.parent.mkdir(exist_ok=True)
        with open(error_log, 'a') as f:
            from datetime import datetime
            f.write(f"[{datetime.now().isoformat()}] {str(error)}\n")


def main():
    parser = argparse.ArgumentParser(description='Script description')
    parser.add_argument('--arg1', required=True, help='Argument 1')
    parser.add_argument('--arg2', help='Optional argument 2')
    
    args = parser.parse_args()
    
    script = ScriptName()
    success = script.main_function(args.arg1, args.arg2)
    
    sys.exit(0 if success else 1)


if __name__ == '__main__':
    main()
```

## Best Practices

### ✅ Do
- Use environment variables for credentials (never hardcode)
- Log errors to `.tmp/` directory
- Use argparse for command-line arguments
- Write docstrings for all functions
- Handle exceptions gracefully
- Return meaningful exit codes (0 = success, 1 = failure)
- Save intermediate results to `.tmp/`
- Comment complex logic

### ❌ Don't
- Hardcode credentials or API keys
- Print sensitive information to console
- Use global variables
- Make scripts dependent on each other (keep them modular)
- Commit temporary files
- Modify production data without confirmation

## Testing Scripts

Each script should be testable independently:

```bash
# Test with sample data
python script_name.py --arg1 test_value --dry-run

# Run with verbose output
python script_name.py --arg1 value --verbose
```

## Adding to Directives

When you create a new script:
1. Create the script in this directory
2. Add dependencies to `requirements.txt`
3. Create a corresponding directive in `directives/`
4. Update execution/README.md (this file)
5. Test the script thoroughly
