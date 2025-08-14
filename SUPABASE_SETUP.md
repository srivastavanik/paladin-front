# Supabase Setup Guide for Paladin Investment Form

## Overview
This guide will help you set up the Supabase database for tracking investment opportunity form submissions with comprehensive analytics and security.

## Setup Instructions

### 1. Run the SQL Schema
1. Open your Supabase project dashboard
2. Navigate to the SQL Editor
3. Copy and paste the contents of `supabase-schema.sql`
4. Execute the SQL script

### 2. Verify Setup
After running the schema, you should have:
- ✅ `investment_interests` table with all necessary columns
- ✅ Proper indexes for performance
- ✅ Row Level Security (RLS) enabled
- ✅ Triggers for automatic `updated_at` timestamps
- ✅ Analytics view and functions
- ✅ Proper permissions for anonymous form submissions

### 3. Test the Setup
You can test the setup by inserting a test record:
```sql
INSERT INTO investment_interests (name, title, company, email, phone)
VALUES ('Test User', 'Test Title', 'Test Company', 'test@example.com', '+1-555-0123');
```

## Database Schema

### Main Table: `investment_interests`

| Column | Type | Description |
|--------|------|-------------|
| `id` | UUID | Primary key (auto-generated) |
| `name` | TEXT | Full name (required) |
| `title` | TEXT | Job title (required) |
| `company` | TEXT | Company name (required) |
| `email` | TEXT | Email address (required) |
| `phone` | TEXT | Phone number (optional) |
| `submitted_at` | TIMESTAMP | Form submission time |
| `created_at` | TIMESTAMP | Record creation time |
| `updated_at` | TIMESTAMP | Last update time (auto-updated) |
| `ip_address` | INET | Submitter's IP address |
| `user_agent` | TEXT | Browser user agent |
| `referrer` | TEXT | Referring page URL |
| `utm_source` | TEXT | UTM tracking - source |
| `utm_medium` | TEXT | UTM tracking - medium |
| `utm_campaign` | TEXT | UTM tracking - campaign |
| `status` | TEXT | Lead status (new, contacted, qualified, etc.) |
| `notes` | TEXT | Internal notes |
| `follow_up_date` | DATE | Scheduled follow-up date |
| `investment_amount_range` | TEXT | Preferred investment range |
| `investment_stage_preference` | TEXT | Preferred investment stage |
| `previous_investments` | BOOLEAN | Has previous startup investments |
| `accredited_investor` | BOOLEAN | Accredited investor status |
| `contact_preference` | TEXT | Preferred contact method |
| `source` | TEXT | Lead source tracking |

## Security Features

### Row Level Security (RLS)
- ✅ Anonymous users can INSERT (form submissions)
- ✅ Only authenticated users can SELECT/UPDATE
- ✅ Prevents unauthorized data access

### Policies
1. **Anonymous Inserts**: Allows form submissions without authentication
2. **Authenticated Reads**: Only authenticated users can view data
3. **Authenticated Updates**: Only authenticated users can modify records

## Analytics & Reporting

### Available Views & Functions

#### 1. Investment Analytics View
```sql
SELECT * FROM investment_analytics;
```
Provides daily submission statistics, unique emails, and status breakdowns.

#### 2. Get Investment Stats Function
```sql
SELECT get_investment_stats();
```
Returns comprehensive statistics in JSON format:
- Total submissions
- Daily/weekly/monthly counts
- Unique companies
- Status breakdown

#### 3. Export Function
```sql
SELECT * FROM export_investment_data('2024-01-01', '2024-12-31');
```
Export data for specific date ranges.

## Monitoring & Notifications

### Automatic Triggers
- **Updated At**: Automatically updates `updated_at` timestamp
- **New Submission Notification**: Logs new submissions (can be extended for webhooks/emails)

### Performance Optimizations
- Indexes on email, submission date, status, and company
- Optimized queries for analytics
- Efficient data types and constraints

## Frontend Integration

### Environment Variables
Make sure your frontend has these environment variables:
```env
SUPABASE_URL=your-supabase-url
SUPABASE_ANON_KEY=your-supabase-anon-key
```

### Form Submission Endpoint
The form submits to:
```
POST {SUPABASE_URL}/rest/v1/investment_interests
```

### Required Headers
```javascript
{
  'Content-Type': 'application/json',
  'Authorization': `Bearer ${SUPABASE_ANON_KEY}`,
  'apikey': SUPABASE_ANON_KEY,
  'Prefer': 'return=minimal'
}
```

## Data Management

### Viewing Submissions
```sql
SELECT name, title, company, email, submitted_at, status
FROM investment_interests
ORDER BY submitted_at DESC;
```

### Updating Lead Status
```sql
UPDATE investment_interests 
SET status = 'contacted', notes = 'Initial outreach completed'
WHERE id = 'uuid-here';
```

### Analytics Queries
```sql
-- Submissions by day
SELECT DATE(submitted_at) as date, COUNT(*) as submissions
FROM investment_interests
GROUP BY DATE(submitted_at)
ORDER BY date DESC;

-- Top companies
SELECT company, COUNT(*) as submissions
FROM investment_interests
GROUP BY company
ORDER BY submissions DESC;
```

## Backup & Export

### Manual Export
```sql
SELECT * FROM export_investment_data();
```

### Scheduled Backups
Consider setting up automated backups through Supabase dashboard or using pg_dump.

## Troubleshooting

### Common Issues

1. **Form submissions failing**
   - Check RLS policies are correctly set
   - Verify anon key permissions
   - Ensure required fields are provided

2. **Cannot view data**
   - Make sure you're authenticated
   - Check user permissions
   - Verify RLS policies

3. **Performance issues**
   - Check if indexes are created
   - Monitor query performance in Supabase dashboard
   - Consider adding more specific indexes for your queries

### Testing Connectivity
```javascript
// Test basic connectivity
fetch(`${SUPABASE_URL}/rest/v1/investment_interests?select=count`, {
  headers: {
    'apikey': SUPABASE_ANON_KEY,
    'Authorization': `Bearer ${SUPABASE_ANON_KEY}`
  }
})
.then(response => response.json())
.then(data => console.log('Connection successful:', data));
```

## Production Considerations

1. **Remove sample data** if inserted during testing
2. **Set up monitoring** for failed submissions
3. **Configure email notifications** for new leads
4. **Regular backups** of the database
5. **Monitor RLS policies** for security
6. **Set up alerting** for unusual submission patterns

This setup provides a robust, secure, and scalable foundation for tracking investment opportunities with comprehensive analytics and reporting capabilities.
