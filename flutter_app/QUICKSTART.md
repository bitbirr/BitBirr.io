# BitBirr Flutter App - Quick Start Guide

This guide will help you get the BitBirr Flutter app up and running quickly.

## Prerequisites Checklist

- [ ] Flutter SDK installed (3.0+)
- [ ] Android Studio or VS Code with Flutter plugin
- [ ] Android emulator or physical Android device
- [ ] Supabase account created
- [ ] Git installed

## Quick Setup (5 minutes)

### 1. Install Flutter
If you haven't installed Flutter yet:
```bash
# macOS/Linux
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Windows - Download from flutter.dev and add to PATH
```

Verify installation:
```bash
flutter doctor
```

### 2. Clone Repository
```bash
git clone https://github.com/bitbirr/BitBirr.io.git
cd BitBirr.io/flutter_app
```

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Configure Supabase (IMPORTANT!)

**Step 4.1: Create Supabase Project**
1. Go to https://supabase.com
2. Click "New Project"
3. Fill in project details
4. Wait for project to be ready (1-2 minutes)

**Step 4.2: Get Your Credentials**
1. In Supabase dashboard, go to Settings → API
2. Copy your **Project URL** (looks like: `https://xxxxx.supabase.co`)
3. Copy your **anon/public key** (long string starting with `eyJ...`)

**Step 4.3: Run Database Schema**
1. In Supabase dashboard, go to SQL Editor
2. Open `supabase_schema.sql` from the project
3. Copy all content and paste into SQL Editor
4. Click "Run" to execute
5. Verify tables are created: Go to Table Editor and you should see `profiles`, `rates`, `orders`, `support_tickets`

**Step 4.4: Enable Email Authentication**
1. In Supabase dashboard, go to Authentication → Providers
2. Find "Email" and make sure it's enabled
3. (Optional) Customize email templates under Authentication → Email Templates

**Step 4.5: Update App Configuration**
1. Open `lib/services/supabase_service.dart`
2. Replace:
   ```dart
   static const String supabaseUrl = 'https://your-project.supabase.co';
   static const String supabaseAnonKey = 'your-anon-key-here';
   ```
   With your actual URL and key from Step 4.2

### 5. Run the App

**On Emulator:**
```bash
# Start Android emulator first, then:
flutter run
```

**On Physical Device:**
```bash
# Enable USB debugging on your Android device, connect it, then:
flutter run
```

**Build Release APK:**
```bash
flutter build apk --release
# APK will be at: build/app/outputs/flutter-apk/app-release.apk
```

## Testing the App

### Test User Flow:
1. **Launch app** → Should see splash screen, then login
2. **Enter email** → Use a real email you can access
3. **Check email** → You'll receive a 6-digit OTP code
4. **Enter OTP** → Login successful
5. **View rates** → Home screen shows current crypto rates
6. **Buy crypto** → Tap "Buy Crypto" → Select BTC/ETH/USDT
7. **Place order** → Enter amount, select payment, enter wallet address
8. **View payment instructions** → Copy payment details
9. **Check orders** → View order in "My Orders"

## Common Issues & Solutions

### Issue: "flutter: command not found"
**Solution:** Add Flutter to your PATH
```bash
export PATH="$PATH:/path/to/flutter/bin"
# Add to ~/.bashrc or ~/.zshrc for permanent
```

### Issue: "Gradle build failed"
**Solution:** 
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Issue: "Supabase connection error"
**Solution:** 
1. Check internet connection
2. Verify `supabaseUrl` and `supabaseAnonKey` in `lib/services/supabase_service.dart`
3. Make sure URL has `https://` prefix
4. Check Supabase project is active (not paused)

### Issue: "Email OTP not received"
**Solution:**
1. Check spam/junk folder
2. Verify email is valid
3. In Supabase, go to Authentication → Users to see if signup was created
4. Check Supabase logs for errors

### Issue: "No exchange rates showing"
**Solution:**
1. Check if `rates` table has data
2. Run this SQL in Supabase:
   ```sql
   SELECT * FROM rates;
   ```
3. If empty, run the INSERT statements from `supabase_schema.sql`

## Next Steps

### For Development:
- [ ] Update exchange rates in Supabase `rates` table
- [ ] Configure payment account numbers in `payment_screen.dart`
- [ ] Add your logo to `assets/logo/` directory
- [ ] Generate app icons using your logo
- [ ] Test all features thoroughly
- [ ] Update app name and package ID if needed

### For Production:
- [ ] Create proper signing keys for release build
- [ ] Set up proper email templates in Supabase
- [ ] Configure custom SMTP (optional)
- [ ] Set up monitoring and analytics
- [ ] Create privacy policy and terms of service
- [ ] Submit to Google Play Store

## Project Structure Quick Reference

```
flutter_app/
├── lib/
│   ├── main.dart              ← App entry point
│   ├── models/                ← Data structures
│   ├── providers/             ← State management (Provider)
│   ├── screens/               ← UI screens
│   ├── services/              ← Backend (Supabase)
│   └── utils/                 ← Helpers, theme, validators
├── android/                   ← Android config
├── assets/                    ← Images, logos
├── supabase_schema.sql        ← Database schema
└── pubspec.yaml              ← Dependencies
```

## Useful Commands

```bash
# Run in debug mode
flutter run

# Run with hot reload
flutter run --hot

# Build release APK
flutter build apk --release

# Build app bundle (for Play Store)
flutter build appbundle --release

# Clean build
flutter clean

# Get dependencies
flutter pub get

# Check for issues
flutter doctor

# Analyze code
flutter analyze

# Format code
flutter format .
```

## Support & Resources

- **Flutter Documentation:** https://flutter.dev/docs
- **Supabase Documentation:** https://supabase.com/docs
- **Provider Package:** https://pub.dev/packages/provider
- **Material Design:** https://m3.material.io/

## Need Help?

If you encounter issues not covered here:
1. Check the main README.md file
2. Review Flutter and Supabase documentation
3. Check GitHub issues
4. Contact support

---

**Happy coding! 🚀**
