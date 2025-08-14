const fs = require('fs');
const path = require('path');

module.exports = (req, res) => {
  try {
    // Read the HTML file
    const htmlPath = path.join(process.cwd(), 'index.html');
    let html = fs.readFileSync(htmlPath, 'utf8');
    
    // Replace environment variable placeholders with actual values
    const supabaseUrl = process.env.SUPABASE_URL || 'VITE_SUPABASE_URL';
    const supabaseAnonKey = process.env.SUPABASE_ANON_KEY || 'VITE_SUPABASE_ANON_KEY';
    
    // Replace the placeholder values in the HTML
    html = html.replace('VITE_SUPABASE_URL', supabaseUrl);
    html = html.replace('VITE_SUPABASE_ANON_KEY', supabaseAnonKey);
    
    // Set appropriate headers
    res.setHeader('Content-Type', 'text/html');
    res.setHeader('Cache-Control', 's-maxage=60, stale-while-revalidate');
    
    // Send the processed HTML
    res.status(200).send(html);
  } catch (error) {
    console.error('Error serving HTML:', error);
    res.status(500).send('Internal Server Error');
  }
};
