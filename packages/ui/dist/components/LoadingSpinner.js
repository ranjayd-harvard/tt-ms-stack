"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.LoadingSpinner = LoadingSpinner;
const jsx_runtime_1 = require("react/jsx-runtime");
function LoadingSpinner({ size = 'md', color = 'blue' }) {
    const sizeClasses = {
        sm: 'h-4 w-4',
        md: 'h-8 w-8',
        lg: 'h-12 w-12'
    };
    const colorClasses = {
        blue: 'border-blue-600',
        green: 'border-green-600',
        purple: 'border-purple-600',
        red: 'border-red-600'
    };
    return ((0, jsx_runtime_1.jsx)("div", { className: `animate-spin rounded-full ${sizeClasses[size]} border-b-2 ${colorClasses[color]}` }));
}
//# sourceMappingURL=LoadingSpinner.js.map