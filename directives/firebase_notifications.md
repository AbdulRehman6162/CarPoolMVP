# Firebase Push Notifications

## Overview
This directive handles push notification setup and delivery using Firebase Cloud Messaging (FCM) for the CarPool MVP.

## Goal
Send reliable, timely push notifications to iOS and Android devices for ride updates, booking confirmations, and user messages.

## When to Use
- Sending ride booking confirmations
- Notifying drivers of new booking requests
- Sending ride reminders before departure
- Alerting users of ride cancellations
- Chat messages and in-app notifications
- Promotional messages and announcements

## Inputs
- **Notification type**: `single`, `topic`, `batch`
- **Target**: FCM token, topic name, or list of tokens
- **Title**: Notification title
- **Body**: Notification message
- **Data payload**: Additional data for the app
- **Priority**: `high` or `normal`
- **Platform**: `ios`, `android`, or `both`

## Tools & Scripts
- `execution/firebase_notifications.py` - Main script for sending notifications
- Firebase Console for FCM configuration
- Environment variables in `.env`:
  - `FIREBASE_PROJECT_ID`
  - `FIREBASE_CREDENTIALS_PATH`

## Execution Flow

### 1. Send Notification to Single Device
```bash
python execution/firebase_notifications.py \
  --type single \
  --token "DEVICE_FCM_TOKEN" \
  --title "Ride Confirmed" \
  --body "Your ride to Lahore has been confirmed" \
  --data '{"ride_id": "123", "type": "booking_confirmed"}'
```

### 2. Send to Topic (Multiple Devices)
```bash
python execution/firebase_notifications.py \
  --type topic \
  --topic "ride_updates" \
  --title "New Ride Available" \
  --body "A ride from Islamabad to Lahore is now available"
```

### 3. Send Batch Notifications
```bash
# Using a JSON file with multiple recipients
python execution/firebase_notifications.py \
  --type batch \
  --batch-file .tmp/notification_batch.json
```

### 4. Subscribe Device to Topic
```bash
python execution/firebase_notifications.py \
  --action subscribe \
  --token "DEVICE_FCM_TOKEN" \
  --topic "ride_updates"
```

### 5. Unsubscribe Device from Topic
```bash
python execution/firebase_notifications.py \
  --action unsubscribe \
  --token "DEVICE_FCM_TOKEN" \
  --topic "ride_updates"
```

## Outputs
- **Success**: Confirmation logged to console
- **Failed tokens**: List saved to `.tmp/failed_notifications.json`
- **Error details**: Logged to `.tmp/notification_errors.log`

## Notification Payload Structure

### Basic Notification
```json
{
  "title": "Ride Confirmed",
  "body": "Your ride has been confirmed for tomorrow at 9 AM"
}
```

### Notification with Data Payload
```json
{
  "notification": {
    "title": "New Message",
    "body": "You have a new message from driver"
  },
  "data": {
    "type": "chat_message",
    "chat_id": "abc123",
    "sender_id": "user456",
    "click_action": "OPEN_CHAT"
  }
}
```

### Platform-Specific Customization
```json
{
  "notification": {
    "title": "Ride Update",
    "body": "Your ride is starting in 10 minutes"
  },
  "android": {
    "priority": "high",
    "notification": {
      "sound": "default",
      "color": "#00FF00",
      "icon": "notification_icon"
    }
  },
  "apns": {
    "payload": {
      "aps": {
        "sound": "default",
        "badge": 1
      }
    }
  }
}
```

## Firebase Console Configuration

### 1. Enable FCM
1. Go to Firebase Console → Project Settings
2. Cloud Messaging tab
3. Enable Cloud Messaging API (V1)
4. Download service account key (credentials.json)

### 2. iOS Setup
1. Add Apple Push Notification (APNs) auth key
2. Upload .p8 file from Apple Developer Console
3. Add Team ID and Key ID
4. Configure app bundle ID

### 3. Android Setup
1. Add google-services.json to Android app
2. Configure sender ID in app
3. No additional server setup needed

