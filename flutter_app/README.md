# BitBirr - Your Gateway to Crypto in Ethiopia

BitBirr is a Flutter-based mobile application (Android) that enables Ethiopian users to buy Bitcoin, Ethereum, and USDT using Ethiopian Birr (ETB) through popular local payment methods: Telebirr, CBE Birr, and Awash Bank.

## Features

### User Features
- **Email OTP Authentication**: Secure magic link login via email using Supabase Auth
- **Buy Cryptocurrency**: Purchase BTC, ETH, and USDT with Ethiopian Birr
- **Real-time Rates**: View current exchange rates for all supported cryptocurrencies
- **Multiple Payment Methods**: 
  - Telebirr
  - CBE Birr
  - Awash Bank
- **Order Tracking**: View order status and transaction history
- **Support System**: Submit support tickets for assistance
- **Wallet Integration**: Enter your crypto wallet address to receive purchased coins

### Security
- Row Level Security (RLS) policies ensure users can only access their own data
- Secure authentication with Supabase
- Wallet address validation

## Technology Stack

### Frontend
- **Flutter** (3.x): Cross-platform mobile framework (Android-only build)
- **Provider**: State management
- **Google Fonts**: Typography
- **go_router**: Navigation

### Backend
- **Supabase**: 
  - Authentication (Email OTP)
  - PostgreSQL Database
  - Row Level Security (RLS)
  - Real-time capabilities (ready for future features)

### Database Schema
- `profiles`: User profile information
- `rates`: Cryptocurrency exchange rates (BTC, ETH, USDT in ETB)
- `orders`: Transaction records with status tracking
- `support_tickets`: Customer support tickets

## Setup Instructions

### Prerequisites
1. **Flutter SDK** (3.0 or higher): [Install Flutter](https://flutter.dev/docs/get-started/install)
2. **Android Studio** or **VS Code** with Flutter extensions
3. **Supabase Account**: [Sign up at supabase.com](https://supabase.com)

### Step 1: Clone the Repository
```bash
git clone https://github.com/bitbirr/BitBirr.io.git
cd BitBirr.io/flutter_app
```

### Step 2: Install Dependencies
```bash
flutter pub get
```

### Step 3: Set up Supabase

1. **Create a Supabase Project**:
   - Go to [supabase.com](https://supabase.com)
   - Create a new project
   - Note your project URL and anon key

2. **Run the SQL Schema**:
   - Open the Supabase SQL Editor
   - Copy the contents of `supabase_schema.sql`
   - Run the SQL script to create tables, RLS policies, and initial data

3. **Enable Email Authentication**:
   - Go to Authentication > Providers in Supabase dashboard
   - Enable Email provider
   - Configure email templates if needed

4. **Update Configuration**:
   - Open `lib/services/supabase_service.dart`
   - Replace `supabaseUrl` with your project URL
   - Replace `supabaseAnonKey` with your anon/public key

### Step 4: Run the Application

**For Android Emulator:**
```bash
flutter run
```

**For Physical Device:**
```bash
flutter run --release
```

### Step 5: Build APK
```bash
flutter build apk --release
```
The APK will be generated at `build/app/outputs/flutter-apk/app-release.apk`

## Project Structure

```
flutter_app/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/                   # Data models
│   │   ├── crypto_rate.dart
│   │   ├── order.dart
│   │   ├── support_ticket.dart
│   │   └── user_profile.dart
│   ├── providers/                # State management
│   │   ├── auth_provider.dart
│   │   ├── orders_provider.dart
│   │   └── rates_provider.dart
│   ├── screens/                  # UI screens
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   ├── home_screen.dart
│   │   ├── buy_crypto_screen.dart
│   │   ├── payment_screen.dart
│   │   ├── orders_screen.dart
│   │   ├── order_details_screen.dart
│   │   └── support_screen.dart
│   ├── services/                 # Backend services
│   │   └── supabase_service.dart
│   └── utils/                    # Utilities
│       ├── app_theme.dart
│       ├── formatters.dart
│       └── validators.dart
├── android/                      # Android configuration
├── assets/                       # Images and assets
├── pubspec.yaml                  # Dependencies
└── supabase_schema.sql          # Database schema
```

## Configuration

### Update Exchange Rates
Exchange rates are stored in the `rates` table. To update them:

```sql
UPDATE rates 
SET etb_per_unit = 5500000.00, updated_at = NOW() 
WHERE symbol = 'BTC';

UPDATE rates 
SET etb_per_unit = 160000.00, updated_at = NOW() 
WHERE symbol = 'ETH';

UPDATE rates 
SET etb_per_unit = 115.50, updated_at = NOW() 
WHERE symbol = 'USDT';
```

### Payment Account Configuration
Update payment account numbers in `lib/screens/payment_screen.dart`:
- Telebirr merchant number
- CBE Birr account number
- Awash Bank account number

## Usage

### For Users

1. **Sign Up/Login**:
   - Open the app
   - Enter your email address
   - Receive OTP code via email
   - Enter the code to login

2. **Buy Crypto**:
   - From home screen, tap "Buy Crypto"
   - Select cryptocurrency (BTC/ETH/USDT)
   - Enter amount in ETB
   - See calculated crypto amount
   - Choose payment method
   - Enter your wallet address
   - Review and confirm order
   - Follow payment instructions
   - Track order status

3. **View Orders**:
   - Tap "My Orders" from home screen
   - View all your transactions
   - Tap on any order to see details

4. **Get Support**:
   - Tap "Support" from home screen
   - Submit a support ticket
   - Or use quick contact methods

## UI/UX Design

### Color Scheme
- **Primary Green**: `#009B4D` - Main brand color
- **Dark Navy**: `#0C2C4A` - Secondary color, app bar
- **Light Green**: `#00C460` - Accents
- **Error Red**: `#E53935` - Errors and warnings
- **Success Green**: `#43A047` - Success states

### Typography
- **Font Family**: Inter (via Google Fonts)
- Clean, modern Material 3 design

## Testing

Run tests (when test files are added):
```bash
flutter test
```

## Known Limitations

1. **Android Only**: This version is built for Android only
2. **Manual Rate Updates**: Exchange rates need to be manually updated in the database
3. **No Payment Gateway Integration**: Payment confirmation is manual
4. **Order Processing**: Admin needs to manually mark orders as completed

## Future Enhancements (Stretch Goals)

- [ ] Real-time order status updates using Supabase Realtime
- [ ] Admin web panel for managing rates and orders
- [ ] Phone-based OTP authentication
- [ ] Push notifications
- [ ] In-app chat support
- [ ] Multiple language support (Amharic, Oromo)
- [ ] Dark mode
- [ ] KYC verification
- [ ] Payment gateway integration

## Support

For issues, questions, or contributions:
- Email: support@bitbirr.io
- Phone: +251-911-234-567
- Submit a ticket through the app

## License

Copyright © 2025 BitBirr. All rights reserved.

## Disclaimer

This is a cryptocurrency trading application. Users should:
- Understand the risks involved in cryptocurrency trading
- Verify all wallet addresses before confirming orders
- Keep their login credentials secure
- Contact support for any issues

**Note**: Always double-check your wallet address. Cryptocurrency sent to the wrong address cannot be recovered.
