// packages/ui/src/components/LoadingSpinner.tsx
interface LoadingSpinnerProps {
    size?: 'sm' | 'md' | 'lg'
    color?: 'blue' | 'green' | 'purple' | 'red'
  }
  
  export function LoadingSpinner({ size = 'md', color = 'blue' }: LoadingSpinnerProps) {
    const sizeClasses = {
      sm: 'h-4 w-4',
      md: 'h-8 w-8',
      lg: 'h-12 w-12'
    }
  
    const colorClasses = {
      blue: 'border-blue-600',
      green: 'border-green-600',
      purple: 'border-purple-600',
      red: 'border-red-600'
    }
  
    return (
      <div className={`animate-spin rounded-full ${sizeClasses[size]} border-b-2 ${colorClasses[color]}`}></div>
    )
  }
  
  