# AGENTS.md Architecture - README

This directory structure follows the 3-layer architecture defined in AGENTS.md.

## Directory Structure

```
CarPoolMVP/
├── directives/              # Layer 1: What to do (instructions)
│   ├── supabase_operations.md
│   ├── supabase_auth.md
│   ├── firebase_notifications.md
│   └── testing_workflow.md
│
├── execution/               # Layer 3: Doing the work (scripts)
│   ├── supabase_operations.py
│   ├── firebase_notifications.py
│   ├── run_tests.py
│   └── requirements.txt
│
├── .tmp/                    # Intermediate files (never commit)
│   ├── query_results.json
│   ├── error_log.txt
│   └── test_results.json
│
└── .env                     # Environment variables (never commit)
```

## Quick Start

### 1. Install Python Dependencies
```bash
cd execution
pip install -r requirements.txt
```

### 2. Configure Environment
```bash
# Copy the example and fill in your values
cp .env.example .env
# Edit .env with your credentials
```

### 3. Add Supabase Credentials
- Go to your Supabase project dashboard
- Copy your project URL and anon key
- Update `SUPABASE_URL` and `SUPABASE_ANON_KEY` in `.env`
- For admin operations, also add `SUPABASE_SERVICE_KEY`

### 4. Add Firebase Credentials (for Push Notifications)
- Download `credentials.json` from Firebase Console
- Place it in the project root
- Update `FIREBASE_CREDENTIALS_PATH` in `.env`

### 5. Using the Architecture

**Example: Running Supabase Database Operations**
```bash
# Read a user profile
python execution/supabase_operations.py --operation select --table users --filter "id.eq.USER123"

# Query active rides
python execution/supabase_operations.py --operation select --table rides --filter "status.eq.active" --limit 20

# Insert new ride
python execution/supabase_operations.py --operation insert --table rides --data-file .tmp/ride_data.json
```

**Example: Sending Push Notifications**
```bash
# Send notification to single device
python execution/firebase_notifications.py --type single --token DEVICE_TOKEN --title "Ride Confirmed" --body "Your ride is confirmed"

# Send to topic (broadcast)
python execution/firebase_notifications.py --type topic --topic ride_updates --title "New Ride" --body "Check out new rides"
```

**Example: Running Tests**
```bash
# Run all tests with coverage
python execution/run_tests.py --all --coverage

# Run only unit tests
python execution/run_tests.py --suite unit
```

## How AI Assistants Use This

When you ask AI to help with:
1. **Database operations** → AI reads `directives/supabase_operations.md` → Runs `execution/supabase_operations.py`
2. **Authentication** → AI reads `directives/supabase_auth.md` → Implements auth flow using Supabase
3. **Push notifications** → AI reads `directives/firebase_notifications.md` → Runs `execution/firebase_notifications.py`
4. **Testing** → AI reads `directives/testing_workflow.md` → Runs `execution/run_tests.py`

## Adding New Workflows

1. Create a directive in `directives/new_workflow.md`
2. Create an execution script in `execution/new_workflow.py`
3. Update this README with usage examples
4. AI will automatically discover and use the new workflow

## Best Practices

- ✅ All intermediate files go to `.tmp/`
- ✅ All credentials go to `.env` (never commit)
- ✅ Update directives when you learn new patterns
- ✅ Keep execution scripts deterministic and testable
- ❌ Never hardcode credentials in scripts
- ❌ Never commit `.tmp/` or `.env` to git
