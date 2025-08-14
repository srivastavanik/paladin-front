# Paladin Front-End

Modern, responsive website for Paladin's autonomous security testing platform.

## Setup

1. Clone the repository
2. Copy `config.sample.js` to `config.js`
3. Update `config.js` with your Supabase credentials:
   ```javascript
   window.CONFIG = {
       SUPABASE_URL: 'your-supabase-url',
       SUPABASE_ANON_KEY: 'your-supabase-anon-key'
   };
   ```

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

## Deployment

The site can be deployed to any static hosting service (Netlify, Vercel, GitHub Pages, etc.).

Make sure to:
1. Set up your `config.js` file with the correct Supabase credentials
2. Ensure your Supabase table exists and has proper permissions
3. Test the form submission functionality

## Development

Open `index.html` in your browser to view the site locally. Make sure you have a local web server running if you encounter CORS issues with the config.js file.
