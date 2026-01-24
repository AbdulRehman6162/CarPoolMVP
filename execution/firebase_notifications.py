"""
Firebase Cloud Messaging (FCM) Push Notifications Script
Send push notifications to iOS and Android devices

Usage:
    python firebase_notifications.py --type single --token TOKEN --title "Title" --body "Body"
    python firebase_notifications.py --type topic --topic "updates" --title "Title" --body "Body"
    python firebase_notifications.py --type batch --batch-file notifications.json
    python firebase_notifications.py --action subscribe --token TOKEN --topic "topic_name"
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

# Requires firebase-admin
# Install: pip install firebase-admin python-dotenv

try:
    import firebase_admin
    from firebase_admin import credentials, messaging
except ImportError:
    print("Error: firebase-admin not installed. Run: pip install firebase-admin python-dotenv")
    sys.exit(1)


class FirebaseNotifications:
    def __init__(self):
        """Initialize Firebase Admin SDK"""
        cred_path = os.getenv('FIREBASE_CREDENTIALS_PATH')
        
        if not cred_path or not Path(cred_path).exists():
            raise ValueError(f"Firebase credentials not found at: {cred_path}")
        
        if not firebase_admin._apps:
            cred = credentials.Certificate(cred_path)
            firebase_admin.initialize_app(cred)
    
    def send_to_token(self, token: str, title: str, body: str, 
                      data: Optional[Dict] = None, 
                      priority: str = 'high',
                      image_url: Optional[str] = None) -> bool:
        """Send notification to a single device token"""
        try:
            # Build notification
            notification = messaging.Notification(
                title=title,
                body=body,
                image=image_url
            )
            
            # Build message
            message = messaging.Message(
                notification=notification,
                data=data or {},
                token=token,
                android=messaging.AndroidConfig(
                    priority=priority,
                    notification=messaging.AndroidNotification(
                        sound='default',
                        color='#00AAFF'
                    )
                ),
                apns=messaging.APNSConfig(
                    payload=messaging.APNSPayload(
                        aps=messaging.Aps(
                            sound='default',
                            badge=1
                        )
                    )
                )
            )
            
            # Send message
            response = messaging.send(message)
            print(f"Successfully sent message: {response}")
            return True
            
        except Exception as e:
            print(f"Error sending notification: {e}")
            self._log_error(e)
            return False
    
    def send_to_topic(self, topic: str, title: str, body: str,
                      data: Optional[Dict] = None,
                      priority: str = 'high') -> bool:
        """Send notification to a topic (multiple subscribers)"""
        try:
            message = messaging.Message(
                notification=messaging.Notification(
                    title=title,
                    body=body
                ),
                data=data or {},
                topic=topic,
                android=messaging.AndroidConfig(
                    priority=priority
                )
            )
            
            response = messaging.send(message)
            print(f"Successfully sent message to topic '{topic}': {response}")
            return True
            
        except Exception as e:
            print(f"Error sending to topic: {e}")
            self._log_error(e)
            return False
    
    def send_batch(self, notifications: List[Dict]) -> Dict:
        """Send multiple notifications in batch
        
        Args:
            notifications: List of notification dicts with keys:
                - token: Device FCM token
                - title: Notification title
                - body: Notification body
                - data: Optional data payload
        
        Returns:
            Dict with success_count and failure_count
        """
        try:
            messages = []
            
            for notif in notifications:
                message = messaging.Message(
                    notification=messaging.Notification(
                        title=notif.get('title', ''),
                        body=notif.get('body', '')
                    ),
                    data=notif.get('data', {}),
                    token=notif['token']
                )
                messages.append(message)
            
            # Send all messages (max 500 per batch)
            if len(messages) > 500:
                print("Warning: Batch size > 500, will send in chunks")
            
            response = messaging.send_all(messages[:500])  # Limit to 500
            
            print(f"Batch send complete:")
            print(f"  Success: {response.success_count}")
            print(f"  Failure: {response.failure_count}")
            
            # Log failed tokens
            if response.failure_count > 0:
                failed_tokens = []
                for idx, resp in enumerate(response.responses):
                    if not resp.success:
                        failed_tokens.append({
                            'token': notifications[idx]['token'],
                            'error': str(resp.exception)
                        })
                
                self._save_failed_tokens(failed_tokens)
            
            return {
                'success_count': response.success_count,
                'failure_count': response.failure_count
            }
            
        except Exception as e:
            print(f"Error in batch send: {e}")
            self._log_error(e)
            return {'success_count': 0, 'failure_count': len(notifications)}
    
    def subscribe_to_topic(self, tokens: List[str], topic: str) -> Dict:
        """Subscribe device tokens to a topic"""
        try:
            response = messaging.subscribe_to_topic(tokens, topic)
            print(f"Subscribed {response.success_count} devices to topic '{topic}'")
            return {
                'success_count': response.success_count,
                'failure_count': response.failure_count
            }
        except Exception as e:
            print(f"Error subscribing to topic: {e}")
            self._log_error(e)
            return {'success_count': 0, 'failure_count': len(tokens)}
    
    def unsubscribe_from_topic(self, tokens: List[str], topic: str) -> Dict:
        """Unsubscribe device tokens from a topic"""
        try:
            response = messaging.unsubscribe_from_topic(tokens, topic)
            print(f"Unsubscribed {response.success_count} devices from topic '{topic}'")
            return {
                'success_count': response.success_count,
                'failure_count': response.failure_count
            }
        except Exception as e:
            print(f"Error unsubscribing from topic: {e}")
            self._log_error(e)
            return {'success_count': 0, 'failure_count': len(tokens)}
    
    def _save_failed_tokens(self, failed_tokens: List[Dict]):
        """Save failed tokens to file"""
        output_path = Path('.tmp/failed_notifications.json')
        output_path.parent.mkdir(exist_ok=True)
        
        with open(output_path, 'w') as f:
            json.dump(failed_tokens, f, indent=2)
        
        print(f"Failed tokens saved to {output_path}")
    
    def _log_error(self, error: Exception):
        """Log error to file"""
        error_log_path = Path('.tmp/notification_errors.log')
        error_log_path.parent.mkdir(exist_ok=True)
        
        with open(error_log_path, 'a') as f:
            from datetime import datetime
            f.write(f"\n[{datetime.now().isoformat()}] {str(error)}\n")


def main():
    parser = argparse.ArgumentParser(description='Firebase Push Notifications')
    parser.add_argument('--type', choices=['single', 'topic', 'batch'],
                       help='Notification type')
    parser.add_argument('--action', choices=['subscribe', 'unsubscribe'],
                       help='Topic subscription action')
    parser.add_argument('--token', help='Device FCM token')
    parser.add_argument('--tokens', help='Comma-separated list of tokens')
    parser.add_argument('--topic', help='Topic name')
    parser.add_argument('--title', help='Notification title')
    parser.add_argument('--body', help='Notification body')
    parser.add_argument('--data', help='JSON data payload')
    parser.add_argument('--priority', default='high', choices=['high', 'normal'],
                       help='Notification priority')
    parser.add_argument('--image-url', help='Image URL for notification')
    parser.add_argument('--batch-file', help='JSON file with batch notifications')
    
    args = parser.parse_args()
    
    fcm = FirebaseNotifications()
    
    # Handle topic subscription/unsubscription
    if args.action:
        if not args.topic:
            print("Error: --topic required for subscribe/unsubscribe")
            sys.exit(1)
        
        tokens = []
        if args.token:
            tokens = [args.token]
        elif args.tokens:
            tokens = [t.strip() for t in args.tokens.split(',')]
        else:
            print("Error: --token or --tokens required")
            sys.exit(1)
        
        if args.action == 'subscribe':
            result = fcm.subscribe_to_topic(tokens, args.topic)
        else:
            result = fcm.unsubscribe_from_topic(tokens, args.topic)
        
        sys.exit(0 if result['success_count'] > 0 else 1)
    
    # Handle sending notifications
    if not args.type:
        print("Error: --type or --action required")
        parser.print_help()
        sys.exit(1)
    
    if args.type == 'single':
        if not args.token or not args.title or not args.body:
            print("Error: --token, --title, and --body required for single notification")
            sys.exit(1)
        
        data = json.loads(args.data) if args.data else None
        success = fcm.send_to_token(
            token=args.token,
            title=args.title,
            body=args.body,
            data=data,
            priority=args.priority,
            image_url=args.image_url
        )
        sys.exit(0 if success else 1)
    
    elif args.type == 'topic':
        if not args.topic or not args.title or not args.body:
            print("Error: --topic, --title, and --body required for topic notification")
            sys.exit(1)
        
        data = json.loads(args.data) if args.data else None
        success = fcm.send_to_topic(
            topic=args.topic,
            title=args.title,
            body=args.body,
            data=data,
            priority=args.priority
        )
        sys.exit(0 if success else 1)
    
    elif args.type == 'batch':
        if not args.batch_file:
            print("Error: --batch-file required for batch notification")
            sys.exit(1)
        
        with open(args.batch_file) as f:
            notifications = json.load(f)
        
        result = fcm.send_batch(notifications)
        sys.exit(0 if result['success_count'] > 0 else 1)


if __name__ == '__main__':
    main()
