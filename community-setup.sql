-- COMMUNITY TABLES SETUP
-- À exécuter dans Supabase > SQL Editor

CREATE TABLE IF NOT EXISTS community_posts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  author_name TEXT NOT NULL DEFAULT 'Anonyme',
  type TEXT NOT NULL CHECK (type IN ('signalement', 'message', 'support')),
  title TEXT,
  content TEXT NOT NULL,
  place_id UUID REFERENCES places(id) ON DELETE SET NULL,
  place_name TEXT,
  place_lat DOUBLE PRECISION,
  place_lon DOUBLE PRECISION,
  status TEXT DEFAULT 'ouvert',
  likes_count INTEGER DEFAULT 0,
  replies_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS community_replies (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  post_id UUID REFERENCES community_posts(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  author_name TEXT NOT NULL DEFAULT 'Anonyme',
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS community_likes (
  user_id UUID NOT NULL,
  post_id UUID REFERENCES community_posts(id) ON DELETE CASCADE,
  PRIMARY KEY (user_id, post_id)
);

-- RLS
ALTER TABLE community_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE community_replies ENABLE ROW LEVEL SECURITY;
ALTER TABLE community_likes ENABLE ROW LEVEL SECURITY;

-- Lecture publique
CREATE POLICY "lecture publique posts" ON community_posts FOR SELECT USING (true);
CREATE POLICY "lecture publique replies" ON community_replies FOR SELECT USING (true);
CREATE POLICY "lecture publique likes" ON community_likes FOR SELECT USING (true);

-- Ecriture authentifiée
CREATE POLICY "insert authentifie posts" ON community_posts FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "insert authentifie replies" ON community_replies FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "insert authentifie likes" ON community_likes FOR INSERT WITH CHECK (auth.uid()::text = user_id::text);

-- Update (likes_count, replies_count, status)
CREATE POLICY "update posts" ON community_posts FOR UPDATE USING (true);

-- NOTIFICATIONS
CREATE TABLE IF NOT EXISTS notifications (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  type TEXT NOT NULL,
  message TEXT NOT NULL,
  post_id UUID REFERENCES community_posts(id) ON DELETE CASCADE,
  place_id UUID REFERENCES places(id) ON DELETE CASCADE,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
CREATE POLICY "lecture notifs" ON notifications FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "insert notifs" ON notifications FOR INSERT WITH CHECK (true);
CREATE POLICY "update notifs" ON notifications FOR UPDATE USING (auth.uid() = user_id);

-- Activer Realtime sur notifications
ALTER PUBLICATION supabase_realtime ADD TABLE notifications;
