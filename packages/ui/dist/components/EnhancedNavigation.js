"use strict";
'use client';
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = EnhancedNavigation;
const jsx_runtime_1 = require("react/jsx-runtime");
const react_1 = require("next-auth/react");
const link_1 = __importDefault(require("next/link"));
const react_2 = require("react");
// Simple ProfileAvatar component
function ProfileAvatar({ src, name, email, size = 'sm' }) {
    const sizeClasses = {
        sm: 'h-8 w-8 text-sm',
        md: 'h-10 w-10 text-base'
    };
    const getInitials = () => {
        if (name) {
            return name.split(' ').map(n => n[0]).join('').toUpperCase().slice(0, 2);
        }
        if (email) {
            return email[0].toUpperCase();
        }
        return '?';
    };
    return ((0, jsx_runtime_1.jsx)("div", { className: "relative", children: src ? ((0, jsx_runtime_1.jsx)("img", { className: `${sizeClasses[size]} rounded-full object-cover`, src: src, alt: name || email || 'User avatar' })) : ((0, jsx_runtime_1.jsx)("div", { className: `${sizeClasses[size]} rounded-full bg-gray-500 flex items-center justify-center text-white font-medium`, children: getInitials() })) }));
}
function EnhancedNavigation({ serviceName = "Auth Service", serviceColor = 'blue', serviceIcon = 'A', customLinks = [] }) {
    const { data: session, status } = (0, react_1.useSession)();
    const [showUserMenu, setShowUserMenu] = (0, react_2.useState)(false);
    const [showServiceMenu, setShowServiceMenu] = (0, react_2.useState)(false);
    const [showMobileMenu, setShowMobileMenu] = (0, react_2.useState)(false);
    const [authMethodsCount] = (0, react_2.useState)(1); // Simplified for now
    const menuRef = (0, react_2.useRef)(null);
    const serviceMenuRef = (0, react_2.useRef)(null);
    // Close menus when clicking outside
    (0, react_2.useEffect)(() => {
        function handleClickOutside(event) {
            if (menuRef.current && !menuRef.current.contains(event.target)) {
                setShowUserMenu(false);
            }
            if (serviceMenuRef.current && !serviceMenuRef.current.contains(event.target)) {
                setShowServiceMenu(false);
            }
        }
        document.addEventListener('mousedown', handleClickOutside);
        return () => document.removeEventListener('mousedown', handleClickOutside);
    }, []);
    const getAccountStatus = () => {
        return {
            text: `${authMethodsCount} sign-in method${authMethodsCount !== 1 ? 's' : ''}`,
            color: 'text-green-600'
        };
    };
    const colorClasses = {
        blue: 'bg-blue-600',
        green: 'bg-green-600',
        purple: 'bg-purple-600',
        red: 'bg-red-600'
    };
    const services = [
        {
            name: 'Auth Service',
            url: 'http://localhost:3000',
            icon: '🔐',
            description: 'Authentication & Authorization'
        },
        {
            name: 'User Service',
            url: 'http://localhost:3001',
            icon: '👥',
            description: 'User Management'
        },
        {
            name: 'Content Service',
            url: 'http://localhost:3002',
            icon: '📝',
            description: 'Content Management'
        }
    ];
    return ((0, jsx_runtime_1.jsx)("nav", { className: "bg-white shadow-sm border-b sticky top-0 z-50", children: (0, jsx_runtime_1.jsxs)("div", { className: "max-w-7xl mx-auto px-4 sm:px-6 lg:px-8", children: [(0, jsx_runtime_1.jsxs)("div", { className: "flex justify-between h-16", children: [(0, jsx_runtime_1.jsxs)("div", { className: "flex items-center space-x-8", children: [(0, jsx_runtime_1.jsxs)(link_1.default, { href: "/", className: "flex items-center space-x-2", children: [(0, jsx_runtime_1.jsx)("div", { className: `w-8 h-8 ${colorClasses[serviceColor]} rounded-lg flex items-center justify-center`, children: (0, jsx_runtime_1.jsx)("span", { className: "text-white font-bold text-sm", children: serviceIcon }) }), (0, jsx_runtime_1.jsx)("span", { className: "text-xl font-semibold text-gray-900", children: serviceName })] }), (0, jsx_runtime_1.jsxs)("div", { className: "hidden md:flex space-x-6", children: [(0, jsx_runtime_1.jsx)(link_1.default, { href: "/", className: "text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors", children: "Home" }), (0, jsx_runtime_1.jsx)(link_1.default, { href: "/about", className: "text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors", children: "About" }), session && ((0, jsx_runtime_1.jsx)(link_1.default, { href: "/dashboard", className: "text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors", children: "Dashboard" })), customLinks.map((link) => ((0, jsx_runtime_1.jsx)(link_1.default, { href: link.href, className: "text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors", ...(link.external && { target: "_blank", rel: "noopener noreferrer" }), children: link.label }, link.href)))] })] }), (0, jsx_runtime_1.jsxs)("div", { className: "flex items-center space-x-4", children: [(0, jsx_runtime_1.jsxs)("div", { className: "relative", ref: serviceMenuRef, children: [(0, jsx_runtime_1.jsxs)("button", { onClick: () => setShowServiceMenu(!showServiceMenu), className: "flex items-center space-x-2 px-3 py-2 text-sm bg-gray-50 hover:bg-gray-100 border border-gray-200 rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-1", children: [(0, jsx_runtime_1.jsx)("span", { className: "text-lg", children: services.find(s => s.name === serviceName)?.icon || '⚙️' }), (0, jsx_runtime_1.jsx)("span", { className: "font-medium text-gray-700", children: serviceName }), (0, jsx_runtime_1.jsx)("svg", { className: `w-4 h-4 text-gray-500 transition-transform duration-200 ${showServiceMenu ? 'rotate-180' : ''}`, fill: "none", stroke: "currentColor", viewBox: "0 0 24 24", children: (0, jsx_runtime_1.jsx)("path", { strokeLinecap: "round", strokeLinejoin: "round", strokeWidth: 2, d: "M19 9l-7 7-7-7" }) })] }), showServiceMenu && ((0, jsx_runtime_1.jsxs)("div", { className: "absolute right-0 top-full mt-2 w-80 bg-white rounded-lg shadow-xl border border-gray-200 z-[9999] py-2", children: [(0, jsx_runtime_1.jsxs)("div", { className: "px-4 py-2 border-b border-gray-100", children: [(0, jsx_runtime_1.jsx)("h3", { className: "text-sm font-semibold text-gray-700", children: "Switch Service" }), (0, jsx_runtime_1.jsx)("p", { className: "text-xs text-gray-500 mt-1", children: "Navigate between microservices" })] }), (0, jsx_runtime_1.jsx)("div", { className: "py-2", children: services.map((service) => {
                                                        const isCurrent = service.name === serviceName;
                                                        return ((0, jsx_runtime_1.jsxs)("a", { href: service.url, className: `flex items-start space-x-3 px-4 py-3 transition-colors ${isCurrent
                                                                ? 'bg-blue-50 border-l-4 border-blue-500'
                                                                : 'hover:bg-gray-50'}`, onClick: () => setShowServiceMenu(false), children: [(0, jsx_runtime_1.jsx)("span", { className: "text-xl mt-0.5", children: service.icon }), (0, jsx_runtime_1.jsxs)("div", { className: "flex-1 min-w-0", children: [(0, jsx_runtime_1.jsxs)("div", { className: `text-sm font-medium ${isCurrent ? 'text-blue-900' : 'text-gray-900'}`, children: [service.name, isCurrent && ((0, jsx_runtime_1.jsx)("span", { className: "ml-2 px-2 py-0.5 text-xs bg-white bg-opacity-50 rounded-full", children: "Current" }))] }), (0, jsx_runtime_1.jsx)("div", { className: `text-xs ${isCurrent ? 'text-blue-700' : 'text-gray-500'} mt-1`, children: service.description }), !isCurrent && ((0, jsx_runtime_1.jsxs)("div", { className: "text-xs text-gray-400 mt-1", children: ["Click to switch \u2192 ", service.url.replace('http://', '')] }))] }), !isCurrent && ((0, jsx_runtime_1.jsx)("div", { className: "flex-shrink-0 mt-1", children: (0, jsx_runtime_1.jsx)("svg", { className: "w-4 h-4 text-gray-400", fill: "none", stroke: "currentColor", viewBox: "0 0 24 24", children: (0, jsx_runtime_1.jsx)("path", { strokeLinecap: "round", strokeLinejoin: "round", strokeWidth: 2, d: "M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" }) }) }))] }, service.name));
                                                    }) }), (0, jsx_runtime_1.jsx)("div", { className: "border-t border-gray-100 px-4 py-2 mt-2", children: (0, jsx_runtime_1.jsxs)("div", { className: "text-xs text-gray-500 flex items-center space-x-1", children: [(0, jsx_runtime_1.jsx)("span", { children: "\uD83D\uDCA1" }), (0, jsx_runtime_1.jsx)("span", { children: "Each service runs independently with shared authentication" })] }) })] }))] }), status === 'loading' ? ((0, jsx_runtime_1.jsx)("div", { className: "animate-pulse flex space-x-4", children: (0, jsx_runtime_1.jsx)("div", { className: "rounded-full bg-gray-200 h-8 w-8" }) })) : session ? ((0, jsx_runtime_1.jsxs)("div", { className: "relative", ref: menuRef, children: [(0, jsx_runtime_1.jsxs)("button", { onClick: () => setShowUserMenu(!showUserMenu), className: "flex items-center space-x-3 text-gray-700 hover:text-gray-900 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 rounded-lg p-2", children: [(0, jsx_runtime_1.jsx)(ProfileAvatar, { src: session.user?.image, name: session.user?.name, email: session.user?.email, size: "sm" }), (0, jsx_runtime_1.jsxs)("div", { className: "hidden md:block text-left", children: [(0, jsx_runtime_1.jsx)("div", { className: "text-sm font-medium", children: session.user?.name }), (0, jsx_runtime_1.jsx)("div", { className: `text-xs ${getAccountStatus().color}`, children: getAccountStatus().text })] }), (0, jsx_runtime_1.jsx)("svg", { className: "w-4 h-4 text-gray-400", fill: "currentColor", viewBox: "0 0 20 20", children: (0, jsx_runtime_1.jsx)("path", { fillRule: "evenodd", d: "M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z", clipRule: "evenodd" }) })] }), showUserMenu && ((0, jsx_runtime_1.jsx)("div", { className: "absolute right-0 top-full mt-2 w-72 rounded-xl shadow-lg bg-white ring-1 ring-black ring-opacity-5 z-[9999]", children: (0, jsx_runtime_1.jsxs)("div", { className: "py-2", children: [(0, jsx_runtime_1.jsx)("div", { className: "px-4 py-3 border-b border-gray-100", children: (0, jsx_runtime_1.jsxs)("div", { className: "flex items-center space-x-3", children: [(0, jsx_runtime_1.jsx)(ProfileAvatar, { src: session.user?.image, name: session.user?.name, email: session.user?.email, size: "md" }), (0, jsx_runtime_1.jsxs)("div", { className: "flex-1", children: [(0, jsx_runtime_1.jsx)("div", { className: "font-medium text-gray-900", children: session.user?.name }), (0, jsx_runtime_1.jsx)("div", { className: "text-sm text-gray-500 truncate", children: session.user?.email }), (0, jsx_runtime_1.jsxs)("div", { className: "text-xs text-blue-600 mt-1 flex items-center space-x-1", children: [(0, jsx_runtime_1.jsx)("span", { children: "\uD83D\uDD17" }), (0, jsx_runtime_1.jsxs)("span", { children: [authMethodsCount, " sign-in method", authMethodsCount !== 1 ? 's' : ''] })] })] })] }) }), (0, jsx_runtime_1.jsxs)("div", { className: "py-1", children: [(0, jsx_runtime_1.jsxs)(link_1.default, { href: "/account/profile", className: "flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-100", onClick: () => setShowUserMenu(false), children: [(0, jsx_runtime_1.jsx)("span", { className: "mr-3", children: "\uD83D\uDC64" }), "Account Profile"] }), (0, jsx_runtime_1.jsxs)(link_1.default, { href: "/account/security", className: "flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-100", onClick: () => setShowUserMenu(false), children: [(0, jsx_runtime_1.jsx)("span", { className: "mr-3", children: "\uD83D\uDD10" }), "Security Settings"] }), (0, jsx_runtime_1.jsxs)(link_1.default, { href: "/account/activity", className: "flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-100", onClick: () => setShowUserMenu(false), children: [(0, jsx_runtime_1.jsx)("span", { className: "mr-3", children: "\uD83D\uDCCA" }), "Account Activity"] }), (0, jsx_runtime_1.jsx)("div", { className: "border-t border-gray-100 mt-1 pt-1", children: (0, jsx_runtime_1.jsxs)("button", { onClick: () => (0, react_1.signOut)({ callbackUrl: '/' }), className: "flex items-center w-full px-4 py-2 text-sm text-red-600 hover:bg-red-50", children: [(0, jsx_runtime_1.jsx)("span", { className: "mr-3", children: "\uD83D\uDEAA" }), "Sign Out"] }) })] })] }) }))] })) : ((0, jsx_runtime_1.jsxs)("div", { className: "flex items-center space-x-4", children: [(0, jsx_runtime_1.jsx)(link_1.default, { href: "http://localhost:3000/auth/sign-in", className: "text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors", children: "Sign In" }), (0, jsx_runtime_1.jsx)(link_1.default, { href: "http://localhost:3000/auth/sign-up", className: `${colorClasses[serviceColor]} hover:opacity-90 text-white px-4 py-2 rounded-md text-sm font-medium transition-colors`, children: "Sign Up" })] }))] })] }), showMobileMenu && ((0, jsx_runtime_1.jsx)("div", { className: "md:hidden", children: (0, jsx_runtime_1.jsxs)("div", { className: "px-2 pt-2 pb-3 space-y-1 sm:px-3 border-t border-gray-200", children: [(0, jsx_runtime_1.jsx)(link_1.default, { href: "/", className: "text-gray-700 hover:text-blue-600 block px-3 py-2 text-base font-medium", children: "Home" }), (0, jsx_runtime_1.jsx)(link_1.default, { href: "/about", className: "text-gray-700 hover:text-blue-600 block px-3 py-2 text-base font-medium", children: "About" }), session && ((0, jsx_runtime_1.jsxs)(jsx_runtime_1.Fragment, { children: [(0, jsx_runtime_1.jsx)(link_1.default, { href: "/dashboard", className: "text-gray-700 hover:text-blue-600 block px-3 py-2 text-base font-medium", children: "Dashboard" }), (0, jsx_runtime_1.jsx)(link_1.default, { href: "/account/profile", className: "text-gray-700 hover:text-blue-600 block px-3 py-2 text-base font-medium", children: "Profile" })] }))] }) }))] }) }));
}
//# sourceMappingURL=EnhancedNavigation.js.map