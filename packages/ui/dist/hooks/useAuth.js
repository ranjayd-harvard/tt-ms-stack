"use strict";
// packages/ui/src/hooks/useAuth.ts
'use client';
Object.defineProperty(exports, "__esModule", { value: true });
exports.useAuth = useAuth;
const react_1 = require("next-auth/react");
function useAuth() {
    const { data: session, status } = (0, react_1.useSession)();
    const redirectToAuth = (callbackUrl) => {
        const authServiceUrl = process.env.NEXT_PUBLIC_AUTH_SERVICE_URL || 'http://localhost:3000';
        const callback = callbackUrl || window.location.href;
        window.location.href = `${authServiceUrl}/auth/sign-in?callbackUrl=${encodeURIComponent(callback)}`;
    };
    const redirectToSignOut = () => {
        const authServiceUrl = process.env.NEXT_PUBLIC_AUTH_SERVICE_URL || 'http://localhost:3000';
        window.location.href = `${authServiceUrl}/auth/sign-out`;
    };
    return {
        session,
        status,
        isLoading: status === 'loading',
        isAuthenticated: status === 'authenticated',
        user: session?.user,
        redirectToAuth,
        redirectToSignOut
    };
}
//# sourceMappingURL=useAuth.js.map