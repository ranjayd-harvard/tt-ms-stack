"use strict";
'use client';
Object.defineProperty(exports, "__esModule", { value: true });
exports.TopRightMenu = TopRightMenu;
const jsx_runtime_1 = require("react/jsx-runtime");
const react_1 = require("react");
const react_2 = require("next-auth/react");
const ServiceSwitcher_1 = require("./ServiceSwitcher");
const UserMenu_1 = require("./UserMenu");
function TopRightMenu({ serviceName, serviceColor = 'blue', showServiceSwitcher = true }) {
    const { data: session, status } = (0, react_2.useSession)();
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
    const colorClasses = {
        blue: 'bg-blue-600 hover:bg-blue-700',
        green: 'bg-green-600 hover:bg-green-700',
        purple: 'bg-purple-600 hover:bg-purple-700',
        red: 'bg-red-600 hover:bg-red-700'
    };
    if (status === 'loading') {
        return ((0, jsx_runtime_1.jsx)("div", { className: "flex items-center space-x-3", children: (0, jsx_runtime_1.jsx)("div", { className: "animate-pulse flex space-x-4", children: (0, jsx_runtime_1.jsx)("div", { className: "rounded-full bg-gray-200 h-8 w-8" }) }) }));
    }
    return ((0, jsx_runtime_1.jsxs)("div", { className: "flex items-center space-x-3", children: [showServiceSwitcher && ((0, jsx_runtime_1.jsx)(ServiceSwitcher_1.ServiceSwitcher, { currentService: serviceName, currentColor: serviceColor })), session ? ((0, jsx_runtime_1.jsx)(UserMenu_1.UserMenu, { serviceColor: serviceColor })) : ((0, jsx_runtime_1.jsxs)("div", { className: "relative", ref: dropdownRef, children: [(0, jsx_runtime_1.jsxs)("button", { onClick: () => setIsOpen(!isOpen), className: "flex items-center space-x-2 px-3 py-2 text-sm bg-gray-50 hover:bg-gray-100 border border-gray-200 rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-1", "aria-expanded": isOpen, "aria-haspopup": "true", children: [(0, jsx_runtime_1.jsx)("span", { className: "text-gray-700 font-medium", children: "Account" }), (0, jsx_runtime_1.jsx)("svg", { className: `w-4 h-4 text-gray-500 transition-transform duration-200 ${isOpen ? 'rotate-180' : ''}`, fill: "none", stroke: "currentColor", viewBox: "0 0 24 24", children: (0, jsx_runtime_1.jsx)("path", { strokeLinecap: "round", strokeLinejoin: "round", strokeWidth: 2, d: "M19 9l-7 7-7-7" }) })] }), isOpen && ((0, jsx_runtime_1.jsxs)("div", { className: "absolute right-0 top-full mt-2 w-64 bg-white rounded-lg shadow-xl border border-gray-200 z-[9999] py-2", children: [(0, jsx_runtime_1.jsxs)("div", { className: "px-4 py-3 border-b border-gray-100", children: [(0, jsx_runtime_1.jsx)("h3", { className: "text-sm font-semibold text-gray-700", children: "Get Started" }), (0, jsx_runtime_1.jsx)("p", { className: "text-xs text-gray-500 mt-1", children: "Sign in to access all features" })] }), (0, jsx_runtime_1.jsxs)("div", { className: "py-2 space-y-1", children: [(0, jsx_runtime_1.jsxs)("a", { href: "http://localhost:3000/auth/sign-in", className: "flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors", onClick: () => setIsOpen(false), children: [(0, jsx_runtime_1.jsx)("span", { className: "mr-3", children: "\uD83D\uDD11" }), "Sign In", (0, jsx_runtime_1.jsx)("span", { className: "ml-auto text-xs text-gray-400", children: "Existing user" })] }), (0, jsx_runtime_1.jsxs)("a", { href: "http://localhost:3000/auth/sign-up", className: `flex items-center px-4 py-2 text-sm text-white ${colorClasses[serviceColor]} rounded-md mx-2 transition-colors`, onClick: () => setIsOpen(false), children: [(0, jsx_runtime_1.jsx)("span", { className: "mr-3", children: "\u2728" }), "Create Account", (0, jsx_runtime_1.jsx)("span", { className: "ml-auto text-xs opacity-75", children: "Free" })] })] }), (0, jsx_runtime_1.jsx)("div", { className: "border-t border-gray-100 px-4 py-2 mt-2", children: (0, jsx_runtime_1.jsx)("div", { className: "text-xs text-gray-500", children: "\uD83D\uDD10 Secure authentication across all services" }) })] }))] }))] }));
}
exports.default = TopRightMenu;
//# sourceMappingURL=TopRightMenu.js.map