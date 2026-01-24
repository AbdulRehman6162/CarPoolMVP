# Supabase Database Operations

## Overview
This directive guides database operations for the CarPool MVP app using Supabase (PostgreSQL).

## Goal
Safely read, write, update, and delete data from Supabase while maintaining data integrity and handling errors gracefully.

## When to Use
- CRUD operations on user profiles, rides, bookings
- Querying ride availability with complex filters
- Updating ride status
- Managing user preferences
- Real-time subscriptions to data changes

## Inputs
- **Operation type**: `select`, `insert`, `update`, `upsert`, `delete`
- **Table**: e.g., `users`, `rides`, `bookings`
- **Filters**: SQL-like filter conditions
- **Data payload**: JSON object for insert/update operations
- **Order/Limit**: For pagination and sorting

## Tools & Scripts
- `execution/supabase_operations.py` - Main script for Supabase operations
- Environment variables in `.env`:
  - `SUPABASE_URL`
  - `SUPABASE_SERVICE_KEY` (for server-side operations)
  - `SUPABASE_ANON_KEY` (for client-side operations)

## Execution Flow

### 1. Select (Read) Operation
```bash
# Get single user
python execution/supabase_operations.py --operation select --table users --filter "id.eq.USER_ID"

# Get all active rides
python execution/supabase_operations.py --operation select --table rides --filter "status.eq.active"

# Complex query with ordering and limit
python execution/supabase_operations.py --operation select --table rides \
  --filter "status.eq.active,departure_time.gte.2024-01-01" \
  --order "departure_time.asc" --limit 20
```

### 2. Insert Operation
```bash
python execution/supabase_operations.py --operation insert --table rides --data-file .tmp/ride_data.json
```

### 3. Update Operation
```bash
python execution/supabase_operations.py --operation update --table rides \
  --filter "id.eq.RIDE_ID" --data-file .tmp/update_data.json
```

### 4. Upsert Operation
```bash
# Insert or update based on primary key
python execution/supabase_operations.py --operation upsert --table users --data-file .tmp/user_data.json
```

### 5. Delete Operation
```bash
python execution/supabase_operations.py --operation delete --table bookings --filter "id.eq.BOOKING_ID"
```

## Outputs
- **Success**: JSON data written to `.tmp/query_results.json`
- **Error**: Error details logged to console and `.tmp/error_log.txt`

## Supabase Filter Syntax

### Comparison Operators
- `eq` - equals
- `neq` - not equals
- `gt` - greater than
- `gte` - greater than or equal
- `lt` - less than
- `lte` - less than or equal
- `like` - pattern matching
- `ilike` - case-insensitive pattern matching
- `is` - checking for exact value (null, true, false)
- `in` - matches any value in array
- `contains` - array/range contains value
- `overlap` - arrays overlap

### Examples
```bash
# Single filter
--filter "age.gte.18"

# Multiple filters (AND)
--filter "status.eq.active,age.gte.18,city.eq.Lahore"

# Pattern matching
--filter "email.ilike.%@gmail.com"

# Array operations
--filter "tags.contains.{premium}"
```

## Edge Cases & Learnings

### Common Errors
1. **RLS (Row Level Security) Errors**: Check Supabase policies
   - Ensure user has permission to access/modify rows
   - Use service key for admin operations
2. **Foreign Key Violations**: Validate referenced records exist
3. **Unique Constraint Violations**: Check for duplicates before insert
4. **Connection Timeout**: Implement retry logic with exponential backoff
5. **Rate Limiting**: Supabase has generous limits but monitor usage

### Best Practices
- Always use parameterized queries (prevents SQL injection)
- Use RLS policies for security, don't rely on client-side checks
- Use `upsert` for idempotent operations
- Create indexes for frequently queried columns
- Use `select` with specific columns instead of `*` when possible
- Batch operations when inserting/updating multiple records
- Use Supabase real-time for live data subscriptions

### Performance Tips
- Index foreign keys and commonly filtered columns
- Use `limit` and `offset` for pagination
- Avoid N+1 queries (use joins or batch requests)
- Cache frequently accessed, rarely changed data
- Use connection pooling for high-traffic scenarios

### PostgreSQL-Specific Features
- **JSONB columns**: Store and query JSON data efficiently
- **Full-text search**: Use `textSearch` for searching text
- **Geospatial queries**: Use PostGIS for location-based queries
- **Array columns**: Store arrays directly in columns
- **Computed columns**: Use PostgreSQL functions

## Security Considerations
- Use anon key for client-side operations
- Use service key only for server-side admin operations
- Never expose service key in client code
- Implement RLS policies for all tables
- Validate all user input before database operations
- Use environment variables for keys, never hardcode

## Real-Time Subscriptions
For live updates, use Supabase real-time:
```bash
# Subscribe to changes on rides table
python execution/supabase_operations.py --operation subscribe --table rides --filter "status.eq.active"
```

## Testing
- Use a separate Supabase project for development/testing
- Create test data in `.tmp/test_fixtures/`
- Clean up test data after running tests
- Mock Supabase responses for unit tests

## Notes
- All intermediate query results go to `.tmp/`
- Never expose sensitive data in logs
- Use `.env` for credentials, never hardcode
- Supabase uses PostgreSQL, so you can use standard SQL features
- Migration files should be tracked in version control
