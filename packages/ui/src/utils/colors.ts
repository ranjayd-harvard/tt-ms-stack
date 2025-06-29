// packages/ui/src/utils/colors.ts
export const serviceColors = {
    blue: {
      primary: 'bg-blue-600 hover:bg-blue-700',
      light: 'bg-blue-100 text-blue-800',
      text: 'text-blue-600',
      border: 'border-blue-200'
    },
    green: {
      primary: 'bg-green-600 hover:bg-green-700',
      light: 'bg-green-100 text-green-800',
      text: 'text-green-600',
      border: 'border-green-200'
    },
    purple: {
      primary: 'bg-purple-600 hover:bg-purple-700',
      light: 'bg-purple-100 text-purple-800',
      text: 'text-purple-600',
      border: 'border-purple-200'
    },
    red: {
      primary: 'bg-red-600 hover:bg-red-700',
      light: 'bg-red-100 text-red-800',
      text: 'text-red-600',
      border: 'border-red-200'
    }
  } as const
  
  export type ServiceColor = keyof typeof serviceColors
  
  export function getServiceColorClasses(color: ServiceColor) {
    return serviceColors[color]
  }
  
  