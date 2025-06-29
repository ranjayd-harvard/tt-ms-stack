interface NavigationProps {
    serviceName: string;
    serviceColor?: 'blue' | 'green' | 'purple' | 'red';
    showServiceSwitcher?: boolean;
    customLinks?: Array<{
        href: string;
        label: string;
        external?: boolean;
    }>;
}
export default function Navigation({ serviceName, serviceColor, showServiceSwitcher, customLinks }: NavigationProps): import("react/jsx-runtime").JSX.Element;
export {};
//# sourceMappingURL=Navigation.d.ts.map