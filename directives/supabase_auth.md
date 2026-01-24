# Supabase Authentication (Google & Apple Sign-In)

## Overview
This directive handles authentication flows using Supabase Auth for Google and Apple ID sign-in in the CarPool MVP.

## Goal
Implement secure, reliable authentication using Supabase's built-in OAuth providers, handling sessions, token refresh, and account recovery.

## When to Use
- Setting up OAuth providers in Supabase
- Implementing sign-in flows
- Managing user sessions
- Handling token refresh
- Implementing account recovery
- Managing user metadata and profiles

## Inputs
- **Provider**: `google` or `apple`
- **Auth action**: `signin`, `signout`, `refresh`, `get_session`
- **Redirect URI**: From app configuration
- **Scopes**: OAuth scopes requested

## Tools & Scripts
- `execution/supabase_auth.py` - Main authentication handler
- Supabase Dashboard for provider configuration
- Environment variables in `.env`:
  - `SUPABASE_URL`
  - `SUPABASE_ANON_KEY`
  - `SUPABASE_SERVICE_KEY`
  - `GOOGLE_CLIENT_ID` (configured in Supabase Dashboard)
  - `GOOGLE_CLIENT_SECRET` (configured in Supabase Dashboard)
  - `APPLE_CLIENT_ID` (configured in Supabase Dashboard)

## Execution Flow

### 1. Sign In with OAuth
```bash
# Initiate Google sign-in
python execution/supabase_auth.py --action signin --provider google

# Initiate Apple sign-in
python execution/supabase_auth.py --action signin --provider apple
```

### 2. Get Current Session
```bash
python execution/supabase_auth.py --action get_session
```

### 3. Refresh Session
```bash
python execution/supabase_auth.py --action refresh --refresh-token REFRESH_TOKEN
```

### 4. Sign Out
```bash
python execution/supabase_auth.py --action signout
```

### 5. Get User Profile
```bash
python execution/supabase_auth.py --action get_user
```

## Outputs
- **Session data**: Saved to `.tmp/session.json`
- **User profile**: Saved to `.tmp/user_profile.json`
- **Error details**: Logged to `.tmp/auth_errors.log`

## Supabase Auth Flow

### OAuth Sign-In Process
1. **Initiate OAuth**: App redirects to Supabase Auth with provider
2. **User Consent**: User approves on Google/Apple
3. **Callback**: Supabase processes OAuth response
4. **Session Creation**: Supabase creates session with access/refresh tokens
5. **User Creation**: User record created in `auth.users` table
6. **Profile Sync**: Sync user data to `public.users` table

### Session Management
- **Access Token**: Short-lived (1 hour), use for API calls
- **Refresh Token**: Long-lived, use to get new access tokens
- **Auto-refresh**: Supabase client handles auto-refresh
- **Session Persistence**: Store in secure storage, not `.tmp/`

## Supabase Dashboard Configuration

### Google OAuth Setup
1. Go to Supabase Dashboard → Authentication → Providers
2. Enable Google provider
3. Add Google Client ID and Secret (from Google Cloud Console)
4. Configure authorized redirect URIs:
   - `https://YOUR_PROJECT.supabase.co/auth/v1/callback`
   - Add your app's custom URL scheme for mobile

### Apple Sign-In Setup
1. Go to Supabase Dashboard → Authentication → Providers
2. Enable Apple provider
3. Add Apple Service ID, Team ID, Key ID, and Private Key
4. Configure redirect URIs (same as Google)

### Email Confirmations & Redirects
- Configure email templates in Supabase Dashboard
- Set redirect URLs for email confirmations
- Customize email templates for your brand

## Edge Cases & Learnings

### Common Errors
1. **Invalid Redirect URI**: Must match exactly in both provider console and Supabase
2. **Session Expired**: Implement automatic refresh before expiry
3. **User Cancelled**: Handle gracefully, allow retry
4. **Email Already Registered**: Supabase links accounts by email automatically
5. **Network Errors**: Retry with exponential backoff
6. **Missing Scopes**: Request necessary OAuth scopes

### Security Considerations
- Never log access or refresh tokens
- Use PKCE flow for mobile OAuth
- Validate all auth responses server-side
- Store tokens encrypted in secure storage
- Implement session timeout and refresh
- Use Supabase RLS to enforce auth policies
- Enable email confirmation for new signups

### Apple-Specific Notes
- Apple requires "Sign in with Apple" capability in Xcode
- User email may be private relay address
- User name only provided on first sign-in
- Handle missing email gracefully
- Verify JWT signature from Apple servers

### Google-Specific Notes
- Request only necessary scopes
- Cache user profile to reduce API calls
- Handle scope changes gracefully
- Implement proper consent screen
- Support incremental authorization

## Supabase-Specific Features

### Row Level Security (RLS)
Create policies that use `auth.uid()`:
```sql
-- Users can only read their own profile
CREATE POLICY "Users can view own profile" 
ON public.users FOR SELECT 
USING (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY "Users can update own profile" 
ON public.users FOR UPDATE 
USING (auth.uid() = id);
```

### User Metadata
Store additional data in user metadata:
```bash
# Update user metadata
python execution/supabase_auth.py --action update_metadata \
  --data '{"preferences": {"notifications": true}}'
```

### Email Verification
```bash
# Resend verification email
python execution/supabase_auth.py --action resend_verification
```

### Password Reset (if using email/password)
```bash
# Send password reset email
python execution/supabase_auth.py --action reset_password --email user@example.com
```

## Testing Checklist
- [ ] First-time Google sign-in flow
- [ ] First-time Apple sign-in flow
- [ ] Returning user sign-in
- [ ] Session refresh (automatic)
- [ ] Session refresh (manual with expired token)
- [ ] Account linking (same email, different provider)
- [ ] Sign-out (local and server-side)
- [ ] Error handling (network, user cancellation)
- [ ] RLS policies work correctly
- [ ] User profile sync to public.users table

## Database Schema

### Recommended `public.users` table
```sql
CREATE TABLE public.users (
  id UUID REFERENCES auth.users PRIMARY KEY,
  email TEXT,
  full_name TEXT,
  avatar_url TEXT,
  phone TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- Auto-create profile on signup
CREATE FUNCTION public.handle_new_user() 
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, full_name, avatar_url)
  VALUES (
    NEW.id,
    NEW.email,
    NEW.raw_user_meta_data->>'full_name',
    NEW.raw_user_meta_data->>'avatar_url'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
```

## Integration with Flutter

### Using supabase_flutter package
```dart
import 'package:supabase_flutter/supabase_flutter.dart';

// Initialize
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',
  anonKey: 'YOUR_ANON_KEY',
);

// Sign in with Google
await Supabase.instance.client.auth.signInWithOAuth(
  Provider.google,
  redirectTo: 'your-app-scheme://callback',
);

// Get current user
final user = Supabase.instance.client.auth.currentUser;

// Listen to auth changes
Supabase.instance.client.auth.onAuthStateChange.listen((data) {
  final event = data.event;
  final session = data.session;
  // Handle auth state changes
});
```

## Notes
- Supabase handles OAuth flow automatically
- No need to manage OAuth tokens manually
- RLS policies provide built-in security
- Update this directive when encountering new error patterns
- Keep provider configuration in Supabase Dashboard
- Test all flows in development environment first
