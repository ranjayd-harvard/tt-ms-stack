interface EnhancedNavigationProps {
    serviceName: string;
    serviceColor?: 'blue' | 'green' | 'purple' | 'red';
    serviceIcon?: string;
    customLinks?: Array<{
        href: string;
        label: string;
        external?: boolean;
    }>;
}
export default function EnhancedNavigation({ serviceName, serviceColor, serviceIcon, customLinks }: EnhancedNavigationProps): import("react/jsx-runtime").JSX.Element;
export {};
//# sourceMappingURL=EnhancedNavigation.d.ts.map