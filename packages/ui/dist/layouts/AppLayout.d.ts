import { ReactNode } from 'react';
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
export default function AppLayout({ children, serviceName, serviceColor, showServiceSwitcher, customNavLinks, showFooter }: AppLayoutProps): import("react/jsx-runtime").JSX.Element;
//# sourceMappingURL=AppLayout.d.ts.map