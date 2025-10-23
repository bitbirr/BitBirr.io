# BitBirr Database & API Documentation

## Database Schema

### Tables Overview

The BitBirr application uses 4 main tables in Supabase PostgreSQL:

1. **profiles** - User profile information
2. **rates** - Cryptocurrency exchange rates
3. **orders** - Transaction/order records
4. **support_tickets** - Customer support tickets

---

## Table Details

### 1. profiles

Stores user profile information linked to Supabase Auth users.

**Columns:**
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY, REFERENCES auth.users(id) | User ID from auth.users |
| full_name | TEXT | NULL | User's full name |
| created_at | TIMESTAMP WITH TIME ZONE | DEFAULT NOW() | Account creation timestamp |
| updated_at | TIMESTAMP WITH TIME ZONE | DEFAULT NOW() | Last update timestamp |

**RLS Policies:**
- Users can view own profile (`SELECT WHERE auth.uid() = id`)
- Users can insert own profile (`INSERT WITH CHECK auth.uid() = id`)
- Users can update own profile (`UPDATE WHERE auth.uid() = id`)

**Triggers:**
- `on_auth_user_created` - Automatically creates profile when user signs up

**Example Query:**
```sql
-- Get user profile
SELECT * FROM profiles WHERE id = auth.uid();

-- Update user profile
UPDATE profiles 
SET full_name = 'John Doe', updated_at = NOW() 
WHERE id = auth.uid();
```

---

### 2. rates

Stores cryptocurrency exchange rates in Ethiopian Birr (ETB).

**Columns:**
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY, DEFAULT uuid_generate_v4() | Unique rate ID |
| symbol | TEXT | NOT NULL, UNIQUE | Crypto symbol (BTC, ETH, USDT) |
| etb_per_unit | DECIMAL(20, 2) | NOT NULL | Price in ETB per 1 crypto unit |
| updated_at | TIMESTAMP WITH TIME ZONE | DEFAULT NOW() | Last rate update |
| created_at | TIMESTAMP WITH TIME ZONE | DEFAULT NOW() | Rate creation timestamp |

**RLS Policies:**
- Anyone can view rates (`SELECT USING (true)`)

**Initial Data:**
```sql
INSERT INTO rates (symbol, etb_per_unit) VALUES
    ('BTC', 5000000.00),  -- Bitcoin
    ('ETH', 150000.00),   -- Ethereum
    ('USDT', 115.00);     -- Tether USD
```

**Example Queries:**
```sql
-- Get all current rates
SELECT * FROM rates ORDER BY symbol;

-- Get specific rate
SELECT * FROM rates WHERE symbol = 'BTC';

-- Update rate
UPDATE rates 
SET etb_per_unit = 5500000.00, updated_at = NOW() 
WHERE symbol = 'BTC';

-- Calculate crypto amount from ETB
SELECT 1000000 / etb_per_unit AS crypto_amount 
FROM rates 
WHERE symbol = 'BTC';
```

---

### 3. orders

Stores all cryptocurrency purchase orders.

**Columns:**
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY, DEFAULT uuid_generate_v4() | Unique order ID |
| user_id | UUID | NOT NULL, REFERENCES auth.users(id) | User who placed order |
| asset | TEXT | NOT NULL | Crypto asset (BTC, ETH, USDT) |
| etb_amount | DECIMAL(20, 2) | NOT NULL | Amount paid in ETB |
| crypto_amount | DECIMAL(20, 8) | NOT NULL | Amount of crypto to receive |
| payment_method | TEXT | NOT NULL | Payment method used |
| receiver_address | TEXT | NOT NULL | User's wallet address |
| status | TEXT | NOT NULL, DEFAULT 'pending' | Order status |
| tx_hash | TEXT | NULL | Blockchain transaction hash |
| created_at | TIMESTAMP WITH TIME ZONE | DEFAULT NOW() | Order creation time |
| updated_at | TIMESTAMP WITH TIME ZONE | DEFAULT NOW() | Last update time |

**Status Values:**
- `pending` - Payment not yet received
- `paid` - Payment received, awaiting processing
- `processing` - Order being processed
- `completed` - Crypto sent to user
- `cancelled` - Order cancelled

**RLS Policies:**
- Users can view own orders (`SELECT WHERE auth.uid() = user_id`)
- Users can insert own orders (`INSERT WITH CHECK auth.uid() = user_id`)
- Users can update own orders (`UPDATE WHERE auth.uid() = user_id`)

**Indexes:**
- `idx_orders_user_id` on `user_id`
- `idx_orders_status` on `status`

**Example Queries:**
```sql
-- Create new order
INSERT INTO orders (
    user_id, asset, etb_amount, crypto_amount, 
    payment_method, receiver_address, status
) VALUES (
    auth.uid(), 'BTC', 100000.00, 0.02, 
    'Telebirr', 'bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh', 'pending'
);

-- Get user's orders
SELECT * FROM orders 
WHERE user_id = auth.uid() 
ORDER BY created_at DESC;

-- Get pending orders (admin view)
SELECT * FROM orders 
WHERE status = 'pending' 
ORDER BY created_at;

-- Update order status
UPDATE orders 
SET status = 'completed', 
    tx_hash = 'abc123...', 
    updated_at = NOW() 
WHERE id = 'order-uuid';

-- Order statistics
SELECT 
    asset,
    COUNT(*) as total_orders,
    SUM(etb_amount) as total_etb,
    SUM(crypto_amount) as total_crypto
FROM orders 
WHERE status = 'completed'
GROUP BY asset;
```

