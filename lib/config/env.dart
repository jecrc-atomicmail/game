const String clerkFrontendApi = 'clerk.yourproject.clerk.dev';
const String clerkPublishableKey = 'pk_live_yourkeyhere';

const String supabaseUrl = 'https://xyzcompany.supabase.co';
const String supabaseAnonKey =
    'public-anon-key-goes-here';

bool get isClerkConfigured {
  return clerkPublishableKey.startsWith('pk_') &&
      !clerkPublishableKey.contains('yourkeyhere');
}

bool get isSupabaseConfigured {
  return supabaseUrl.startsWith('https://') &&
      !supabaseUrl.contains('xyzcompany') &&
      !supabaseAnonKey.contains('goes-here');
}

/// Replace the placeholders above with the actual values from your Clerk/
/// Supabase dashboards before running the app. Never check real secrets
/// into source control.
