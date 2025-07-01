export declare function useAuth(): {
    session: import("next-auth").Session | null;
    status: "authenticated" | "loading" | "unauthenticated";
    isLoading: boolean;
    isAuthenticated: boolean;
    user: {
        name?: string | null;
        email?: string | null;
        image?: string | null;
    } | undefined;
    redirectToAuth: (callbackUrl?: string) => void;
    redirectToSignOut: () => void;
};
//# sourceMappingURL=useAuth.d.ts.map