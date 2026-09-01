import { createClient } from "@supabase/supabase-js";
import ws from "ws";

/**
 * Service-role Supabase client for Tier 3 ingestion scripts.
 * `ws` is required on Node.js < 22 (no native WebSocket).
 */
export const supabaseAdmin = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY,
  {
    auth: {
      persistSession: false,
      autoRefreshToken: false,
    },
    realtime: {
      transport: ws,
    },
  },
);
