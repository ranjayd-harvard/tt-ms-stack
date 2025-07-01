export default function ThemeTestPage() {
  return (
    <div className="main-content">
      <h1 className="page-title">Auth Service Theme Test</h1>
      
      <div className="dashboard-grid">
        <div className="dashboard-card">
          <div className="card-icon">🎨</div>
          <h3 className="card-title">Theme Demonstration</h3>
          <p className="card-description">
            This card shows the blue theme in action. Notice the colors automatically
            match the service theme.
          </p>
          <button className="card-button">
            Auth Themed Button
          </button>
        </div>
        
        <div className="dashboard-card service-indicator">
          <div className="card-icon">🔧</div>
          <h3 className="card-title">CSS Variables</h3>
          <p className="card-description">
            The theme uses CSS variables that automatically change colors
            based on the .auth-theme class.
          </p>
          <button className="card-button">
            Test Variables
          </button>
        </div>
        
        <div className="dashboard-card">
          <div className="card-icon">✨</div>
          <h3 className="card-title">Consistent Design</h3>
          <p className="card-description">
            All services share the same components and layout, but with
            different color schemes.
          </p>
          <button className="card-button">
            See Consistency
          </button>
        </div>
      </div>
      
      <div className="welcome-message">
        <p>Visit this page on other services to see different color themes!</p>
        <p>
          <strong>Auth Service:</strong> Blue theme |
          <strong>User Service:</strong> Green theme |
          <strong>Content Service:</strong> Purple theme
        </p>
      </div>
    </div>
  )
}
