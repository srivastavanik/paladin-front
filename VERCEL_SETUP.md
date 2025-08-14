# Vercel Deployment Setup Guide for Paladin

## Overview
This guide will help you deploy your Paladin website to Vercel with proper environment variable configuration and secure credential management.

## Prerequisites
- GitHub repository connected to Vercel
- Supabase project set up (see SUPABASE_SETUP.md)
- Vercel account

## 1. Vercel Dashboard Setup

### Connect Your Repository
1. Go to [vercel.com](https://vercel.com) and sign in
2. Click "Add New Project"
3. Import your GitHub repository `srivastavanik/paladin-front`
4. Configure the project settings:
   - **Framework Preset**: Other
   - **Root Directory**: `./`
   - **Build Command**: `npm run build` (or leave empty to use package.json)
   - **Output Directory**: Leave empty (will use root)
   - **Install Command**: `npm install`

### Environment Variables Setup
In your Vercel project dashboard:

1. Go to **Settings** → **Environment Variables**
2. Add the following variables:

```env
SUPABASE_URL=https://gwkdfvrfuzuyikfimbgh.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd3a2RmdnJmdXp1eWlrZmltYmdoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUxOTgzMjQsImV4cCI6MjA3MDc3NDMyNH0.wNldnWFwO0JWAzQl-FchJx5Nimaf2F6ed2VVsCJKYcg
```

**Environment**: Select `Production`, `Preview`, and `Development` for both variables.

## 2. Local Development Setup

### Install Vercel CLI
```bash
npm i -g vercel
```

### Login to Vercel
```bash
vercel login
```

### Link Your Project
```bash
vercel link
```
- Select your team/account
- Choose the existing project `paladin-front`

### Create Local Environment File
Create `.env.local` for local development:
```bash
# .env.local (for local development only)
SUPABASE_URL=https://gwkdfvrfuzuyikfimbgh.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd3a2RmdnJmdXp1eWlrZmltYmdoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUxOTgzMjQsImV4cCI6MjA3MDc3NDMyNH0.wNldnWFwO0JWAzQl-FchJx5Nimaf2F6ed2VVsCJKYcg
```

### Local Development Commands
```bash
# Start local development server
vercel dev

# Build locally
vercel build

# Deploy to preview
vercel

# Deploy to production
vercel --prod
```

## 3. Troubleshooting Build Issues

### Common Build Errors and Solutions

#### Error: "Function Runtimes must have a valid version"
**Solution**: Simplified deployment approach - removed serverless functions and switched to static build:
```json
{
  "headers": [
    {
      "source": "/(.*)",
      "headers": [...]
    }
  ]
}
```

#### Error: "Environment variables not found"
**Solutions**:
1. Check environment variables are set in Vercel dashboard
2. Verify variable names match exactly (case-sensitive)
3. Ensure variables are enabled for Production environment
4. Redeploy after adding variables

#### Error: "Module not found"
**Solution**: Add dependencies to `package.json`:
```json
{
  "dependencies": {
    "@vercel/node": "^3.0.0"
  }
}
```

#### Error: "Build timeout"
**Solution**: Simplify the build process or contact Vercel support for increased limits.

## 4. Environment Variable Management

### Security Best Practices
- ✅ **Never commit `.env.local`** to git (already in .gitignore)
- ✅ **Use Vercel dashboard** for production environment variables
- ✅ **Rotate keys regularly** and update in both Supabase and Vercel
- ✅ **Use different keys** for development and production if possible

### Environment Variable Sources
1. **Production**: Vercel dashboard environment variables
2. **Preview**: Vercel dashboard environment variables
3. **Local development**: `.env.local` file
4. **CI/CD**: Vercel dashboard environment variables

## 5. Deployment Workflow

### Automatic Deployments
- **Production**: Pushes to `main` branch automatically deploy to production
- **Preview**: Pull requests automatically deploy to preview URLs
- **Branch deployments**: Other branches can be configured for preview deployments

### Manual Deployments
```bash
# Deploy current branch to preview
vercel

# Deploy to production (from main branch)
vercel --prod

# Deploy specific branch to production
git checkout main
git pull origin main
vercel --prod
```

## 6. Monitoring and Analytics

### Vercel Dashboard Features
- **Deployments**: View all deployment history and logs
- **Functions**: Monitor serverless function performance
- **Analytics**: Track page views and performance metrics
- **Speed Insights**: Core Web Vitals monitoring

### Key Metrics to Monitor
- Build time and success rate
- Function execution time
- Page load performance
- Form submission success rate

## 7. Custom Domain Setup (Optional)

### Add Custom Domain
1. Go to **Settings** → **Domains**
2. Add your custom domain (e.g., `paladin.com`)
3. Configure DNS records as instructed
4. Enable HTTPS (automatic with Vercel)

### DNS Configuration
```
Type: CNAME
Name: www (or @)
Value: cname.vercel-dns.com
```

## 8. Advanced Configuration

### Custom Headers (vercel.json)
```json
{
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "X-Content-Type-Options",
          "value": "nosniff"
        },
        {
          "key": "X-Frame-Options",
          "value": "DENY"
        }
      ]
    }
  ]
}
```

### Redirects and Rewrites
```json
{
  "redirects": [
    {
      "source": "/old-path",
      "destination": "/new-path",
      "permanent": true
    }
  ]
}
```

## 9. File Structure
Your project should have this structure for Vercel:
```
paladin-front/
├── index.html              # Main website file
├── api/
│   └── build.js            # Serverless function for env injection
├── vercel.json             # Vercel configuration
├── package.json            # Dependencies
├── .env.local              # Local environment (gitignored)
├── .gitignore              # Git ignore file
└── README.md               # Project documentation
```

## 10. Testing Your Deployment

### Pre-deployment Checklist
- [ ] Environment variables set in Vercel dashboard
- [ ] Supabase database table created and configured
- [ ] Local development working with `vercel dev`
- [ ] Form submission tested locally
- [ ] Build process completes without errors

### Post-deployment Testing
1. **Form Submission**: Test the investment form
2. **Environment Variables**: Check that credentials are injected properly
3. **Performance**: Test page load speeds
4. **Mobile**: Test responsive design on mobile devices
5. **Analytics**: Verify tracking is working

## 11. Common Commands Quick Reference

```bash
# Installation and setup
npm i -g vercel
vercel login
vercel link

# Development
vercel dev                  # Local development
vercel logs                 # View logs
vercel inspect             # Debug deployment

# Deployment
vercel                     # Deploy to preview
vercel --prod              # Deploy to production
vercel --force             # Force redeploy

# Environment management
vercel env ls              # List environment variables
vercel env add             # Add environment variable
vercel env rm              # Remove environment variable

# Project management
vercel projects ls         # List projects
vercel domains ls          # List domains
vercel certs ls           # List SSL certificates
```

## 12. Support and Resources

### Documentation
- [Vercel Documentation](https://vercel.com/docs)
- [Vercel CLI Reference](https://vercel.com/docs/cli)
- [Environment Variables Guide](https://vercel.com/docs/concepts/projects/environment-variables)

### Getting Help
- Vercel Community Discord
- GitHub Issues for the project
- Vercel Support (for Pro/Enterprise plans)

### Monitoring Tools
- Vercel Analytics
- Vercel Speed Insights  
- Custom monitoring with services like LogRocket or Sentry

---

## Quick Start Commands

```bash
# 1. Install and setup
npm i -g vercel
vercel login
vercel link

# 2. Set up local environment
echo "SUPABASE_URL=https://gwkdfvrfuzuyikfimbgh.supabase.co" > .env.local
echo "SUPABASE_ANON_KEY=your-anon-key" >> .env.local

# 3. Test locally
vercel dev

# 4. Deploy
vercel --prod
```

This setup ensures your Paladin website deploys successfully with secure environment variable management and proper serverless function configuration.
