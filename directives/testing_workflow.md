# Flutter Testing Workflow

## Overview
Automated testing workflow for Flutter CarPool MVP: unit tests, widget tests, and integration tests.

## Goal
Ensure code quality, catch regressions early, and maintain >80% test coverage for critical paths.

## When to Use
- Before committing code changes
- Before deploying to staging/production
- After refactoring
- When adding new features

## Tools & Scripts
- `execution/run_tests.py` - Orchestrates all test suites
- `execution/coverage_report.py` - Generates coverage reports
- Flutter CLI commands

## Execution Flow

### 1. Run All Tests
```bash
python execution/run_tests.py --all
```

### 2. Run Specific Test Suite
```bash
# Unit tests only
python execution/run_tests.py --suite unit

# Widget tests only
python execution/run_tests.py --suite widget

# Integration tests only
python execution/run_tests.py --suite integration
```

### 3. Generate Coverage Report
```bash
python execution/coverage_report.py --output .tmp/coverage/
```

### 4. Watch Mode (Development)
```bash
python execution/run_tests.py --watch --suite unit
```

## Outputs
- **Test results**: Console output + `.tmp/test_results.json`
- **Coverage report**: HTML report in `.tmp/coverage/index.html`
- **Failed tests**: Detailed logs in `.tmp/failed_tests.log`

## Critical Test Areas

### Authentication Flow
- Sign in with Google
- Sign in with Apple
- Token refresh
- Sign out
- Account recovery

### Ride Management
- Create ride
- Search rides
- Book ride
- Cancel booking
- Ride completion

### User Profile
- Update profile
- Upload photo
- Preferences
- Notifications

## Edge Cases & Learnings

### Common Test Failures
1. **Async Timing Issues**: Use `await tester.pumpAndSettle()`
2. **Widget Not Found**: Check widget tree with `debugDumpApp()`
3. **Firebase Mock Issues**: Ensure proper mock initialization
4. **Platform-Specific Code**: Use platform channels for iOS/Android specific tests

### Performance Benchmarks
- App startup: < 2 seconds
- Ride search: < 500ms
- Profile load: < 300ms

### CI/CD Integration
- Run tests on every PR
- Block merge if coverage drops below 80%
- Run integration tests on staging environment
- Performance regression tests for critical paths

## Pre-Release Checklist
- [ ] All unit tests passing
- [ ] All widget tests passing
- [ ] Integration tests on iOS
- [ ] Integration tests on Android
- [ ] Coverage > 80% for critical paths
- [ ] No performance regressions
- [ ] Manual smoke test on real devices

## Notes
- Mock expensive operations (Firebase, API calls)
- Use golden tests for UI consistency
- Keep integration tests focused and fast
- Update test data fixtures in `.tmp/test_fixtures/`
