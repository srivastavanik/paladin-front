# Paladin Front-End

Modern, responsive website for Paladin's autonomous security testing platform.

## Features

- 🚀 Responsive design with modern animations
- 💼 Investment interest form with Supabase integration
- 🎯 Pre-seed/seed funding stage clarity
- 🔒 Secure environment variable configuration
- ⚡ Optimized for Vercel deployment
- 🏠 Smart navigation (logo always returns to home)

## Local Development

### Option 1: Simple Static Site (No Form Functionality)
1. Clone the repository
2. Open `index.html` in your browser
3. Form submission will show a configuration warning

### Option 2: Full Development with Vercel
1. Clone the repository
2. Install Vercel CLI: `npm i -g vercel`
3. Create `.env.local` file:
   ```env
   SUPABASE_URL=your-supabase-url
   SUPABASE_ANON_KEY=your-supabase-anon-key
   ```
4. Run `vercel dev`
5. Open `http://localhost:3000`

## Supabase Database Setup

Create a table named `investment_interests` with the following columns:

```sql
CREATE TABLE investment_interests (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    title TEXT NOT NULL,
    company TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    submitted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

## Features

- Responsive design
- Investment interest form with Supabase integration
- Animated UI elements
- Clean, professional styling
- Form validation and error handling

## Deployment on Vercel

### Automatic Deployment (Recommended)
1. Connect your GitHub repository to Vercel
2. Set environment variables in Vercel dashboard:
   - `SUPABASE_URL`: Your Supabase project URL
   - `SUPABASE_ANON_KEY`: Your Supabase anon/public key
3. Deploy automatically on every push to main branch

### Manual Deployment
1. Install Vercel CLI: `npm i -g vercel`
2. Run `vercel` in project directory
3. Follow the prompts to set up your project
4. Add environment variables via Vercel dashboard or CLI:
   ```bash
   vercel env add SUPABASE_URL
   vercel env add SUPABASE_ANON_KEY
   ```

### Security Features
- ✅ No credentials exposed in frontend code
- ✅ Environment variables injected at build time
- ✅ Secure Supabase integration
- ✅ No sensitive data in repository

## Navigation Features
- **Smart Logo Navigation**: Clicking the Paladin logo from any page (including investment form) returns to the top of the home page
- **Investment Clarity**: Clearly states "pre-seed/seed funding round" stage
- **Smooth Transitions**: All page navigation includes smooth scrolling and transitions
