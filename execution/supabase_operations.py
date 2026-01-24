"""
Supabase Database Operations Script
Handles CRUD operations for Supabase PostgreSQL database

Usage:
    python supabase_operations.py --operation select --table users --filter "id.eq.USER_ID"
    python supabase_operations.py --operation insert --table rides --data-file data.json
    python supabase_operations.py --operation select --table rides --filter "status.eq.active" --limit 20
"""

import argparse
import json
import sys
from pathlib import Path
from typing import Dict, Any, Optional, List
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Requires supabase-py
# Install: pip install supabase python-dotenv

try:
    from supabase import create_client, Client
except ImportError:
    print("Error: supabase not installed. Run: pip install supabase python-dotenv")
    sys.exit(1)


class SupabaseOperations:
    def __init__(self, use_service_key: bool = False):
        """Initialize Supabase client"""
        url = os.getenv('SUPABASE_URL')
        
        if use_service_key:
            key = os.getenv('SUPABASE_SERVICE_KEY')
        else:
            key = os.getenv('SUPABASE_ANON_KEY')
        
        if not url or not key:
            raise ValueError("Missing SUPABASE_URL or SUPABASE_ANON_KEY/SUPABASE_SERVICE_KEY in .env")
        
        self.client: Client = create_client(url, key)
    
    def select(self, table: str, filters: Optional[str] = None, 
               order: Optional[str] = None, limit: Optional[int] = None,
               columns: str = "*") -> List[Dict]:
        """Select data from Supabase table
        
        Args:
            table: Table name
            filters: Comma-separated filters (e.g., "status.eq.active,age.gte.18")
            order: Column to order by with direction (e.g., "created_at.desc")
            limit: Maximum number of rows to return
            columns: Columns to select (default: "*")
        """
        try:
            query = self.client.table(table).select(columns)
            
            # Apply filters
            if filters:
                for filter_str in filters.split(','):
                    filter_str = filter_str.strip()
                    # Parse filter: "column.operator.value"
                    parts = filter_str.split('.')
                    if len(parts) >= 3:
                        column = parts[0]
                        operator = parts[1]
                        value = '.'.join(parts[2:])  # Handle values with dots
                        
                        # Apply the appropriate filter method
                        if operator == 'eq':
                            query = query.eq(column, value)
                        elif operator == 'neq':
                            query = query.neq(column, value)
                        elif operator == 'gt':
                            query = query.gt(column, value)
                        elif operator == 'gte':
                            query = query.gte(column, value)
                        elif operator == 'lt':
                            query = query.lt(column, value)
                        elif operator == 'lte':
                            query = query.lte(column, value)
                        elif operator == 'like':
                            query = query.like(column, value)
                        elif operator == 'ilike':
                            query = query.ilike(column, value)
                        elif operator == 'is':
                            query = query.is_(column, value)
                        elif operator == 'in':
                            # Expect value as array-like string
                            values = value.strip('()[]').split(',')
                            query = query.in_(column, values)
            
            # Apply ordering
            if order:
                parts = order.split('.')
                if len(parts) == 2:
                    column, direction = parts
                    ascending = direction.lower() == 'asc'
                    query = query.order(column, desc=not ascending)
            
            # Apply limit
            if limit:
                query = query.limit(limit)
            
            response = query.execute()
            print(f"Selected {len(response.data)} rows from {table}")
            return response.data
            
        except Exception as e:
            print(f"Error selecting from {table}: {e}")
            self._log_error(e)
            return []
    
    def insert(self, table: str, data: Dict | List[Dict]) -> bool:
        """Insert data into Supabase table"""
        try:
            response = self.client.table(table).insert(data).execute()
            print(f"Successfully inserted data into {table}")
            return True
        except Exception as e:
            print(f"Error inserting into {table}: {e}")
            self._log_error(e)
            return False
    
    def update(self, table: str, data: Dict, filters: str) -> bool:
        """Update data in Supabase table"""
        try:
            query = self.client.table(table).update(data)
            
            # Apply filters (same logic as select)
            if filters:
                for filter_str in filters.split(','):
                    filter_str = filter_str.strip()
                    parts = filter_str.split('.')
                    if len(parts) >= 3:
                        column = parts[0]
                        operator = parts[1]
                        value = '.'.join(parts[2:])
                        
                        if operator == 'eq':
                            query = query.eq(column, value)
                        elif operator == 'neq':
                            query = query.neq(column, value)
            
            response = query.execute()
            print(f"Successfully updated {table}")
            return True
        except Exception as e:
            print(f"Error updating {table}: {e}")
            self._log_error(e)
            return False
    
    def upsert(self, table: str, data: Dict | List[Dict]) -> bool:
        """Upsert (insert or update) data in Supabase table"""
        try:
            response = self.client.table(table).upsert(data).execute()
            print(f"Successfully upserted data into {table}")
            return True
        except Exception as e:
            print(f"Error upserting into {table}: {e}")
            self._log_error(e)
            return False
    
    def delete(self, table: str, filters: str) -> bool:
        """Delete data from Supabase table"""
        try:
            query = self.client.table(table).delete()
            
            # Apply filters
            if filters:
                for filter_str in filters.split(','):
                    filter_str = filter_str.strip()
                    parts = filter_str.split('.')
                    if len(parts) >= 3:
                        column = parts[0]
                        operator = parts[1]
                        value = '.'.join(parts[2:])
                        
                        if operator == 'eq':
                            query = query.eq(column, value)
            
            response = query.execute()
            print(f"Successfully deleted from {table}")
            return True
        except Exception as e:
            print(f"Error deleting from {table}: {e}")
            self._log_error(e)
            return False
    
    def _log_error(self, error: Exception):
        """Log error to file"""
        error_log_path = Path('.tmp/error_log.txt')
        error_log_path.parent.mkdir(exist_ok=True)
        
        with open(error_log_path, 'a') as f:
            from datetime import datetime
            f.write(f"\n[{datetime.now().isoformat()}] {str(error)}\n")


