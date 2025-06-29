#!/bin/bash

echo "Creating manual CSS as fallback..."

services=("auth-service" "user-service" "content-service")

for service in "${services[@]}"; do
    echo "Creating manual CSS for $service..."
    
    cat > "apps/$service/src/app/globals.css" << 'EOL'
/* Manual CSS without Tailwind - matches Auth Service styling */

* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  line-height: 1.6;
  color: #374151;
  background-color: #f9fafb;
}

/* Navigation styles */
nav {
  background-color: white;
  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
  border-bottom: 1px solid #e5e7eb;
}

.nav-container {
  max-width: 1280px;
  margin: 0 auto;
  padding: 0 1rem;
}

.nav-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 4rem;
}

.nav-left {
  display: flex;
  align-items: center;
}

.service-logo {
  display: flex;
  align-items: center;
  text-decoration: none;
  margin-right: 2rem;
}

.logo-icon {
  width: 2rem;
  height: 2rem;
  border-radius: 0.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-weight: bold;
  margin-right: 0.5rem;
  transition: all 0.2s;
}

.service-name {
  font-size: 1.25rem;
  font-weight: 600;
  color: #111827;
}

.nav-links {
  display: flex;
  gap: 2rem;
}

.nav-link {
  color: #374151;
  text-decoration: none;
  padding: 0.5rem 0.75rem;
  border-radius: 0.375rem;
  font-size: 0.875rem;
  font-weight: 500;
  transition: color 0.2s;
}

.nav-link:hover {
  color: #2563eb;
}

.service-switcher {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.switch-label {
  font-size: 0.875rem;
  color: #6b7280;
}

.switch-link {
  font-size: 0.75rem;
  padding: 0.25rem 0.5rem;
  border-radius: 0.25rem;
  color: #6b7280;
  text-decoration: none;
  transition: color 0.2s;
}

.switch-link:hover {
  color: #111827;
}

.switch-current {
  background-color: #e5e7eb;
  color: #111827;
}

.auth-buttons {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.btn {
  padding: 0.5rem 1rem;
  border-radius: 0.375rem;
  font-size: 0.875rem;
  font-weight: 500;
  text-decoration: none;
  transition: all 0.2s;
  border: none;
  cursor: pointer;
}

.btn-primary {
  color: white;
  background-color: #2563eb;
}

.btn-primary:hover {
  background-color: #1d4ed8;
}

.btn-secondary {
  color: #374151;
}

.btn-secondary:hover {
  color: #2563eb;
}

/* Main content */
main {
  max-width: 1280px;
  margin: 0 auto;
  padding: 1.5rem;
}

/* Service-specific colors */
.auth-service .logo-icon { background-color: #2563eb; }
.auth-service .btn-primary { background-color: #2563eb; }

.user-service .logo-icon { background-color: #059669; }
.user-service .btn-primary { background-color: #059669; }

.content-service .logo-icon { background-color: #7c3aed; }
.content-service .btn-primary { background-color: #7c3aed; }

/* Responsive */
@media (max-width: 768px) {
  .nav-links,
  .service-switcher {
    display: none;
  }
}
EOL

    echo "✅ Manual CSS created for $service"
done
