"use strict";
'use client';
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AccountNavDropDown = AccountNavDropDown;
const jsx_runtime_1 = require("react/jsx-runtime");
const react_1 = require("react");
const link_1 = __importDefault(require("next/link"));
function AccountNavDropDown() {
    const [isOpen, setIsOpen] = (0, react_1.useState)(false);
    const dropdownRef = (0, react_1.useRef)(null);
    // Close dropdown when clicking outside
    (0, react_1.useEffect)(() => {
        function handleClickOutside(event) {
            if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
                setIsOpen(false);
            }
        }
        document.addEventListener('mousedown', handleClickOutside);
        return () => document.removeEventListener('mousedown', handleClickOutside);
    }, []);
    const navigationItems = [
        {
            id: 'export',
            label: 'Export Data',
            description: 'Download your account data',
            href: '/account/export',
            icon: '📤'
        },
        {
            id: 'help',
            label: 'Help & Support',
            description: 'Get help with your account',
            href: '/help',
            icon: '❓'
        }
    ];
    return ((0, jsx_runtime_1.jsxs)("div", { className: "relative", ref: dropdownRef, children: [(0, jsx_runtime_1.jsxs)("button", { onClick: () => setIsOpen(!isOpen), className: "flex items-center space-x-2 px-3 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors w-full", "aria-expanded": isOpen, "aria-haspopup": "true", children: [(0, jsx_runtime_1.jsx)("span", { children: "\u2699\uFE0F" }), (0, jsx_runtime_1.jsx)("span", { children: "Quick Actions" }), (0, jsx_runtime_1.jsx)("svg", { className: `w-4 h-4 transition-transform duration-200 ml-auto ${isOpen ? 'rotate-180' : ''}`, fill: "none", stroke: "currentColor", viewBox: "0 0 24 24", children: (0, jsx_runtime_1.jsx)("path", { strokeLinecap: "round", strokeLinejoin: "round", strokeWidth: 2, d: "M19 9l-7 7-7-7" }) })] }), isOpen && ((0, jsx_runtime_1.jsx)("div", { className: "absolute right-0 mt-2 w-64 bg-white rounded-lg shadow-lg border border-gray-200 z-50 py-2", children: (0, jsx_runtime_1.jsxs)("div", { className: "px-3 py-2", children: [(0, jsx_runtime_1.jsx)("h3", { className: "text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2", children: "Quick Actions" }), (0, jsx_runtime_1.jsx)("div", { className: "space-y-1", children: navigationItems.map((item) => ((0, jsx_runtime_1.jsxs)(link_1.default, { href: item.href, className: "flex items-start space-x-3 p-2 rounded-lg transition-colors hover:bg-gray-50", onClick: () => setIsOpen(false), children: [(0, jsx_runtime_1.jsx)("span", { className: "text-lg", children: item.icon }), (0, jsx_runtime_1.jsxs)("div", { className: "flex-1 min-w-0", children: [(0, jsx_runtime_1.jsx)("div", { className: "text-sm font-medium text-gray-900", children: item.label }), (0, jsx_runtime_1.jsx)("div", { className: "text-xs text-gray-500 mt-1", children: item.description })] })] }, item.id))) })] }) }))] }));
}
//# sourceMappingURL=AccountNavDropDown.js.map