def main():
    parser = argparse.ArgumentParser(description='Supabase Database Operations')
    parser.add_argument('--operation', required=True,
                       choices=['select', 'insert', 'update', 'upsert', 'delete'],
                       help='Operation to perform')
    parser.add_argument('--table', required=True, help='Table name')
    parser.add_argument('--filter', help='Filters (e.g., "status.eq.active,age.gte.18")')
    parser.add_argument('--data-file', help='JSON file with data (for insert/update/upsert)')
    parser.add_argument('--data', help='JSON string with data (for insert/update/upsert)')
    parser.add_argument('--order', help='Order by (e.g., "created_at.desc")')
    parser.add_argument('--limit', type=int, help='Limit number of rows')
    parser.add_argument('--columns', default='*', help='Columns to select (default: "*")')
    parser.add_argument('--output', default='.tmp/query_results.json',
                       help='Output file for results')
    parser.add_argument('--use-service-key', action='store_true',
                       help='Use service key instead of anon key')
    
    args = parser.parse_args()
    
    sb = SupabaseOperations(use_service_key=args.use_service_key)
    
    if args.operation == 'select':
        results = sb.select(
            table=args.table,
            filters=args.filter,
            order=args.order,
            limit=args.limit,
            columns=args.columns
        )
        
        # Save to output file
        output_path = Path(args.output)
        output_path.parent.mkdir(exist_ok=True, parents=True)
        with open(output_path, 'w') as f:
            json.dump(results, f, indent=2)
        print(f"Results saved to {output_path}")
    
    elif args.operation in ['insert', 'upsert']:
        data = None
        if args.data_file:
            with open(args.data_file) as f:
                data = json.load(f)
        elif args.data:
            data = json.loads(args.data)
        else:
            print(f"Error: --data-file or --data required for {args.operation} operation")
            sys.exit(1)
        
        if args.operation == 'insert':
            success = sb.insert(args.table, data)
        else:
            success = sb.upsert(args.table, data)
        
        sys.exit(0 if success else 1)
    
    elif args.operation == 'update':
        if not args.filter:
            print("Error: --filter required for update operation")
            sys.exit(1)
        
        data = None
        if args.data_file:
            with open(args.data_file) as f:
                data = json.load(f)
        elif args.data:
            data = json.loads(args.data)
        else:
            print("Error: --data-file or --data required for update operation")
            sys.exit(1)
        
        success = sb.update(args.table, data, args.filter)
        sys.exit(0 if success else 1)
    
    elif args.operation == 'delete':
        if not args.filter:
            print("Error: --filter required for delete operation")
            sys.exit(1)
        
        success = sb.delete(args.table, args.filter)
        sys.exit(0 if success else 1)


if __name__ == '__main__':
    main()
