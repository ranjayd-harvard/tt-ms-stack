import React from 'react';
export interface AppLayoutProps {
    children: React.ReactNode;
    serviceName: string;
    serviceColor?: 'blue' | 'green' | 'purple' | 'red';
    showServiceSwitcher?: boolean;
    customNavLinks?: Array<{
        href: string;
        label: string;
        external?: boolean;
    }>;
    showFooter?: boolean;
    companyName?: string;
    companyLogo?: string;
    showServiceLinksInFooter?: boolean;
}
export default function AppLayout({ children, serviceName, serviceColor, showServiceSwitcher, customNavLinks, showFooter, companyName, companyLogo, showServiceLinksInFooter }: AppLayoutProps): import("react/jsx-runtime").JSX.Element;
//# sourceMappingURL=AppLayout.d.ts.map