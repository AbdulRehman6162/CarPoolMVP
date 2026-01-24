# Directives - Standard Operating Procedures

This directory contains SOPs (Standard Operating Procedures) for common tasks in the CarPool MVP project.

## Purpose
Directives are **natural language instructions** that tell AI assistants (and developers):
- What the goal is
- What inputs are needed
- What tools/scripts to use
- What outputs to expect
- Common edge cases and solutions

## Current Directives

### 1. [supabase_operations.md](supabase_operations.md)
Database CRUD operations using Supabase (PostgreSQL)
- Read/write/update/delete/upsert operations
- Complex query filtering
- Real-time subscriptions
- Row Level Security (RLS)

### 2. [supabase_auth.md](supabase_auth.md)
Authentication using Supabase Auth for Google & Apple Sign-In
- OAuth integration (Google, Apple)
- Session management and token refresh
- User metadata and profiles
- Security best practices with RLS

### 3. [firebase_notifications.md](firebase_notifications.md)
Push notifications using Firebase Cloud Messaging (FCM)
- Single device notifications
- Topic-based notifications
- Batch sending
- Token management

### 4. [testing_workflow.md](testing_workflow.md)
Automated testing for Flutter app
- Unit, widget, and integration tests
- Coverage reporting
- CI/CD integration

## How to Use

### For AI Assistants
When asked to perform a task (e.g., "query active rides"):
1. Check if a directive exists for that task
2. Read the directive to understand the goal and tools
3. Run the appropriate execution script with correct parameters
4. Handle errors according to the directive
5. Update the directive if you learn something new

### For Developers
1. Read the relevant directive before implementing
2. Follow the documented workflow
3. Update the directive when you discover edge cases
4. Add new directives for recurring tasks

## Creating New Directives

Use this template:

```markdown
# [Task Name]

## Overview
Brief description of what this directive handles

## Goal
What you're trying to achieve

## When to Use
Situations where this directive applies

## Inputs
- Parameter 1: Description
- Parameter 2: Description

## Tools & Scripts
- execution/script_name.py
- Environment variables needed

## Execution Flow
Step-by-step instructions with example commands

## Outputs
What files/data get generated

## Edge Cases & Learnings
Common errors and how to handle them

## Notes
Additional context or warnings
```

## Best Practices

- ✅ Update directives when you learn new patterns
- ✅ Document error cases and solutions
- ✅ Keep directives focused on one task area
- ✅ Use real examples in execution flow
- ❌ Don't make directives too prescriptive (allow for AI decision-making)
- ❌ Don't duplicate information across directives
