# BitBirr Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         BitBirr Mobile App                       │
│                         (Flutter/Android)                        │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ HTTPS/WebSocket
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                         Supabase Backend                         │
├─────────────────────────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │     Auth     │  │   Database   │  │   Storage    │          │
│  │              │  │              │  │              │          │
│  │ Email OTP    │  │ PostgreSQL   │  │ File Upload  │          │
│  │ Magic Link   │  │     RLS      │  │  (Future)    │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Database Tables                             │
├─────────────────────────────────────────────────────────────────┤
│  profiles        │  rates           │  orders      │  support   │
│  ─────────       │  ────────        │  ──────      │  ────────  │
│  - id            │  - symbol        │  - id        │  - id      │
│  - full_name     │  - etb_per_unit  │  - user_id   │  - user_id │
│  - created_at    │  - updated_at    │  - asset     │  - subject │
│  - updated_at    │                  │  - amount    │  - message │
│                  │                  │  - status    │  - status  │
└─────────────────────────────────────────────────────────────────┘


App Architecture (Flutter)
═══════════════════════════

┌─────────────────────────────────────────────────────────────────┐
│                            main.dart                             │
│                     (App Entry Point)                            │
└────────────────────────────┬────────────────────────────────────┘
                             │
                ┌────────────┴───────────┐
                │                        │
        ┌───────▼───────┐       ┌───────▼────────┐
        │   Providers   │       │    Screens     │
        │               │       │                │
        │ - Auth        │       │ - Splash       │
        │ - Rates       │       │ - Login        │
        │ - Orders      │       │ - Home         │
        └───────┬───────┘       │ - Buy Crypto   │
                │               │ - Payment      │
        ┌───────▼───────┐       │ - Orders       │
        │    Models     │       │ - Details      │
        │               │       │ - Support      │
        │ - Rate        │       └────────────────┘
        │ - Order       │
        │ - Ticket      │
        │ - Profile     │
        └───────┬───────┘
                │
        ┌───────▼───────┐
        │   Services    │
        │               │
        │ - Supabase    │
        └───────┬───────┘
                │
        ┌───────▼───────┐
        │    Utils      │
        │               │
        │ - Theme       │
        │ - Validators  │
        │ - Formatters  │
        └───────────────┘


User Flow Diagram
═════════════════

1. Authentication Flow
   ┌─────────┐    ┌────────┐    ┌───────────┐    ┌──────┐
   │ Splash  │───▶│ Login  │───▶│ Enter OTP │───▶│ Home │
   └─────────┘    └────────┘    └───────────┘    └──────┘

2. Buy Crypto Flow
   ┌──────┐    ┌──────────┐    ┌─────────┐    ┌────────┐
   │ Home │───▶│ Buy      │───▶│ Payment │───▶│ Orders │
   └──────┘    │ Crypto   │    │ Info    │    └────────┘
               └──────────┘    └─────────┘

3. Order Tracking Flow
   ┌──────┐    ┌────────┐    ┌──────────────┐
   │ Home │───▶│ Orders │───▶│ Order Detail │
   └──────┘    └────────┘    └──────────────┘

4. Support Flow
   ┌──────┐    ┌─────────┐    ┌──────────────┐
   │ Home │───▶│ Support │───▶│ Ticket Sent  │
   └──────┘    └─────────┘    └──────────────┘


State Management (Provider)
════════════════════════════

        ┌─────────────────┐
        │  MultiProvider  │
        └────────┬────────┘
                 │
        ┌────────┴────────┐
        │                 │
  ┌─────▼──────┐   ┌─────▼──────┐   ┌──────▼──────┐
  │   Auth     │   │   Rates    │   │   Orders    │
  │  Provider  │   │  Provider  │   │  Provider   │
  └────────────┘   └────────────┘   └─────────────┘
        │                │                  │
        │                │                  │
   ┌────▼────┐      ┌────▼────┐       ┌────▼────┐
   │ User    │      │ Crypto  │       │ Order   │
   │ Session │      │ Rates   │       │ List    │
   └─────────┘      └─────────┘       └─────────┘


Security Architecture
═════════════════════

