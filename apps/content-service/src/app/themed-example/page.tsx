import { Button } from '@tt-ms-stack/ui'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@tt-ms-stack/ui'

export default function ThemedExamplePage() {
  return (
    <div className="container mx-auto py-8">
      <div className="space-y-6">
        <div>
          <h1 className="text-4xl font-bold tracking-tight">content-service Theme Example</h1>
          <p className="text-lg text-muted-foreground">
            Demonstrating the consistent design system across microservices
          </p>
        </div>

        <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
          <Card>
            <CardHeader>
              <CardTitle>Component Showcase</CardTitle>
              <CardDescription>
                All services use the same design tokens and components
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <Button className="w-full">Primary Button</Button>
              <Button variant="outline" className="w-full">
                Outline Button
              </Button>
              <Button variant="secondary" className="w-full">
                Secondary Button
              </Button>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Service Colors</CardTitle>
              <CardDescription>
                Each service can have its own accent color while maintaining consistency
              </CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-2">
                <div className="w-full h-8 bg-primary rounded"></div>
                <div className="w-full h-8 bg-secondary rounded"></div>
                <div className="w-full h-8 bg-accent rounded"></div>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Typography</CardTitle>
              <CardDescription>
                Consistent typography across all services
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-2">
              <h1 className="text-2xl font-bold">Heading 1</h1>
              <h2 className="text-xl font-semibold">Heading 2</h2>
              <p className="text-sm text-muted-foreground">
                Body text with muted foreground
              </p>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  )
}