## Edge Cases & Learnings

### Common Errors
1. **Invalid Token**: Device token expired or invalid
   - Remove token from database
   - Re-register device for notifications
2. **APNs Certificate Expired**: Update APNs auth key in Firebase Console
3. **Message Too Large**: FCM has 4KB limit for total payload
4. **Rate Limiting**: FCM has rate limits, implement batching
5. **App in Background**: Some platforms restrict background notifications

### Best Practices
- **Token Management**:
  - Store FCM tokens in Supabase users table
  - Update tokens when they change
  - Remove invalid tokens after failed sends
  - Refresh tokens periodically

- **Notification Content**:
  - Keep titles under 40 characters
  - Keep body under 100 characters for better display
  - Use data payload for app-specific information
  - Test on both iOS and Android

- **Delivery Optimization**:
  - Use `high` priority sparingly (only for time-sensitive)
  - Use topics for broadcast messages
  - Batch notifications when sending to multiple users
  - Schedule notifications for optimal engagement

- **User Experience**:
  - Allow users to configure notification preferences
  - Respect quiet hours
  - Don't spam users with too many notifications
  - Make notifications actionable

### Performance Tips
- Batch send up to 500 tokens at once
- Use topics for broadcasts instead of individual sends
- Cache frequently used data to reduce payload size
- Use data-only messages for silent updates
- Implement exponential backoff for retries

## Notification Categories

### Ride-Related
- **Booking Confirmed**: When a booking is confirmed
- **Ride Starting Soon**: 10-15 minutes before departure
- **Driver Arrived**: When driver reaches pickup point
- **Ride Started**: When ride begins
- **Ride Completed**: When ride ends
- **Ride Cancelled**: When ride is cancelled

### User Interactions
- **New Message**: Chat messages from driver/passenger
- **Booking Request**: New booking request for driver
- **Rating Reminder**: Remind to rate after ride
- **Payment Received**: Payment confirmation

### System Notifications
- **Account Update**: Profile changes, verification
- **Promotional**: Special offers, new features
- **Safety Alerts**: Emergency notifications

## Integrating with Supabase

### Store FCM Tokens
```sql
-- Add fcm_token to users table
ALTER TABLE public.users ADD COLUMN fcm_token TEXT;
ALTER TABLE public.users ADD COLUMN fcm_token_updated_at TIMESTAMP;

-- Update token
UPDATE public.users 
SET fcm_token = 'new_token', 
    fcm_token_updated_at = NOW() 
WHERE id = 'user_id';
```

### Trigger Notifications from Database
Use Supabase Edge Functions or Database Webhooks:
```sql
-- Trigger notification on booking creation
CREATE FUNCTION notify_booking_created()
RETURNS TRIGGER AS $$
BEGIN
  -- Call Edge Function or external webhook
  PERFORM net.http_post(
    url := 'YOUR_NOTIFICATION_SERVICE_URL',
    body := json_build_object(
      'user_id', NEW.driver_id,
      'type', 'new_booking',
      'booking_id', NEW.id
    )
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_booking_created
  AFTER INSERT ON bookings
  FOR EACH ROW EXECUTE FUNCTION notify_booking_created();
```

## Testing Checklist
- [ ] Send to single iOS device
- [ ] Send to single Android device
- [ ] Send with data payload
- [ ] Handle invalid tokens gracefully
- [ ] Topic subscription/unsubscription
- [ ] Batch sending (>10 devices)
- [ ] High priority delivery
- [ ] Image notifications (rich media)
- [ ] Action buttons in notifications
- [ ] Background notification handling

## Analytics & Monitoring
- Track notification delivery rates
- Monitor failed token rates
- Measure notification open rates
- A/B test notification content
- Monitor for spam complaints

## Notes
- FCM tokens are device-specific, not user-specific
- Users may have multiple tokens (multiple devices)
- Tokens can become invalid (app uninstall, token refresh)
- Always handle notification permission requests gracefully
- Test on physical devices, simulators have limitations
- Update this directive with delivery patterns and best practices
