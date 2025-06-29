"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = Footer;
const jsx_runtime_1 = require("react/jsx-runtime");
function Footer({ serviceName }) {
    const currentYear = new Date().getFullYear();
    return ((0, jsx_runtime_1.jsx)("footer", { className: "bg-white border-t border-gray-200 mt-auto", children: (0, jsx_runtime_1.jsxs)("div", { className: "max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8", children: [(0, jsx_runtime_1.jsxs)("div", { className: "flex flex-col md:flex-row justify-between items-center", children: [(0, jsx_runtime_1.jsx)("div", { className: "text-gray-600 text-sm", children: "My Stack 111" }), (0, jsx_runtime_1.jsxs)("div", { className: "flex space-x-6 mt-4 md:mt-0", children: [(0, jsx_runtime_1.jsx)("a", { href: "/privacy", className: "text-gray-600 hover:text-gray-900 text-sm transition-colors", children: "Privacy Policy" }), (0, jsx_runtime_1.jsx)("a", { href: "/terms", className: "text-gray-600 hover:text-gray-900 text-sm transition-colors", children: "Terms of Service" }), (0, jsx_runtime_1.jsx)("a", { href: "/support", className: "text-gray-600 hover:text-gray-900 text-sm transition-colors", children: "Support" })] })] }), (0, jsx_runtime_1.jsx)("div", { className: "mt-4 pt-4 border-t border-gray-100", children: (0, jsx_runtime_1.jsxs)("div", { className: "text-xs text-gray-500 text-center md:text-left", children: ["\u00A9 ", currentYear, " ", serviceName, ". Part of TT-MS-Stack."] }) })] }) }));
}
//# sourceMappingURL=Footer.js.map