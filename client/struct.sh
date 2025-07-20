#!/bin/bash

base_path="./src/app"

declare -A routes=(
  ["dashboard"]="OverviewCards QuickLinks DashboardGreeting"
  ["grievance"]="GrievanceForm GrievanceList GrievanceStatusCard"
  ["events"]="EventCard EventFilter RegisterModal"
  ["feed"]="FeedPost FeedComposer FeedFilter"
  ["admin"]="UserTable EventApprovalList GrievanceResolverPanel"
  ["profile/[userId]"]="ProfileHeader ProfileTabs EditProfileModal"
  ["settings"]="ThemeSwitcher NotificationSettings PrivacySettings"
)

echo "📁 Creating folder structure..."

# Create base route files
mkdir -p $base_path
echo "export default function Page() { return <div>Home</div>; }" > $base_path/page.tsx
echo "export default function RootLayout({ children }: { children: React.ReactNode }) { return <html><body>{children}</body></html>; }" > $base_path/layout.tsx

# Create each route
for route in "${!routes[@]}"; do
  path="$base_path/$route"
  mkdir -p "$path/components"

  # page.tsx
  echo "export default function Page() { return <div>${route^}</div>; }" > "$path/page.tsx"

  # layout.tsx only for dashboard, grievance, and admin
  if [[ "$route" == "dashboard" || "$route" == "grievance" || "$route" == "admin" ]]; then
    echo "export default function Layout({ children }: { children: React.ReactNode }) { return <section>{children}</section>; }" > "$path/layout.tsx"
  fi

  # Create component files
  for component in ${routes[$route]}; do
    echo "export default function $component() { return <div>$component</div>; }" > "$path/components/$component.tsx"
  done
done

# Auth Routes
mkdir -p "$base_path/auth/login"
mkdir -p "$base_path/auth/signup"
mkdir -p "$base_path/auth/forgot-password"
echo "export default function Page() { return <div>Login</div>; }" > "$base_path/auth/login/page.tsx"
echo "export default function Page() { return <div>Signup</div>; }" > "$base_path/auth/signup/page.tsx"
echo "export default function Page() { return <div>Forgot Password</div>; }" > "$base_path/auth/forgot-password/page.tsx"

echo "✅ App structure created under $base_path"
