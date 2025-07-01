"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Footer2 = void 0;
const jsx_runtime_1 = require("react/jsx-runtime");
const Footer2 = ({ logo = {
    src: "https://deifkwefumgah.cloudfront.net/shadcnblocks/block/block-1.svg",
    alt: "blocks for shadcn/ui",
    title: "Shadcnblocks.com",
    url: "https://www.shadcnblocks.com",
}, tagline = "Components made easy.", menuItems = [
    {
        title: "Product",
        links: [
            { text: "Overview", url: "#" },
            { text: "Pricing", url: "#" },
            { text: "Marketplace", url: "#" },
            { text: "Features", url: "#" },
            { text: "Integrations", url: "#" },
            { text: "Pricing", url: "#" },
        ],
    },
    {
        title: "Company",
        links: [
            { text: "About", url: "#" },
            { text: "Team", url: "#" },
            { text: "Blog", url: "#" },
            { text: "Careers", url: "#" },
            { text: "Contact", url: "#" },
            { text: "Privacy", url: "#" },
        ],
    },
    {
        title: "Resources",
        links: [
            { text: "Help", url: "#" },
            { text: "Sales", url: "#" },
            { text: "Advertise", url: "#" },
        ],
    },
    {
        title: "Social",
        links: [
            { text: "Twitter", url: "#" },
            { text: "Instagram", url: "#" },
            { text: "LinkedIn", url: "#" },
        ],
    },
], copyright = "© 2024 Shadcnblocks.com. All rights reserved.", bottomLinks = [
    { text: "Terms and Conditions", url: "#" },
    { text: "Privacy Policy", url: "#" },
], }) => {
    return ((0, jsx_runtime_1.jsx)("section", { className: "py-32", children: (0, jsx_runtime_1.jsx)("div", { className: "container", children: (0, jsx_runtime_1.jsxs)("footer", { children: [(0, jsx_runtime_1.jsxs)("div", { className: "grid grid-cols-2 gap-8 lg:grid-cols-6", children: [(0, jsx_runtime_1.jsxs)("div", { className: "col-span-2 mb-8 lg:mb-0", children: [(0, jsx_runtime_1.jsxs)("div", { className: "flex items-center gap-2 lg:justify-start", children: [(0, jsx_runtime_1.jsx)("a", { href: "https://shadcnblocks.com", children: (0, jsx_runtime_1.jsx)("img", { src: logo.src, alt: logo.alt, title: logo.title, className: "h-10" }) }), (0, jsx_runtime_1.jsx)("p", { className: "text-xl font-semibold", children: logo.title })] }), (0, jsx_runtime_1.jsx)("p", { className: "mt-4 font-bold", children: tagline })] }), menuItems.map((section, sectionIdx) => ((0, jsx_runtime_1.jsxs)("div", { children: [(0, jsx_runtime_1.jsx)("h3", { className: "mb-4 font-bold", children: section.title }), (0, jsx_runtime_1.jsx)("ul", { className: "space-y-4 text-muted-foreground", children: section.links.map((link, linkIdx) => ((0, jsx_runtime_1.jsx)("li", { className: "font-medium hover:text-primary", children: (0, jsx_runtime_1.jsx)("a", { href: link.url, children: link.text }) }, linkIdx))) })] }, sectionIdx)))] }), (0, jsx_runtime_1.jsxs)("div", { className: "mt-24 flex flex-col justify-between gap-4 border-t pt-8 text-sm font-medium text-muted-foreground md:flex-row md:items-center", children: [(0, jsx_runtime_1.jsx)("p", { children: copyright }), (0, jsx_runtime_1.jsx)("ul", { className: "flex gap-4", children: bottomLinks.map((link, linkIdx) => ((0, jsx_runtime_1.jsx)("li", { className: "underline hover:text-primary", children: (0, jsx_runtime_1.jsx)("a", { href: link.url, children: link.text }) }, linkIdx))) })] })] }) }) }));
};
exports.Footer2 = Footer2;
//# sourceMappingURL=Footer2.js.map