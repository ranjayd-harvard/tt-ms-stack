"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = Footer;
const jsx_runtime_1 = require("react/jsx-runtime");
const react_1 = __importDefault(require("react"));
const link_1 = __importDefault(require("next/link"));
const lucide_react_1 = require("lucide-react");
function Footer({ serviceName, showServiceLinks = true, companyName = "TT-MS-Stack", companyLogo }) {
    const currentYear = new Date().getFullYear();
    const services = [
        { name: 'Auth Service', href: process.env.NEXT_PUBLIC_AUTH_SERVICE_URL || 'http://localhost:3000', icon: '🔐' },
        { name: 'User Service', href: process.env.NEXT_PUBLIC_USER_SERVICE_URL || 'http://localhost:3001', icon: '👥' },
        { name: 'Content Service', href: process.env.NEXT_PUBLIC_CONTENT_SERVICE_URL || 'http://localhost:3002', icon: '📝' }
    ];
    const productLinks = [
        { name: 'Features', href: '/features' },
        { name: 'Pricing', href: '/pricing' },
        { name: 'Documentation', href: '/docs' },
        { name: 'API Reference', href: '/api-docs' }
    ];
    const companyLinks = [
        { name: 'About Us', href: '/about' },
        { name: 'Careers', href: '/careers' },
        { name: 'Contact', href: '/contact' },
        { name: 'Blog', href: '/blog' }
    ];
    const legalLinks = [
        { name: 'Privacy Policy', href: '/privacy' },
        { name: 'Terms of Service', href: '/terms' },
        { name: 'Cookie Policy', href: '/cookies' },
        { name: 'Security', href: '/security' }
    ];
    const socialLinks = [
        { name: 'GitHub', href: 'https://github.com', icon: lucide_react_1.Github },
        { name: 'Twitter', href: 'https://twitter.com', icon: lucide_react_1.Twitter },
        { name: 'LinkedIn', href: 'https://linkedin.com', icon: lucide_react_1.Linkedin },
        { name: 'Email', href: 'mailto:contact@company.com', icon: lucide_react_1.Mail }
    ];
    return ((0, jsx_runtime_1.jsx)("footer", { className: "bg-white border-t border-gray-200 mt-auto", children: (0, jsx_runtime_1.jsxs)("div", { className: "max-w-7xl mx-auto px-4 sm:px-6 lg:px-8", children: [(0, jsx_runtime_1.jsx)("div", { className: "py-12 lg:py-16", children: (0, jsx_runtime_1.jsxs)("div", { className: "grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-8 lg:gap-12", children: [(0, jsx_runtime_1.jsxs)("div", { className: "lg:col-span-2", children: [(0, jsx_runtime_1.jsxs)("div", { className: "flex items-center space-x-2 mb-4", children: [companyLogo ? ((0, jsx_runtime_1.jsx)("img", { src: companyLogo, alt: companyName, className: "h-8 w-8" })) : ((0, jsx_runtime_1.jsx)("div", { className: "w-8 h-8 bg-gradient-to-br from-blue-500 to-purple-600 rounded-lg flex items-center justify-center", children: (0, jsx_runtime_1.jsx)("span", { className: "text-white font-bold text-sm", children: "T" }) })), (0, jsx_runtime_1.jsx)("span", { className: "text-xl font-bold text-gray-900", children: companyName })] }), (0, jsx_runtime_1.jsx)("p", { className: "text-gray-600 text-sm leading-relaxed mb-6 max-w-md", children: "A modern microservices architecture built with Next.js, NextAuth, and TypeScript. Scalable, secure, and developer-friendly solutions for modern web applications." }), (0, jsx_runtime_1.jsx)("div", { className: "flex space-x-4", children: socialLinks.map((social) => {
                                            const IconComponent = social.icon;
                                            return ((0, jsx_runtime_1.jsx)(link_1.default, { href: social.href, className: "text-gray-400 hover:text-gray-600 transition-colors duration-200", "aria-label": social.name, target: social.href.startsWith('http') ? '_blank' : undefined, rel: social.href.startsWith('http') ? 'noopener noreferrer' : undefined, children: (0, jsx_runtime_1.jsx)(IconComponent, { className: "h-5 w-5" }) }, social.name));
                                        }) })] }), showServiceLinks && ((0, jsx_runtime_1.jsxs)("div", { children: [(0, jsx_runtime_1.jsx)("h3", { className: "text-sm font-semibold text-gray-900 uppercase tracking-wider mb-4", children: "Services" }), (0, jsx_runtime_1.jsx)("ul", { className: "space-y-3", children: services.map((service) => ((0, jsx_runtime_1.jsx)("li", { children: (0, jsx_runtime_1.jsxs)(link_1.default, { href: service.href, className: "text-sm text-gray-600 hover:text-gray-900 transition-colors duration-200 flex items-center space-x-2 group", target: service.href.startsWith('http') ? '_blank' : undefined, rel: service.href.startsWith('http') ? 'noopener noreferrer' : undefined, children: [(0, jsx_runtime_1.jsx)("span", { children: service.icon }), (0, jsx_runtime_1.jsx)("span", { children: service.name }), service.href.startsWith('http') && ((0, jsx_runtime_1.jsx)(lucide_react_1.ExternalLink, { className: "h-3 w-3 opacity-0 group-hover:opacity-100 transition-opacity duration-200" }))] }) }, service.name))) })] })), (0, jsx_runtime_1.jsxs)("div", { children: [(0, jsx_runtime_1.jsx)("h3", { className: "text-sm font-semibold text-gray-900 uppercase tracking-wider mb-4", children: "Product" }), (0, jsx_runtime_1.jsx)("ul", { className: "space-y-3", children: productLinks.map((link) => ((0, jsx_runtime_1.jsx)("li", { children: (0, jsx_runtime_1.jsx)(link_1.default, { href: link.href, className: "text-sm text-gray-600 hover:text-gray-900 transition-colors duration-200", children: link.name }) }, link.name))) })] }), (0, jsx_runtime_1.jsxs)("div", { children: [(0, jsx_runtime_1.jsx)("h3", { className: "text-sm font-semibold text-gray-900 uppercase tracking-wider mb-4", children: "Company" }), (0, jsx_runtime_1.jsx)("ul", { className: "space-y-3", children: companyLinks.map((link) => ((0, jsx_runtime_1.jsx)("li", { children: (0, jsx_runtime_1.jsx)(link_1.default, { href: link.href, className: "text-sm text-gray-600 hover:text-gray-900 transition-colors duration-200", children: link.name }) }, link.name))) })] })] }) }), (0, jsx_runtime_1.jsx)("div", { className: "border-t border-gray-200" }), (0, jsx_runtime_1.jsx)("div", { className: "py-6", children: (0, jsx_runtime_1.jsxs)("div", { className: "flex flex-col md:flex-row justify-between items-center space-y-4 md:space-y-0", children: [(0, jsx_runtime_1.jsxs)("div", { className: "flex items-center space-x-4 text-sm text-gray-600", children: [(0, jsx_runtime_1.jsxs)("span", { children: ["\u00A9 ", currentYear, " ", companyName, ". All rights reserved."] }), (0, jsx_runtime_1.jsx)("span", { className: "hidden md:block", children: "\u2022" }), (0, jsx_runtime_1.jsxs)("span", { className: "flex items-center space-x-1", children: [(0, jsx_runtime_1.jsx)("span", { children: "Made with" }), (0, jsx_runtime_1.jsx)(lucide_react_1.Heart, { className: "h-4 w-4 text-red-500 fill-current" }), (0, jsx_runtime_1.jsxs)("span", { children: ["by the ", serviceName, " team"] })] })] }), (0, jsx_runtime_1.jsx)("div", { className: "flex items-center space-x-6", children: legalLinks.map((link, index) => ((0, jsx_runtime_1.jsxs)(react_1.default.Fragment, { children: [(0, jsx_runtime_1.jsx)(link_1.default, { href: link.href, className: "text-sm text-gray-600 hover:text-gray-900 transition-colors duration-200", children: link.name }), index < legalLinks.length - 1 && ((0, jsx_runtime_1.jsx)("span", { className: "text-gray-300", children: "\u2022" }))] }, link.name))) })] }) })] }) }));
}
//# sourceMappingURL=Footer.js.map