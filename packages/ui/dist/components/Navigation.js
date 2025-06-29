"use strict";
'use client';
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = Navigation;
const jsx_runtime_1 = require("react/jsx-runtime");
const TopRightMenu_1 = require("./TopRightMenu");
function Navigation({ serviceName, serviceColor = 'blue', showServiceSwitcher = true, customLinks = [] }) {
    const colorClasses = {
        blue: 'bg-blue-600 hover:bg-blue-700',
        green: 'bg-green-600 hover:bg-green-700',
        purple: 'bg-purple-600 hover:bg-purple-700',
        red: 'bg-red-600 hover:bg-red-700'
    };
    return ((0, jsx_runtime_1.jsx)("nav", { className: "bg-white shadow-sm border-b relative z-50", children: (0, jsx_runtime_1.jsxs)("div", { className: "max-w-7xl mx-auto px-4 sm:px-6 lg:px-8", children: [(0, jsx_runtime_1.jsxs)("div", { className: "flex justify-between h-16", children: [(0, jsx_runtime_1.jsxs)("div", { className: "flex items-center", children: [(0, jsx_runtime_1.jsxs)("a", { href: "/", className: "flex items-center space-x-2", children: [(0, jsx_runtime_1.jsx)("div", { className: `w-8 h-8 ${colorClasses[serviceColor]} rounded-lg flex items-center justify-center text-white font-bold transition-all duration-200`, children: serviceName.charAt(0).toUpperCase() }), (0, jsx_runtime_1.jsx)("span", { className: "text-xl font-semibold text-gray-900", children: serviceName })] }), (0, jsx_runtime_1.jsxs)("div", { className: "hidden md:ml-8 md:flex md:space-x-8", children: [(0, jsx_runtime_1.jsx)("a", { href: "/", className: "text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors", children: "Home" }), customLinks.map((link) => ((0, jsx_runtime_1.jsx)("a", { href: link.href, className: "text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors", ...(link.external && { target: "_blank", rel: "noopener noreferrer" }), children: link.label }, link.href)))] })] }), (0, jsx_runtime_1.jsx)("div", { className: "flex items-center", children: (0, jsx_runtime_1.jsx)(TopRightMenu_1.TopRightMenu, { serviceName: serviceName, serviceColor: serviceColor, showServiceSwitcher: showServiceSwitcher }) })] }), (0, jsx_runtime_1.jsx)("div", { className: "md:hidden border-t border-gray-200 py-2", children: (0, jsx_runtime_1.jsx)("div", { className: "flex justify-between items-center", children: (0, jsx_runtime_1.jsx)(TopRightMenu_1.TopRightMenu, { serviceName: serviceName, serviceColor: serviceColor, showServiceSwitcher: showServiceSwitcher }) }) })] }) }));
}
//# sourceMappingURL=Navigation.js.map