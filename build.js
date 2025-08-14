const fs = require('fs');
const path = require('path');

// Build script to inject environment variables
try {
  // Read the HTML file
  const htmlPath = path.join(__dirname, 'index.html');
  let html = fs.readFileSync(htmlPath, 'utf8');
  
  // Replace environment variable placeholders with actual values
  const supabaseUrl = process.env.SUPABASE_URL || 'VITE_SUPABASE_URL';
  const supabaseAnonKey = process.env.SUPABASE_ANON_KEY || 'VITE_SUPABASE_ANON_KEY';
  
  // Replace the placeholder values in the HTML
  html = html.replace('VITE_SUPABASE_URL', supabaseUrl);
  html = html.replace('VITE_SUPABASE_ANON_KEY', supabaseAnonKey);
  
  // Write the processed HTML back
  fs.writeFileSync(htmlPath, html);
  
  console.log('✅ Environment variables injected successfully');
  console.log(`🔗 Supabase URL: ${supabaseUrl.substring(0, 30)}...`);
  console.log(`🔑 Anon Key: ${supabaseAnonKey.substring(0, 20)}...`);
} catch (error) {
  console.error('❌ Error processing HTML:', error);
  process.exit(1);
}
