"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ProfileAvatar = ProfileAvatar;
const jsx_runtime_1 = require("react/jsx-runtime");
function ProfileAvatar({ src, name, email, size = 'md', showBadge = false }) {
    const sizeClasses = {
        sm: 'h-8 w-8 text-sm',
        md: 'h-10 w-10 text-base',
        lg: 'h-12 w-12 text-lg'
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
    return ((0, jsx_runtime_1.jsxs)("div", { className: "relative", children: [src ? ((0, jsx_runtime_1.jsx)("img", { className: `${sizeClasses[size]} rounded-full object-cover`, src: src, alt: name || email || 'User avatar' })) : ((0, jsx_runtime_1.jsx)("div", { className: `${sizeClasses[size]} rounded-full bg-gray-500 flex items-center justify-center text-white font-medium`, children: getInitials() })), showBadge && ((0, jsx_runtime_1.jsx)("div", { className: "absolute -bottom-1 -right-1 h-3 w-3 bg-green-400 border-2 border-white rounded-full" }))] }));
}
//# sourceMappingURL=ProfileAvatar.js.map