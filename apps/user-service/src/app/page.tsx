export default function HomePage() {
  return (
    <div className="main-content">
      <h1 className="page-title">User Management Dashboard</h1>
      
      <div className="dashboard-grid">
        {/* Manage Users Card */}
        <div className="dashboard-card">
          <div className="card-icon">
            👥
          </div>
          <h3 className="card-title">Manage Users</h3>
          <p className="card-description">
            View and manage user accounts, roles, and permissions.
          </p>
          <button className="card-button">
            View Users
          </button>
        </div>

        {/* Roles & Permissions Card */}
        <div className="dashboard-card">
          <div className="card-icon">
            🛡️
          </div>
          <h3 className="card-title">Roles & Permissions</h3>
          <p className="card-description">
            Configure user roles and access control.
          </p>
          <button className="card-button">
            Manage Roles
          </button>
        </div>

        {/* Analytics Card */}
        <div className="dashboard-card">
          <div className="card-icon">
            📊
          </div>
          <h3 className="card-title">Analytics</h3>
          <p className="card-description">
            View user activity and system statistics.
          </p>
          <button className="card-button">
            View Analytics
          </button>
        </div>
      </div>

      <div className="welcome-message">
        Welcome back, Ranjay Kumar!
      </div>
    </div>
  )
}
