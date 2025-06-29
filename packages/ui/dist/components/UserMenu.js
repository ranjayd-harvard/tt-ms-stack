"use strict";
'use client';
Object.defineProperty(exports, "__esModule", { value: true });
exports.UserMenu = UserMenu;
const jsx_runtime_1 = require("react/jsx-runtime");
const react_1 = require("react");
const react_2 = require("next-auth/react");
function UserMenu({ serviceColor = 'blue' }) {
    const { data: session } = (0, react_2.useSession)();
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
    if (!session)
        return null;
    const getInitials = () => {
        if (session.user?.name) {
            return session.user.name.split(' ').map(n => n[0]).join('').toUpperCase().slice(0, 2);
        }
        if (session.user?.email) {
            return session.user.email[0].toUpperCase();
        }
        return 'U';
    };
    const colorClasses = {
        blue: 'bg-blue-600',
        green: 'bg-green-600',
        purple: 'bg-purple-600',
        red: 'bg-red-600'
    };
    return ((0, jsx_runtime_1.jsxs)("div", { className: "relative", ref: dropdownRef, children: [(0, jsx_runtime_1.jsxs)("button", { onClick: () => setIsOpen(!isOpen), className: "flex items-center space-x-2 p-1 rounded-lg hover:bg-gray-100 transition-colors focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-1", "aria-expanded": isOpen, "aria-haspopup": "true", children: [session.user?.image ? ((0, jsx_runtime_1.jsx)("img", { className: "h-8 w-8 rounded-full object-cover border-2 border-gray-200", src: session.user.image, alt: session.user.name || 'User avatar' })) : ((0, jsx_runtime_1.jsx)("div", { className: `h-8 w-8 ${colorClasses[serviceColor]} rounded-full flex items-center justify-center text-white text-sm font-medium border-2 border-white shadow-sm`, children: getInitials() })), (0, jsx_runtime_1.jsx)("div", { className: "hidden md:block text-left", children: (0, jsx_runtime_1.jsx)("div", { className: "text-sm font-medium text-gray-700 truncate max-w-32", children: session.user?.name || session.user?.email }) }), (0, jsx_runtime_1.jsx)("svg", { className: `w-4 h-4 text-gray-500 transition-transform duration-200 ${isOpen ? 'rotate-180' : ''}`, fill: "none", stroke: "currentColor", viewBox: "0 0 24 24", children: (0, jsx_runtime_1.jsx)("path", { strokeLinecap: "round", strokeLinejoin: "round", strokeWidth: 2, d: "M19 9l-7 7-7-7" }) })] }), isOpen && ((0, jsx_runtime_1.jsxs)("div", { className: "absolute right-0 top-full mt-2 w-72 bg-white rounded-lg shadow-xl border border-gray-200 z-[9999] py-2", children: [(0, jsx_runtime_1.jsx)("div", { className: "px-4 py-3 border-b border-gray-100", children: (0, jsx_runtime_1.jsxs)("div", { className: "flex items-center space-x-3", children: [session.user?.image ? ((0, jsx_runtime_1.jsx)("img", { className: "h-10 w-10 rounded-full object-cover border-2 border-gray-200", src: session.user.image, alt: session.user.name || 'User avatar' })) : ((0, jsx_runtime_1.jsx)("div", { className: `h-10 w-10 ${colorClasses[serviceColor]} rounded-full flex items-center justify-center text-white font-medium border-2 border-white shadow-sm`, children: getInitials() })), (0, jsx_runtime_1.jsxs)("div", { className: "flex-1 min-w-0", children: [(0, jsx_runtime_1.jsx)("div", { className: "font-medium text-gray-900 truncate", children: session.user?.name || 'User' }), (0, jsx_runtime_1.jsx)("div", { className: "text-sm text-gray-500 truncate", children: session.user?.email })] })] }) }), (0, jsx_runtime_1.jsxs)("div", { className: "py-1", children: [(0, jsx_runtime_1.jsxs)("a", { href: "/account/profile", className: "flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors", onClick: () => setIsOpen(false), children: [(0, jsx_runtime_1.jsx)("span", { className: "mr-3", children: "\uD83D\uDC64" }), "Account Profile"] }), (0, jsx_runtime_1.jsxs)("a", { href: "/account/security", className: "flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors", onClick: () => setIsOpen(false), children: [(0, jsx_runtime_1.jsx)("span", { className: "mr-3", children: "\uD83D\uDD10" }), "Security Settings"] }), (0, jsx_runtime_1.jsxs)("a", { href: "/account/activity", className: "flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors", onClick: () => setIsOpen(false), children: [(0, jsx_runtime_1.jsx)("span", { className: "mr-3", children: "\uD83D\uDCCA" }), "Account Activity"] }), (0, jsx_runtime_1.jsxs)("a", { href: "/help", className: "flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors", onClick: () => setIsOpen(false), children: [(0, jsx_runtime_1.jsx)("span", { className: "mr-3", children: "\u2753" }), "Help & Support"] }), (0, jsx_runtime_1.jsx)("div", { className: "border-t border-gray-100 mt-1 pt-1", children: (0, jsx_runtime_1.jsxs)("button", { onClick: () => {
                                        setIsOpen(false);
                                        (0, react_2.signOut)({ callbackUrl: '/' });
                                    }, className: "flex items-center w-full px-4 py-2 text-sm text-red-600 hover:bg-red-50 transition-colors", children: [(0, jsx_runtime_1.jsx)("span", { className: "mr-3", children: "\uD83D\uDEAA" }), "Sign Out"] }) })] })] }))] }));
}
exports.default = UserMenu;
//# sourceMappingURL=UserMenu.js.map