┌─────────────────────────────────────────────────────────────────┐
│                      Client (Flutter App)                        │
├─────────────────────────────────────────────────────────────────┤
│  - Input Validation                                              │
│  - Wallet Address Validation                                     │
│  - No Sensitive Data Storage                                     │
│  - Secure HTTPS Communication                                    │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             │ JWT Token
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Supabase Auth Layer                           │
├─────────────────────────────────────────────────────────────────┤
│  - Email OTP Authentication                                      │
│  - Session Management                                            │
│  - JWT Token Generation                                          │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             │ Authenticated
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                Row Level Security (RLS)                          │
├─────────────────────────────────────────────────────────────────┤
│  ✓ Users can only view/insert/update their own data            │
│  ✓ Public can read rates                                        │
│  ✓ All queries filtered by auth.uid()                          │
└─────────────────────────────────────────────────────────────────┘


Payment Flow
════════════

┌──────────┐
│   User   │
└────┬─────┘
     │ 1. Select Asset (BTC/ETH/USDT)
     │ 2. Enter Amount (ETB)
     ▼
┌──────────────┐
│  Calculate   │◀─── Fetch current rate from database
│ Crypto Amt   │
└────┬─────────┘
     │ 3. Choose Payment Method
     │    (Telebirr/CBE Birr/Awash Bank)
     │ 4. Enter Wallet Address
     ▼
┌──────────────┐
│   Confirm    │
│    Order     │
└────┬─────────┘
     │ 5. Create order in database
     │    Status: 'pending'
     ▼
┌──────────────┐
│   Payment    │
│ Instructions │
└────┬─────────┘
     │ 6. User completes payment
     │    (Outside app - Mobile Money/Bank)
     ▼
┌──────────────┐
│    Admin     │
│   Verifies   │
└────┬─────────┘
     │ 7. Update order status
     │    Status: 'paid' → 'processing' → 'completed'
     │ 8. Send crypto to user's wallet
     ▼
┌──────────────┐
│  User Gets   │
│    Crypto    │
└──────────────┘


Technology Stack
════════════════

Frontend
├── Flutter 3.x
├── Dart 3.x
├── Material Design 3
└── Dependencies:
    ├── supabase_flutter (Backend)
    ├── provider (State Management)
    ├── go_router (Navigation)
    ├── google_fonts (Typography)
    └── intl (Formatting)

Backend (Supabase)
├── PostgreSQL (Database)
├── Auth (Email OTP)
├── Storage (Future)
└── Realtime (Future)

Platform
└── Android (iOS-ready codebase)


File Organization
═════════════════

flutter_app/
│
├── lib/
│   ├── main.dart                  ← Entry point
│   │
│   ├── models/                    ← Data structures
│   │   ├── crypto_rate.dart
│   │   ├── order.dart
│   │   ├── support_ticket.dart
│   │   └── user_profile.dart
│   │
│   ├── providers/                 ← State management
│   │   ├── auth_provider.dart
│   │   ├── orders_provider.dart
│   │   └── rates_provider.dart
│   │
│   ├── screens/                   ← UI screens
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   ├── home_screen.dart
│   │   ├── buy_crypto_screen.dart
│   │   ├── payment_screen.dart
│   │   ├── orders_screen.dart
│   │   ├── order_details_screen.dart
│   │   └── support_screen.dart
│   │
│   ├── services/                  ← Backend integration
│   │   └── supabase_service.dart
│   │
│   └── utils/                     ← Helpers
│       ├── app_theme.dart
│       ├── formatters.dart
│       └── validators.dart
│
├── android/                       ← Android config
├── assets/                        ← Resources
└── supabase_schema.sql           ← Database schema


Deployment Pipeline
═══════════════════

Development → Testing → Production

┌────────────┐    ┌────────────┐    ┌────────────┐
│   Local    │───▶│   Build    │───▶│  Release   │
│  Testing   │    │    APK     │    │   Deploy   │
└────────────┘    └────────────┘    └────────────┘
      │                 │                  │
      │                 │                  │
      ▼                 ▼                  ▼
  flutter run    flutter build apk   Google Play
                    --release            Store
```
