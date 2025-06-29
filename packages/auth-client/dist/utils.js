"use strict";
// Utility functions for client-side authentication
Object.defineProperty(exports, "__esModule", { value: true });
exports.useAuthRedirect = useAuthRedirect;
exports.createAuthenticatedFetch = createAuthenticatedFetch;
exports.createServiceResponse = createServiceResponse;
function useAuthRedirect() {
    const authServiceUrl = process.env.NEXT_PUBLIC_AUTH_SERVICE_URL || 'http://localhost:3000';
    const redirectToAuth = (callbackUrl) => {
        // Check if we're in a browser environment
        if (typeof window !== 'undefined') {
            const callback = callbackUrl || window.location.href;
            window.location.href = `${authServiceUrl}/auth/signin?callbackUrl=${encodeURIComponent(callback)}`;
        }
        else {
            console.warn('redirectToAuth called in server environment');
        }
    };
    const redirectToSignOut = () => {
        // Check if we're in a browser environment
        if (typeof window !== 'undefined') {
            window.location.href = `${authServiceUrl}/auth/signout`;
        }
        else {
            console.warn('redirectToSignOut called in server environment');
        }
    };
    return {
        redirectToAuth,
        redirectToSignOut,
    };
}
function createAuthenticatedFetch(authServiceUrl) {
    return async (url, options = {}) => {
        const response = await fetch(url, {
            ...options,
            credentials: 'include', // Include cookies
            headers: {
                'Content-Type': 'application/json',
                ...options.headers,
            },
        });
        if (response.status === 401 && typeof window !== 'undefined') {
            // Only redirect in browser environment
            const currentUrl = window.location.href;
            window.location.href = `${authServiceUrl || 'http://localhost:3000'}/auth/signin?callbackUrl=${encodeURIComponent(currentUrl)}`;
        }
        return response;
    };
}
function createServiceResponse(success, data, error) {
    return {
        success,
        data,
        error,
        timestamp: new Date().toISOString(),
    };
}
//# sourceMappingURL=utils.js.map