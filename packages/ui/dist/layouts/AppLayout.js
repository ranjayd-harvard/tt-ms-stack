"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = AppLayout;
const jsx_runtime_1 = require("react/jsx-runtime");
const Navigation_1 = __importDefault(require("../components/Navigation"));
const Footer_1 = __importDefault(require("../components/Footer"));
function AppLayout({ children, serviceName, serviceColor = 'blue', showServiceSwitcher = true, customNavLinks = [], showFooter = true, companyName = "TT-MS-Stack", companyLogo, showServiceLinksInFooter = true }) {
    return ((0, jsx_runtime_1.jsxs)("div", { className: "min-h-screen bg-gray-50 flex flex-col", children: [(0, jsx_runtime_1.jsx)(Navigation_1.default, { serviceName: serviceName, serviceColor: serviceColor, showServiceSwitcher: showServiceSwitcher, customLinks: customNavLinks }), (0, jsx_runtime_1.jsx)("main", { className: "flex-1", children: (0, jsx_runtime_1.jsx)("div", { className: "max-w-7xl mx-auto py-6 sm:px-6 lg:px-8", children: children }) }), showFooter && ((0, jsx_runtime_1.jsx)(Footer_1.default, { serviceName: serviceName, showServiceLinks: showServiceLinksInFooter, companyName: companyName, companyLogo: companyLogo }))] }));
}
//# sourceMappingURL=AppLayout.js.map