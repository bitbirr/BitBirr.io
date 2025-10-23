# BitBirr Setup Checklist

Use this checklist to ensure you've completed all setup steps correctly.

## Prerequisites

- [ ] Flutter SDK 3.0+ installed
- [ ] Android Studio or VS Code with Flutter plugin installed
- [ ] Android device/emulator available
- [ ] Supabase account created
- [ ] Git installed

## Supabase Configuration

### Database Setup
- [ ] Created Supabase project
- [ ] Noted Project URL: `_______________________________`
- [ ] Noted Anon Key: `_______________________________`
- [ ] Ran `supabase_schema.sql` in SQL Editor
- [ ] Verified tables exist:
  - [ ] `profiles` table
  - [ ] `rates` table
  - [ ] `orders` table
  - [ ] `support_tickets` table
- [ ] Checked that initial rates data exists (`SELECT * FROM rates;`)
- [ ] Verified RLS policies are active

### Authentication Setup
- [ ] Enabled Email provider in Authentication → Providers
- [ ] (Optional) Customized email templates
- [ ] (Optional) Configured custom SMTP server

### Configuration Files
- [ ] Updated `lib/services/supabase_service.dart`:
  - [ ] Replaced `supabaseUrl` with your project URL
  - [ ] Replaced `supabaseAnonKey` with your anon key

## Flutter App Configuration

### Dependencies
- [ ] Ran `flutter pub get` successfully
- [ ] No dependency conflicts

### Payment Configuration
- [ ] Updated payment account numbers in `lib/screens/payment_screen.dart`:
  - [ ] Telebirr merchant number
  - [ ] CBE Birr account number
  - [ ] Awash Bank account number and name

### Branding (Optional)
- [ ] Added BitBirr logo to `assets/logo/logo.png`
- [ ] Generated app icons for all sizes
- [ ] Updated app name in `android/app/src/main/AndroidManifest.xml`
- [ ] Updated package name (if needed)

## Testing

### Build & Run
- [ ] App builds without errors
- [ ] App runs on emulator/device
- [ ] Splash screen appears correctly
- [ ] Login screen loads

### Authentication Flow
- [ ] Can enter email address
- [ ] Receives OTP email
- [ ] Can enter OTP code
- [ ] Successfully logs in
- [ ] Redirects to home screen

### Home Screen
- [ ] Welcome message shows correctly
- [ ] Exchange rates load and display
- [ ] "Buy Crypto" button works
- [ ] "My Orders" button works
- [ ] "Support" button works
- [ ] Logout works correctly

### Buy Crypto Flow
- [ ] Can select cryptocurrency (BTC/ETH/USDT)
- [ ] Exchange rates display correctly
- [ ] Can enter ETB amount
- [ ] Crypto amount calculates correctly
- [ ] Can select payment method
- [ ] Can enter wallet address
- [ ] Wallet address validation works
- [ ] Order confirmation dialog appears
- [ ] Order creates successfully

### Payment Flow
- [ ] Payment instructions display correctly
- [ ] Can copy account numbers
- [ ] Can copy amount
- [ ] Can copy reference number
- [ ] Instructions are clear and accurate

### Orders
- [ ] Orders list displays correctly
- [ ] Can view order details
- [ ] Order status shows correctly
- [ ] Can navigate from order to payment instructions

### Support
- [ ] Can open support screen
- [ ] Can enter subject and message
- [ ] Can submit support ticket
- [ ] Ticket saves to database
- [ ] Success message appears

## Production Readiness (Before Launch)

### Security
- [ ] Changed all default credentials
- [ ] Updated payment account numbers with real accounts
- [ ] Configured proper email settings
- [ ] Set up RLS policies correctly
- [ ] Reviewed all security settings

### Data
- [ ] Updated exchange rates to current values
- [ ] Set up process for regular rate updates
- [ ] Created admin process for order fulfillment

### Legal & Compliance
- [ ] Created Terms of Service
- [ ] Created Privacy Policy
- [ ] Added necessary disclaimers
- [ ] Verified compliance with local regulations

### Build & Deploy
- [ ] Created release signing key
- [ ] Configured ProGuard rules (if needed)
- [ ] Built release APK successfully
- [ ] Tested release build on real device
- [ ] Prepared Google Play Store listing
  - [ ] App description
  - [ ] Screenshots
  - [ ] App icon
  - [ ] Feature graphic
  - [ ] Privacy policy URL

### Monitoring
- [ ] Set up error tracking
- [ ] Set up analytics (optional)
- [ ] Set up logging
- [ ] Created support process

## Launch Day

- [ ] Final testing on production Supabase
- [ ] Update rates to current market values
- [ ] Monitor first user signups
- [ ] Test end-to-end flow with real payment
- [ ] Monitor error logs
- [ ] Prepare support team

## Post-Launch

- [ ] Monitor user feedback
- [ ] Track order completion rate
- [ ] Update exchange rates regularly
- [ ] Process support tickets promptly
- [ ] Plan feature updates

---

## Notes

Use this space to track any custom configurations or important information:

```
Supabase Project Name: _______________________________
Project URL: _______________________________
Payment Processor: _______________________________
Support Email: _______________________________
Launch Date: _______________________________

Additional Notes:
_______________________________
_______________________________
_______________________________
```

---

**Completed:** _____ / _____ items
**Status:** [ ] Development  [ ] Testing  [ ] Production Ready  [ ] Launched
