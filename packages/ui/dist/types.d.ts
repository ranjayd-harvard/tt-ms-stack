import { ReactNode } from 'react';
export interface NavigationProps {
    serviceName: string;
    serviceColor?: 'blue' | 'green' | 'purple' | 'red';
    showServiceSwitcher?: boolean;
    customLinks?: Array<{
        href: string;
        label: string;
        external?: boolean;
    }>;
}
export interface AppLayoutProps {
    children: ReactNode;
    serviceName: string;
    serviceColor?: 'blue' | 'green' | 'purple' | 'red';
    showServiceSwitcher?: boolean;
    customNavLinks?: Array<{
        href: string;
        label: string;
        external?: boolean;
    }>;
    showFooter?: boolean;
}
//# sourceMappingURL=types.d.ts.map