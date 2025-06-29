export declare function useAuthRedirect(): {
    redirectToAuth: (callbackUrl?: string) => void;
    redirectToSignOut: () => void;
};
export declare function createAuthenticatedFetch(authServiceUrl?: string): (url: string, options?: RequestInit) => Promise<Response>;
export interface ServiceResponse<T = any> {
    success: boolean;
    data?: T;
    error?: string;
    timestamp: string;
}
export declare function createServiceResponse<T>(success: boolean, data?: T, error?: string): ServiceResponse<T>;
//# sourceMappingURL=utils.d.ts.map