---

### 4. support_tickets

Stores customer support tickets.

**Columns:**
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY, DEFAULT uuid_generate_v4() | Unique ticket ID |
| user_id | UUID | NOT NULL, REFERENCES auth.users(id) | User who created ticket |
| subject | TEXT | NOT NULL | Ticket subject/title |
| message | TEXT | NOT NULL | Ticket message/description |
| status | TEXT | NOT NULL, DEFAULT 'open' | Ticket status |
| created_at | TIMESTAMP WITH TIME ZONE | DEFAULT NOW() | Ticket creation time |
| updated_at | TIMESTAMP WITH TIME ZONE | DEFAULT NOW() | Last update time |

**Status Values:**
- `open` - New ticket
- `in_progress` - Being worked on
- `resolved` - Issue resolved
- `closed` - Ticket closed

**RLS Policies:**
- Users can view own tickets (`SELECT WHERE auth.uid() = user_id`)
- Users can insert own tickets (`INSERT WITH CHECK auth.uid() = user_id`)
- Users can update own tickets (`UPDATE WHERE auth.uid() = user_id`)

**Indexes:**
- `idx_support_tickets_user_id` on `user_id`
- `idx_support_tickets_status` on `status`

**Example Queries:**
```sql
-- Create support ticket
INSERT INTO support_tickets (user_id, subject, message, status)
VALUES (auth.uid(), 'Payment not processed', 'I made payment 2 hours ago...', 'open');

-- Get user's tickets
SELECT * FROM support_tickets 
WHERE user_id = auth.uid() 
ORDER BY created_at DESC;

-- Get open tickets (admin view)
SELECT * FROM support_tickets 
WHERE status = 'open' 
ORDER BY created_at;

-- Update ticket status
UPDATE support_tickets 
SET status = 'resolved', updated_at = NOW() 
WHERE id = 'ticket-uuid';
```

---

## Supabase Client Usage in Flutter

### Authentication

```dart
// Sign in with OTP
await SupabaseService.client.auth.signInWithOtp(
  email: 'user@example.com',
);

// Verify OTP
await SupabaseService.client.auth.verifyOTP(
  email: 'user@example.com',
  token: '123456',
  type: OtpType.email,
);

// Sign out
await SupabaseService.client.auth.signOut();

// Get current user
final user = SupabaseService.currentUser;
```

### Database Queries

```dart
// Fetch rates
final rates = await SupabaseService.client
    .from('rates')
    .select()
    .order('symbol');

// Fetch user orders
final orders = await SupabaseService.client
    .from('orders')
    .select()
    .eq('user_id', SupabaseService.currentUser!.id)
    .order('created_at', ascending: false);

// Create order
final newOrder = await SupabaseService.client
    .from('orders')
    .insert({
      'user_id': SupabaseService.currentUser!.id,
      'asset': 'BTC',
      'etb_amount': 100000,
      'crypto_amount': 0.02,
      'payment_method': 'Telebirr',
      'receiver_address': 'bc1q...',
      'status': 'pending',
    })
    .select()
    .single();

// Update order
await SupabaseService.client
    .from('orders')
    .update({'status': 'completed'})
    .eq('id', orderId);
```

---

## Admin Operations

These queries should be run in Supabase SQL Editor by administrators:

### Update Exchange Rates
```sql
-- Update all rates
UPDATE rates SET etb_per_unit = 5200000.00, updated_at = NOW() WHERE symbol = 'BTC';
UPDATE rates SET etb_per_unit = 155000.00, updated_at = NOW() WHERE symbol = 'ETH';
UPDATE rates SET etb_per_unit = 116.00, updated_at = NOW() WHERE symbol = 'USDT';
```

### Manage Orders
```sql
-- View pending payments
SELECT id, user_id, asset, etb_amount, payment_method, created_at
FROM orders 
WHERE status = 'pending'
ORDER BY created_at;

-- Mark order as paid
UPDATE orders 
SET status = 'paid', updated_at = NOW() 
WHERE id = 'order-uuid';

-- Complete order with transaction hash
UPDATE orders 
SET status = 'completed', 
    tx_hash = 'blockchain-tx-hash',
    updated_at = NOW() 
WHERE id = 'order-uuid';
```

### View Support Tickets
```sql
-- View all open tickets
SELECT st.*, p.full_name, u.email
FROM support_tickets st
JOIN profiles p ON st.user_id = p.id
JOIN auth.users u ON st.user_id = u.id
WHERE st.status = 'open'
ORDER BY st.created_at;
```

---

## Security Notes

1. **Row Level Security (RLS)** is enabled on all tables
2. Users can only access their own data (orders, tickets, profiles)
3. Rates table is public read-only
4. Never expose service_role key in client app
5. All database operations go through Supabase client with user JWT

---

## Performance Tips

1. Use indexes for frequent queries (already created)
2. Limit number of results with `.limit()`
3. Use `.single()` when expecting one result
4. Use realtime subscriptions sparingly
5. Cache rates locally for better performance

---

## Backup & Maintenance

Recommended maintenance tasks:

1. **Regular backups** - Enable automatic backups in Supabase
2. **Update rates** - Create a scheduled job to update rates
3. **Archive old orders** - Move completed orders older than 1 year to archive table
4. **Monitor usage** - Check database size and query performance regularly
