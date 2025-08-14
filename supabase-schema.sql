-- Supabase SQL Schema for Paladin Investment Opportunity Form
-- Run this in the Supabase SQL Editor

-- Create the investment_interests table
CREATE TABLE IF NOT EXISTS investment_interests (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    title TEXT NOT NULL,
    company TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    submitted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    ip_address INET,
    user_agent TEXT,
    referrer TEXT,
    utm_source TEXT,
    utm_medium TEXT,
    utm_campaign TEXT,
    status TEXT DEFAULT 'new' CHECK (status IN ('new', 'contacted', 'qualified', 'meeting_scheduled', 'proposal_sent', 'closed_won', 'closed_lost')),
    notes TEXT,
    follow_up_date DATE,
    investment_amount_range TEXT,
    investment_stage_preference TEXT,
    previous_investments BOOLEAN DEFAULT FALSE,
    accredited_investor BOOLEAN,
    contact_preference TEXT DEFAULT 'email' CHECK (contact_preference IN ('email', 'phone', 'both')),
    source TEXT DEFAULT 'website'
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_investment_interests_email ON investment_interests(email);
CREATE INDEX IF NOT EXISTS idx_investment_interests_submitted_at ON investment_interests(submitted_at DESC);
CREATE INDEX IF NOT EXISTS idx_investment_interests_status ON investment_interests(status);
CREATE INDEX IF NOT EXISTS idx_investment_interests_company ON investment_interests(company);

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger for updated_at
DROP TRIGGER IF EXISTS update_investment_interests_updated_at ON investment_interests;
CREATE TRIGGER update_investment_interests_updated_at
    BEFORE UPDATE ON investment_interests
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Enable Row Level Security (RLS)
ALTER TABLE investment_interests ENABLE ROW LEVEL SECURITY;

-- Create policy for inserting (allow anonymous inserts for form submissions)
CREATE POLICY "Allow anonymous inserts" ON investment_interests
    FOR INSERT 
    WITH CHECK (true);

-- Create policy for reading (only for authenticated users with proper role)
CREATE POLICY "Allow authenticated reads" ON investment_interests
    FOR SELECT 
    USING (auth.role() = 'authenticated');

-- Create policy for updating (only for authenticated users with proper role)
CREATE POLICY "Allow authenticated updates" ON investment_interests
    FOR UPDATE 
    USING (auth.role() = 'authenticated')
    WITH CHECK (auth.role() = 'authenticated');

-- Create a view for analytics (optional)
CREATE OR REPLACE VIEW investment_analytics AS
SELECT 
    DATE_TRUNC('day', submitted_at) as submission_date,
    COUNT(*) as daily_submissions,
    COUNT(DISTINCT email) as unique_emails,
    COUNT(CASE WHEN phone IS NOT NULL THEN 1 END) as submissions_with_phone,
    status,
    source
FROM investment_interests
GROUP BY DATE_TRUNC('day', submitted_at), status, source
ORDER BY submission_date DESC;

-- Grant permissions for the analytics view
GRANT SELECT ON investment_analytics TO authenticated;

-- Create a function to get submission stats
CREATE OR REPLACE FUNCTION get_investment_stats()
RETURNS JSON AS $$
DECLARE
    result JSON;
BEGIN
    SELECT json_build_object(
        'total_submissions', (SELECT COUNT(*) FROM investment_interests),
        'submissions_today', (SELECT COUNT(*) FROM investment_interests WHERE DATE(submitted_at) = CURRENT_DATE),
        'submissions_this_week', (SELECT COUNT(*) FROM investment_interests WHERE submitted_at >= DATE_TRUNC('week', NOW())),
        'submissions_this_month', (SELECT COUNT(*) FROM investment_interests WHERE submitted_at >= DATE_TRUNC('month', NOW())),
        'unique_companies', (SELECT COUNT(DISTINCT company) FROM investment_interests),
        'status_breakdown', (
            SELECT json_object_agg(status, count)
            FROM (
                SELECT status, COUNT(*) as count
                FROM investment_interests
                GROUP BY status
            ) status_counts
        )
    ) INTO result;
    
    RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission on the stats function
GRANT EXECUTE ON FUNCTION get_investment_stats() TO authenticated;

-- Create a notification function for new submissions (optional)
CREATE OR REPLACE FUNCTION notify_new_investment_interest()
RETURNS TRIGGER AS $$
BEGIN
    -- You can add webhook or email notification logic here
    -- For now, we'll just log it
    RAISE NOTICE 'New investment interest submitted: % from %', NEW.name, NEW.company;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for notifications
DROP TRIGGER IF EXISTS trigger_notify_new_investment ON investment_interests;
CREATE TRIGGER trigger_notify_new_investment
    AFTER INSERT ON investment_interests
    FOR EACH ROW
    EXECUTE FUNCTION notify_new_investment_interest();

-- Insert some sample data for testing (optional - remove in production)
-- INSERT INTO investment_interests (name, title, company, email, phone, notes)
-- VALUES 
--     ('John Doe', 'Managing Partner', 'Acme Ventures', 'john@acmeventures.com', '+1-555-0123', 'Interested in AI/ML startups'),
--     ('Jane Smith', 'Investment Director', 'TechFund Capital', 'jane@techfund.com', '+1-555-0456', 'Focus on cybersecurity investments');

-- Create a backup/export function
CREATE OR REPLACE FUNCTION export_investment_data(start_date DATE DEFAULT NULL, end_date DATE DEFAULT NULL)
RETURNS TABLE(
    id UUID,
    name TEXT,
    title TEXT,
    company TEXT,
    email TEXT,
    phone TEXT,
    submitted_at TIMESTAMP WITH TIME ZONE,
    status TEXT,
    notes TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        i.id,
        i.name,
        i.title,
        i.company,
        i.email,
        i.phone,
        i.submitted_at,
        i.status,
        i.notes
    FROM investment_interests i
    WHERE 
        (start_date IS NULL OR DATE(i.submitted_at) >= start_date)
        AND (end_date IS NULL OR DATE(i.submitted_at) <= end_date)
    ORDER BY i.submitted_at DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission on export function
GRANT EXECUTE ON FUNCTION export_investment_data(DATE, DATE) TO authenticated;
