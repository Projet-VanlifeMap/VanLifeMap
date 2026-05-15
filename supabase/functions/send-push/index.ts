import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
// @deno-types="npm:@types/web-push@3.6.3"
import webpush from "npm:web-push@3.6.7";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });
  if (req.method !== "POST") return new Response("Method Not Allowed", { status: 405 });

  try {
    const VAPID_PUBLIC_KEY = Deno.env.get("VAPID_PUBLIC_KEY")!;
    const VAPID_PRIVATE_KEY = Deno.env.get("VAPID_PRIVATE_KEY")!;

    webpush.setVapidDetails(
      "mailto:mypoiuytreza@gmail.com",
      VAPID_PUBLIC_KEY,
      VAPID_PRIVATE_KEY
    );

    const { user_ids, title, body, url } = await req.json();

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

    let query = supabase.from("push_subscriptions").select("id,endpoint,p256dh,auth");
    if (user_ids && user_ids.length > 0) query = query.in("user_id", user_ids);
    const { data: subs } = await query;

    if (!subs || subs.length === 0) {
      return new Response(JSON.stringify({ sent: 0, total: 0 }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const payload = JSON.stringify({
      title: title || "ANY",
      body: body || "",
      url: url || "/",
    });

    const results = await Promise.allSettled(
      subs.map((sub: any) =>
        webpush.sendNotification(
          { endpoint: sub.endpoint, keys: { p256dh: sub.p256dh, auth: sub.auth } },
          payload,
          { TTL: 86400 }
        )
      )
    );

    // Clean up expired/invalid subscriptions
    const deadIds = results
      .map((r, i) => r.status === "rejected" ? subs[i]?.id : null)
      .filter(Boolean);
    if (deadIds.length > 0) {
      await supabase.from("push_subscriptions").delete().in("id", deadIds);
    }

    const sent = results.filter((r) => r.status === "fulfilled").length;
    return new Response(JSON.stringify({ sent, total: subs.length }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err: any) {
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
