"use strict";
// packages/ui/src/components/Navigation.tsx
'use client';
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = Navigation;
const jsx_runtime_1 = require("react/jsx-runtime");
const react_1 = require("react");
// Enhanced ProfileAvatar component with proper image handling
function ProfileAvatar({ src, name, email, size = 'sm', avatarType = 'oauth' // Add avatarType support
 }) {
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
        return 'U';
    };
    // Enhanced image handling - check if image is available and valid
    const [imageError, setImageError] = (0, react_1.useState)(false);
    const [imageLoaded, setImageLoaded] = (0, react_1.useState)(false);
    // Reset error state when src changes
    (0, react_1.useEffect)(() => {
        setImageError(false);
        setImageLoaded(false);
    }, [src]);
    const shouldShowImage = src && !imageError && (avatarType === 'oauth' || avatarType === 'uploaded');
    return ((0, jsx_runtime_1.jsxs)("div", { className: "relative", children: [shouldShowImage ? ((0, jsx_runtime_1.jsx)("img", { className: `${sizeClasses[size]} rounded-full object-cover border-2 border-gray-200 shadow-sm`, src: src, alt: name || email || 'User avatar', onError: () => {
                    console.log('Avatar image failed to load:', src);
                    setImageError(true);
                }, onLoad: () => {
                    console.log('Avatar image loaded successfully:', src);
                    setImageLoaded(true);
                }, style: { display: imageError ? 'none' : 'block' } })) : ((0, jsx_runtime_1.jsx)("div", { className: `${sizeClasses[size]} rounded-full bg-gradient-to-br from-blue-500 to-blue-600 flex items-center justify-center text-white font-medium border-2 border-white shadow-sm`, children: getInitials() })), process.env.NODE_ENV === 'development' && ((0, jsx_runtime_1.jsx)("div", { className: "absolute -bottom-1 -right-1 text-xs", children: shouldShowImage && !imageError ? '🖼️' : '👤' }))] }));
}
const services = [
    {
        name: 'Auth Service',
        url: 'http://localhost:3000',
        color: '#2563eb',
        icon: 'A',
        description: 'Authentication & Authorization'
    },
    {
        name: 'User Service',
        url: 'http://localhost:3001',
        color: '#059669',
        icon: 'U',
        description: 'User Management'
    },
    {
        name: 'Content Service',
        url: 'http://localhost:3002',
        color: '#7c3aed',
        icon: 'C',
        description: 'Content Management'
    }
];
function Navigation({ serviceName, serviceColor = 'blue', showServiceSwitcher = true, customLinks = [] }) {
    const [showServiceMenu, setShowServiceMenu] = (0, react_1.useState)(false);
    const [showUserMenu, setShowUserMenu] = (0, react_1.useState)(false);
    const serviceMenuRef = (0, react_1.useRef)(null);
    const userMenuRef = (0, react_1.useRef)(null);
    // Enhanced session data - using the same structure as Auth Service
    const session = {
        user: {
            name: 'Ranjay Kumar',
            email: 'ranjay@example.com',
            // Using the same image that works in the dropdown
            image: null, // Temporarily set to null to force initials
            avatarType: 'default', // Can be 'default', 'oauth', or 'uploaded'
            provider: 'credentials'
        }
    };
    const authMethodsCount = 3;
    // Close dropdowns when clicking outside
    (0, react_1.useEffect)(() => {
        function handleClickOutside(event) {
            if (serviceMenuRef.current && !serviceMenuRef.current.contains(event.target)) {
                setShowServiceMenu(false);
            }
            if (userMenuRef.current && !userMenuRef.current.contains(event.target)) {
                setShowUserMenu(false);
            }
        }
        document.addEventListener('mousedown', handleClickOutside);
        return () => document.removeEventListener('mousedown', handleClickOutside);
    }, []);
    const currentService = services.find(s => s.name === serviceName);
    const getAccountStatus = () => {
        if (authMethodsCount > 1)
            return { text: `${authMethodsCount} linked methods`, color: '#059669' };
        if (authMethodsCount === 1)
            return { text: 'Single method', color: '#eab308' };
        return { text: 'No methods', color: '#dc2626' };
    };
    // Dropdown styles
    const dropdownStyle = {
        position: 'absolute',
        top: '100%',
        right: 0,
        marginTop: '8px',
        zIndex: 50,
        backgroundColor: 'white',
        borderRadius: '12px',
        boxShadow: '0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04)',
        border: '1px solid #e5e7eb',
        minWidth: '320px'
    };
    const userDropdownStyle = {
        position: 'absolute',
        top: '100%',
        right: 0,
        marginTop: '8px',
        zIndex: 50,
        backgroundColor: 'white',
        borderRadius: '12px',
        boxShadow: '0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04)',
        border: '1px solid #e5e7eb',
        minWidth: '288px'
    };
    // Debug logging
    (0, react_1.useEffect)(() => {
        console.log('Navigation Debug:', {
            sessionImage: session?.user?.image,
            avatarType: session?.user?.avatarType,
            userName: session?.user?.name
        });
    }, [session]);
    return ((0, jsx_runtime_1.jsx)("nav", { style: { backgroundColor: 'white', boxShadow: '0 1px 3px 0 rgba(0, 0, 0, 0.1)', borderBottom: '1px solid #e5e7eb', position: 'relative' }, children: (0, jsx_runtime_1.jsx)("div", { style: { maxWidth: '1280px', margin: '0 auto', padding: '0 1rem' }, children: (0, jsx_runtime_1.jsxs)("div", { style: { display: 'flex', justifyContent: 'space-between', height: '4rem' }, children: [(0, jsx_runtime_1.jsxs)("div", { style: { display: 'flex', alignItems: 'center' }, children: [(0, jsx_runtime_1.jsxs)("a", { href: "/", style: { display: 'flex', alignItems: 'center', textDecoration: 'none', marginRight: '2rem' }, children: [(0, jsx_runtime_1.jsx)("div", { style: {
                                            width: '32px',
                                            height: '32px',
                                            backgroundColor: currentService?.color || '#6b7280',
                                            borderRadius: '8px',
                                            display: 'flex',
                                            alignItems: 'center',
                                            justifyContent: 'center',
                                            color: 'white',
                                            fontWeight: 'bold',
                                            fontSize: '14px',
                                            marginRight: '8px'
                                        }, children: currentService?.icon }), (0, jsx_runtime_1.jsx)("span", { style: { fontSize: '1.25rem', fontWeight: '600', color: '#111827' }, children: serviceName })] }), (0, jsx_runtime_1.jsx)("div", { style: { display: 'flex', gap: '2rem', alignItems: 'center' }, children: customLinks.map((link, index) => ((0, jsx_runtime_1.jsx)("a", { href: link.href, style: {
                                        color: '#374151',
                                        textDecoration: 'none',
                                        padding: '8px 12px',
                                        borderRadius: '6px',
                                        fontSize: '14px',
                                        fontWeight: '500',
                                        transition: 'color 0.2s'
                                    }, onMouseEnter: (e) => e.currentTarget.style.color = '#2563eb', onMouseLeave: (e) => e.currentTarget.style.color = '#374151', ...(link.external && { target: "_blank", rel: "noopener noreferrer" }), children: link.label }, index))) })] }), (0, jsx_runtime_1.jsxs)("div", { style: { display: 'flex', alignItems: 'center', gap: '1rem' }, children: [showServiceSwitcher && ((0, jsx_runtime_1.jsxs)("div", { style: { position: 'relative' }, ref: serviceMenuRef, children: [(0, jsx_runtime_1.jsxs)("button", { onClick: () => setShowServiceMenu(!showServiceMenu), style: {
                                            display: 'flex',
                                            alignItems: 'center',
                                            gap: '8px',
                                            padding: '8px 12px',
                                            fontSize: '14px',
                                            border: '1px solid #d1d5db',
                                            borderRadius: '8px',
                                            backgroundColor: showServiceMenu ? '#f9fafb' : 'white',
                                            cursor: 'pointer',
                                            transition: 'background-color 0.2s'
                                        }, onMouseEnter: (e) => {
                                            if (!showServiceMenu)
                                                e.currentTarget.style.backgroundColor = '#f9fafb';
                                        }, onMouseLeave: (e) => {
                                            if (!showServiceMenu)
                                                e.currentTarget.style.backgroundColor = 'white';
                                        }, children: [(0, jsx_runtime_1.jsx)("div", { style: {
                                                    width: '24px',
                                                    height: '24px',
                                                    backgroundColor: currentService?.color || '#6b7280',
                                                    borderRadius: '4px',
                                                    display: 'flex',
                                                    alignItems: 'center',
                                                    justifyContent: 'center',
                                                    color: 'white',
                                                    fontSize: '12px',
                                                    fontWeight: 'bold'
                                                }, children: currentService?.icon }), (0, jsx_runtime_1.jsx)("span", { style: { fontSize: '14px', fontWeight: '500', color: '#111827' }, children: serviceName }), (0, jsx_runtime_1.jsx)("svg", { style: {
                                                    width: '16px',
                                                    height: '16px',
                                                    color: '#6b7280',
                                                    transform: showServiceMenu ? 'rotate(180deg)' : 'rotate(0deg)',
                                                    transition: 'transform 0.2s'
                                                }, fill: "none", stroke: "currentColor", viewBox: "0 0 24 24", children: (0, jsx_runtime_1.jsx)("path", { strokeLinecap: "round", strokeLinejoin: "round", strokeWidth: 2, d: "M19 9l-7 7-7-7" }) })] }), showServiceMenu && ((0, jsx_runtime_1.jsxs)("div", { style: dropdownStyle, children: [(0, jsx_runtime_1.jsxs)("div", { style: { padding: '16px', borderBottom: '1px solid #f3f4f6' }, children: [(0, jsx_runtime_1.jsx)("h3", { style: { fontSize: '14px', fontWeight: '600', color: '#374151', margin: 0 }, children: "Switch Service" }), (0, jsx_runtime_1.jsx)("p", { style: { fontSize: '12px', color: '#6b7280', margin: '4px 0 0 0' }, children: "Navigate between microservices" })] }), (0, jsx_runtime_1.jsx)("div", { style: { padding: '8px 0' }, children: services.map((service) => {
                                                    const isCurrent = service.name === serviceName;
                                                    return ((0, jsx_runtime_1.jsxs)("a", { href: service.url, style: {
                                                            display: 'flex',
                                                            alignItems: 'center',
                                                            gap: '12px',
                                                            padding: '12px 16px',
                                                            textDecoration: 'none',
                                                            backgroundColor: isCurrent ? '#eff6ff' : 'transparent',
                                                            borderLeft: isCurrent ? '4px solid #3b82f6' : '4px solid transparent',
                                                            transition: 'background-color 0.2s'
                                                        }, onClick: () => setShowServiceMenu(false), onMouseEnter: (e) => {
                                                            if (!isCurrent)
                                                                e.currentTarget.style.backgroundColor = '#f9fafb';
                                                        }, onMouseLeave: (e) => {
                                                            if (!isCurrent)
                                                                e.currentTarget.style.backgroundColor = 'transparent';
                                                        }, children: [(0, jsx_runtime_1.jsx)("div", { style: {
                                                                    width: '24px',
                                                                    height: '24px',
                                                                    backgroundColor: service.color,
                                                                    borderRadius: '4px',
                                                                    display: 'flex',
                                                                    alignItems: 'center',
                                                                    justifyContent: 'center',
                                                                    color: 'white',
                                                                    fontSize: '12px',
                                                                    fontWeight: 'bold'
                                                                }, children: service.icon }), (0, jsx_runtime_1.jsxs)("div", { style: { flex: 1 }, children: [(0, jsx_runtime_1.jsxs)("div", { style: { fontSize: '14px', fontWeight: '500', color: isCurrent ? '#1d4ed8' : '#111827', margin: 0 }, children: [service.name, isCurrent && (0, jsx_runtime_1.jsx)("span", { style: { marginLeft: '8px', fontSize: '12px', color: '#3b82f6', fontWeight: '500' }, children: "Current" })] }), (0, jsx_runtime_1.jsx)("div", { style: { fontSize: '12px', color: '#6b7280', margin: '2px 0 0 0' }, children: service.description })] })] }, service.name));
                                                }) }), (0, jsx_runtime_1.jsx)("div", { style: { borderTop: '1px solid #f3f4f6', padding: '8px 16px' }, children: (0, jsx_runtime_1.jsx)("div", { style: { fontSize: '12px', color: '#6b7280' }, children: "Each service runs independently with shared authentication" }) })] }))] })), (0, jsx_runtime_1.jsxs)("div", { style: { position: 'relative' }, ref: userMenuRef, children: [(0, jsx_runtime_1.jsxs)("button", { onClick: () => setShowUserMenu(!showUserMenu), style: {
                                            display: 'flex',
                                            alignItems: 'center',
                                            gap: '12px',
                                            backgroundColor: 'transparent',
                                            border: 'none',
                                            cursor: 'pointer',
                                            padding: '8px',
                                            borderRadius: '8px',
                                            transition: 'background-color 0.2s'
                                        }, onMouseEnter: (e) => e.currentTarget.style.backgroundColor = '#f9fafb', onMouseLeave: (e) => e.currentTarget.style.backgroundColor = 'transparent', children: [(0, jsx_runtime_1.jsx)(ProfileAvatar, { src: session?.user?.image, name: session?.user?.name, email: session?.user?.email, size: "sm", avatarType: session?.user?.avatarType }), (0, jsx_runtime_1.jsxs)("div", { style: { display: 'flex', flexDirection: 'column', alignItems: 'flex-start', textAlign: 'left' }, children: [(0, jsx_runtime_1.jsx)("div", { style: { fontSize: '14px', fontWeight: '500', color: '#111827', margin: 0 }, children: session?.user?.name }), (0, jsx_runtime_1.jsx)("div", { style: { fontSize: '12px', color: getAccountStatus().color, margin: 0 }, children: getAccountStatus().text })] }), (0, jsx_runtime_1.jsx)("svg", { style: {
                                                    width: '16px',
                                                    height: '16px',
                                                    color: '#9ca3af',
                                                    transform: showUserMenu ? 'rotate(180deg)' : 'rotate(0deg)',
                                                    transition: 'transform 0.2s'
                                                }, fill: "none", stroke: "currentColor", viewBox: "0 0 24 24", children: (0, jsx_runtime_1.jsx)("path", { strokeLinecap: "round", strokeLinejoin: "round", strokeWidth: 2, d: "M19 9l-7 7-7-7" }) })] }), showUserMenu && ((0, jsx_runtime_1.jsxs)("div", { style: userDropdownStyle, children: [(0, jsx_runtime_1.jsxs)("div", { style: { padding: '16px', borderBottom: '1px solid #f3f4f6' }, children: [(0, jsx_runtime_1.jsxs)("div", { style: { display: 'flex', alignItems: 'center', gap: '12px' }, children: [(0, jsx_runtime_1.jsx)(ProfileAvatar, { src: session?.user?.image, name: session?.user?.name, email: session?.user?.email, size: "md", avatarType: session?.user?.avatarType }), (0, jsx_runtime_1.jsxs)("div", { style: { flex: 1 }, children: [(0, jsx_runtime_1.jsx)("div", { style: { fontSize: '14px', fontWeight: '600', color: '#111827', margin: 0 }, children: session?.user?.name }), (0, jsx_runtime_1.jsx)("div", { style: { fontSize: '12px', color: '#6b7280', margin: '2px 0 0 0', wordBreak: 'break-all' }, children: session?.user?.email }), (0, jsx_runtime_1.jsxs)("div", { style: { fontSize: '11px', color: '#3b82f6', margin: '4px 0 0 0', display: 'flex', alignItems: 'center', gap: '4px' }, children: [(0, jsx_runtime_1.jsx)("span", { children: "\uD83D\uDD17" }), (0, jsx_runtime_1.jsx)("span", { children: getAccountStatus().text })] })] })] }), process.env.NODE_ENV === 'development' && ((0, jsx_runtime_1.jsxs)("div", { style: { fontSize: '10px', color: '#6b7280', marginTop: '8px', padding: '4px', backgroundColor: '#f9fafb', borderRadius: '4px' }, children: ["Debug: avatarType=", session?.user?.avatarType, ", hasImage=", !!session?.user?.image] }))] }), (0, jsx_runtime_1.jsxs)("div", { style: { padding: '8px 0' }, children: [(0, jsx_runtime_1.jsxs)("a", { href: "/account/profile", style: {
                                                            display: 'flex',
                                                            alignItems: 'center',
                                                            padding: '12px 16px',
                                                            fontSize: '14px',
                                                            color: '#374151',
                                                            textDecoration: 'none',
                                                            transition: 'background-color 0.2s'
                                                        }, onMouseEnter: (e) => e.currentTarget.style.backgroundColor = '#f9fafb', onMouseLeave: (e) => e.currentTarget.style.backgroundColor = 'transparent', children: [(0, jsx_runtime_1.jsx)("span", { style: { marginRight: '12px', fontSize: '16px' }, children: "\uD83D\uDC64" }), (0, jsx_runtime_1.jsxs)("div", { children: [(0, jsx_runtime_1.jsx)("div", { style: { fontWeight: '500' }, children: "Account Profile" }), (0, jsx_runtime_1.jsx)("div", { style: { fontSize: '12px', color: '#6b7280' }, children: "Manage your personal information" })] })] }), (0, jsx_runtime_1.jsxs)("a", { href: "/account/security", style: {
                                                            display: 'flex',
                                                            alignItems: 'center',
                                                            padding: '12px 16px',
                                                            fontSize: '14px',
                                                            color: '#374151',
                                                            textDecoration: 'none',
                                                            transition: 'background-color 0.2s'
                                                        }, onMouseEnter: (e) => e.currentTarget.style.backgroundColor = '#f9fafb', onMouseLeave: (e) => e.currentTarget.style.backgroundColor = 'transparent', children: [(0, jsx_runtime_1.jsx)("span", { style: { marginRight: '12px', fontSize: '16px' }, children: "\uD83D\uDD10" }), (0, jsx_runtime_1.jsxs)("div", { children: [(0, jsx_runtime_1.jsx)("div", { style: { fontWeight: '500' }, children: "Security Settings" }), (0, jsx_runtime_1.jsx)("div", { style: { fontSize: '12px', color: '#6b7280' }, children: "Password, 2FA, and sign-in methods" })] })] }), (0, jsx_runtime_1.jsxs)("a", { href: "/account/activity", style: {
                                                            display: 'flex',
                                                            alignItems: 'center',
                                                            padding: '12px 16px',
                                                            fontSize: '14px',
                                                            color: '#374151',
                                                            textDecoration: 'none',
                                                            transition: 'background-color 0.2s'
                                                        }, onMouseEnter: (e) => e.currentTarget.style.backgroundColor = '#f9fafb', onMouseLeave: (e) => e.currentTarget.style.backgroundColor = 'transparent', children: [(0, jsx_runtime_1.jsx)("span", { style: { marginRight: '12px', fontSize: '16px' }, children: "\uD83D\uDCCA" }), (0, jsx_runtime_1.jsxs)("div", { children: [(0, jsx_runtime_1.jsx)("div", { style: { fontWeight: '500' }, children: "Account Activity" }), (0, jsx_runtime_1.jsx)("div", { style: { fontSize: '12px', color: '#6b7280' }, children: "View recent account activity" })] })] }), (0, jsx_runtime_1.jsx)("div", { style: { height: '1px', backgroundColor: '#f3f4f6', margin: '8px 0' } }), (0, jsx_runtime_1.jsxs)("a", { href: "/help", style: {
                                                            display: 'flex',
                                                            alignItems: 'center',
                                                            padding: '12px 16px',
                                                            fontSize: '14px',
                                                            color: '#374151',
                                                            textDecoration: 'none',
                                                            transition: 'background-color 0.2s'
                                                        }, onMouseEnter: (e) => e.currentTarget.style.backgroundColor = '#f9fafb', onMouseLeave: (e) => e.currentTarget.style.backgroundColor = 'transparent', children: [(0, jsx_runtime_1.jsx)("span", { style: { marginRight: '12px', fontSize: '16px' }, children: "\u2753" }), (0, jsx_runtime_1.jsxs)("div", { children: [(0, jsx_runtime_1.jsx)("div", { style: { fontWeight: '500' }, children: "Help & Support" }), (0, jsx_runtime_1.jsx)("div", { style: { fontSize: '12px', color: '#6b7280' }, children: "Get help and contact support" })] })] }), (0, jsx_runtime_1.jsxs)("button", { style: {
                                                            display: 'flex',
                                                            alignItems: 'center',
                                                            width: '100%',
                                                            padding: '12px 16px',
                                                            fontSize: '14px',
                                                            color: '#dc2626',
                                                            backgroundColor: 'transparent',
                                                            border: 'none',
                                                            textAlign: 'left',
                                                            cursor: 'pointer',
                                                            transition: 'background-color 0.2s'
                                                        }, onMouseEnter: (e) => e.currentTarget.style.backgroundColor = '#fef2f2', onMouseLeave: (e) => e.currentTarget.style.backgroundColor = 'transparent', children: [(0, jsx_runtime_1.jsx)("span", { style: { marginRight: '12px', fontSize: '16px' }, children: "\uD83D\uDEAA" }), (0, jsx_runtime_1.jsxs)("div", { children: [(0, jsx_runtime_1.jsx)("div", { style: { fontWeight: '500' }, children: "Sign Out" }), (0, jsx_runtime_1.jsx)("div", { style: { fontSize: '12px', color: '#9ca3af' }, children: "Sign out of your account" })] })] })] })] }))] })] })] }) }) }));
}
//# sourceMappingURL=Navigation.js.map