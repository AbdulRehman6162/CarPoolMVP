"""
Flutter Testing Orchestration Script
Runs unit, widget, and integration tests with coverage reporting

Usage:
    python run_tests.py --all
    python run_tests.py --suite unit
    python run_tests.py --suite widget --coverage
    python run_tests.py --watch --suite unit
"""

import argparse
import subprocess
import sys
import json
from pathlib import Path
from datetime import datetime
from typing import List, Dict


class FlutterTestRunner:
    def __init__(self, project_root: Path):
        self.project_root = project_root
        self.results = {
            'timestamp': datetime.now().isoformat(),
            'suites': {},
            'overall_status': 'pending'
        }
    
    def run_unit_tests(self, coverage: bool = False) -> bool:
        """Run unit tests"""
        print("\n" + "="*60)
        print("Running Unit Tests")
        print("="*60 + "\n")
        
        cmd = ['flutter', 'test', 'test/']
        if coverage:
            cmd.append('--coverage')
        
        result = self._run_command(cmd)
        self.results['suites']['unit'] = {
            'status': 'passed' if result else 'failed',
            'exit_code': 0 if result else 1
        }
        return result
    
    def run_widget_tests(self, coverage: bool = False) -> bool:
        """Run widget tests"""
        print("\n" + "="*60)
        print("Running Widget Tests")
        print("="*60 + "\n")
        
        # Assuming widget tests are in test/widgets/
        widget_test_path = self.project_root / 'test' / 'widgets'
        
        if not widget_test_path.exists():
            print(f"Warning: Widget test directory not found at {widget_test_path}")
            return True
        
        cmd = ['flutter', 'test', str(widget_test_path)]
        if coverage:
            cmd.append('--coverage')
        
        result = self._run_command(cmd)
        self.results['suites']['widget'] = {
            'status': 'passed' if result else 'failed',
            'exit_code': 0 if result else 1
        }
        return result
    
    def run_integration_tests(self) -> bool:
        """Run integration tests"""
        print("\n" + "="*60)
        print("Running Integration Tests")
        print("="*60 + "\n")
        
        integration_test_path = self.project_root / 'integration_test'
        
        if not integration_test_path.exists():
            print(f"Warning: Integration test directory not found at {integration_test_path}")
            return True
        
        cmd = ['flutter', 'test', str(integration_test_path)]
        
        result = self._run_command(cmd)
        self.results['suites']['integration'] = {
            'status': 'passed' if result else 'failed',
            'exit_code': 0 if result else 1
        }
        return result
    
    def run_all(self, coverage: bool = False) -> bool:
        """Run all test suites"""
        results = []
        results.append(self.run_unit_tests(coverage))
        results.append(self.run_widget_tests(coverage))
        results.append(self.run_integration_tests())
        
        return all(results)
    
    def watch_mode(self, suite: str):
        """Run tests in watch mode (re-run on file changes)"""
        print(f"\nRunning {suite} tests in watch mode...")
        print("Press Ctrl+C to stop\n")
        
        # This is a simplified implementation
        # For a real watch mode, you'd use a file watcher
        if suite == 'unit':
            cmd = ['flutter', 'test', '--watch', 'test/']
        elif suite == 'widget':
            cmd = ['flutter', 'test', '--watch', 'test/widgets/']
        else:
            print(f"Watch mode not supported for {suite} tests")
            return
        
        try:
            subprocess.run(cmd, cwd=self.project_root)
        except KeyboardInterrupt:
            print("\nWatch mode stopped")
    
    def _run_command(self, cmd: List[str]) -> bool:
        """Run a command and return success status"""
        try:
            result = subprocess.run(
                cmd,
                cwd=self.project_root,
                capture_output=False,
                text=True
            )
            return result.returncode == 0
        except Exception as e:
            print(f"Error running command: {e}")
            self._log_error(e)
            return False
    
    def save_results(self, output_path: Path):
        """Save test results to JSON"""
        output_path.parent.mkdir(parents=True, exist_ok=True)
        
        # Determine overall status
        all_passed = all(
            suite['status'] == 'passed' 
            for suite in self.results['suites'].values()
        )
        self.results['overall_status'] = 'passed' if all_passed else 'failed'
        
        with open(output_path, 'w') as f:
            json.dump(self.results, f, indent=2)
        
        print(f"\nResults saved to {output_path}")
    
    def _log_error(self, error: Exception):
        """Log error to file"""
        error_log_path = Path('.tmp/failed_tests.log')
        error_log_path.parent.mkdir(exist_ok=True)
        
        with open(error_log_path, 'a') as f:
            f.write(f"\n[{datetime.now().isoformat()}] {str(error)}\n")


def main():
    parser = argparse.ArgumentParser(description='Flutter Test Runner')
    parser.add_argument('--all', action='store_true', 
                       help='Run all test suites')
    parser.add_argument('--suite', choices=['unit', 'widget', 'integration'],
                       help='Run specific test suite')
    parser.add_argument('--coverage', action='store_true',
                       help='Generate coverage report')
    parser.add_argument('--watch', action='store_true',
                       help='Run in watch mode (re-run on changes)')
    parser.add_argument('--output', default='.tmp/test_results.json',
                       help='Output file for test results')
    
    args = parser.parse_args()
    
    # Get project root (parent of execution/ directory)
    project_root = Path(__file__).parent.parent
    
    runner = FlutterTestRunner(project_root)
    
    if args.watch:
        if not args.suite:
            print("Error: --suite required for watch mode")
            sys.exit(1)
        runner.watch_mode(args.suite)
        return
    
    success = False
    
    if args.all:
        success = runner.run_all(args.coverage)
    elif args.suite:
        if args.suite == 'unit':
            success = runner.run_unit_tests(args.coverage)
        elif args.suite == 'widget':
            success = runner.run_widget_tests(args.coverage)
        elif args.suite == 'integration':
            success = runner.run_integration_tests()
    else:
        print("Error: Either --all or --suite must be specified")
        parser.print_help()
        sys.exit(1)
    
    runner.save_results(Path(args.output))
    
    if not success:
        print("\n❌ Tests FAILED")
        sys.exit(1)
    else:
        print("\n✅ All tests PASSED")


if __name__ == '__main__':
    main()
