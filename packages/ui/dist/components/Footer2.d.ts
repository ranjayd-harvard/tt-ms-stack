interface MenuItem {
    title: string;
    links: {
        text: string;
        url: string;
    }[];
}
interface Footer2Props {
    logo?: {
        url: string;
        src: string;
        alt: string;
        title: string;
    };
    tagline?: string;
    menuItems?: MenuItem[];
    copyright?: string;
    bottomLinks?: {
        text: string;
        url: string;
    }[];
}
declare const Footer2: ({ logo, tagline, menuItems, copyright, bottomLinks, }: Footer2Props) => import("react/jsx-runtime").JSX.Element;
export { Footer2 };
//# sourceMappingURL=Footer2.d.ts.map