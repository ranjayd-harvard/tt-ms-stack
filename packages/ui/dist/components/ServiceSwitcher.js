"use strict";
'use client';
Object.defineProperty(exports, "__esModule", { value: true });
exports.ServiceSwitcher = ServiceSwitcher;
const jsx_runtime_1 = require("react/jsx-runtime");
const react_1 = require("react");
function ServiceSwitcher({ currentService, currentColor = 'blue' }) {
    const [isOpen, setIsOpen] = (0, react_1.useState)(false);
    const dropdownRef = (0, react_1.useRef)(null);
    const services = [
        {
            name: 'Auth Service',
            url: process.env.NEXT_PUBLIC_AUTH_SERVICE_URL || 'http://localhost:3000',
            color: 'blue',
            description: 'Authentication & Authorization',
            icon: '🔐'
        },
        {
            name: 'User Service',
            url: process.env.NEXT_PUBLIC_USER_SERVICE_URL || 'http://localhost:3001',
            color: 'green',
            description: 'User Management',
            icon: '👥'
        },
        {
            name: 'Content Service',
            url: process.env.NEXT_PUBLIC_CONTENT_SERVICE_URL || 'http://localhost:3002',
            color: 'purple',
            description: 'Content Management',
            icon: '📝'
        }
    ];
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
        blue: 'bg-blue-100 text-blue-800 border-blue-200',
        green: 'bg-green-100 text-green-800 border-green-200',
        purple: 'bg-purple-100 text-purple-800 border-purple-200'
    };
    const currentServiceData = services.find(service => service.name === currentService);
    return ((0, jsx_runtime_1.jsxs)("div", { className: "relative", ref: dropdownRef, children: [(0, jsx_runtime_1.jsxs)("button", { onClick: () => setIsOpen(!isOpen), className: "flex items-center space-x-2 px-3 py-2 text-sm bg-gray-50 hover:bg-gray-100 border border-gray-200 rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-1", "aria-expanded": isOpen, "aria-haspopup": "true", children: [(0, jsx_runtime_1.jsx)("span", { className: "text-lg", children: currentServiceData?.icon || '⚙️' }), (0, jsx_runtime_1.jsx)("span", { className: "font-medium text-gray-700", children: currentService }), (0, jsx_runtime_1.jsx)("svg", { className: `w-4 h-4 text-gray-500 transition-transform duration-200 ${isOpen ? 'rotate-180' : ''}`, fill: "none", stroke: "currentColor", viewBox: "0 0 24 24", children: (0, jsx_runtime_1.jsx)("path", { strokeLinecap: "round", strokeLinejoin: "round", strokeWidth: 2, d: "M19 9l-7 7-7-7" }) })] }), isOpen && ((0, jsx_runtime_1.jsxs)("div", { className: "absolute right-0 top-full mt-2 w-80 bg-white rounded-lg shadow-xl border border-gray-200 z-[9999] py-2", children: [(0, jsx_runtime_1.jsxs)("div", { className: "px-4 py-2 border-b border-gray-100", children: [(0, jsx_runtime_1.jsx)("h3", { className: "text-sm font-semibold text-gray-700", children: "Switch Service" }), (0, jsx_runtime_1.jsx)("p", { className: "text-xs text-gray-500 mt-1", children: "Navigate between microservices" })] }), (0, jsx_runtime_1.jsx)("div", { className: "py-2", children: services.map((service) => {
                            const isCurrent = service.name === currentService;
                            return ((0, jsx_runtime_1.jsxs)("a", { href: service.url, className: `flex items-start space-x-3 px-4 py-3 transition-colors ${isCurrent
                                    ? `${colorClasses[service.color]} border-l-4 border-${service.color}-500`
                                    : 'hover:bg-gray-50'}`, onClick: () => setIsOpen(false), children: [(0, jsx_runtime_1.jsx)("span", { className: "text-xl mt-0.5", children: service.icon }), (0, jsx_runtime_1.jsxs)("div", { className: "flex-1 min-w-0", children: [(0, jsx_runtime_1.jsxs)("div", { className: `text-sm font-medium ${isCurrent ? `text-${service.color}-900` : 'text-gray-900'}`, children: [service.name, isCurrent && ((0, jsx_runtime_1.jsx)("span", { className: "ml-2 px-2 py-0.5 text-xs bg-white bg-opacity-50 rounded-full", children: "Current" }))] }), (0, jsx_runtime_1.jsx)("div", { className: `text-xs ${isCurrent ? `text-${service.color}-700` : 'text-gray-500'} mt-1`, children: service.description }), !isCurrent && ((0, jsx_runtime_1.jsxs)("div", { className: "text-xs text-gray-400 mt-1", children: ["Click to switch \u2192 ", service.url.replace('http://', '')] }))] }), !isCurrent && ((0, jsx_runtime_1.jsx)("div", { className: "flex-shrink-0 mt-1", children: (0, jsx_runtime_1.jsx)("svg", { className: "w-4 h-4 text-gray-400", fill: "none", stroke: "currentColor", viewBox: "0 0 24 24", children: (0, jsx_runtime_1.jsx)("path", { strokeLinecap: "round", strokeLinejoin: "round", strokeWidth: 2, d: "M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" }) }) }))] }, service.name));
                        }) }), (0, jsx_runtime_1.jsx)("div", { className: "border-t border-gray-100 px-4 py-2 mt-2", children: (0, jsx_runtime_1.jsxs)("div", { className: "text-xs text-gray-500 flex items-center space-x-1", children: [(0, jsx_runtime_1.jsx)("span", { children: "\uD83D\uDCA1" }), (0, jsx_runtime_1.jsx)("span", { children: "Each service runs independently with shared authentication" })] }) })] }))] }));
}
exports.default = ServiceSwitcher;
//# sourceMappingURL=ServiceSwitcher.js.map