import { NextRequest } from 'next/server';
export interface AuthUser {
    id: string;
    email?: string | null;
    name?: string | null;
    image?: string | null;
    registerSource?: string;
    groupId?: string;
    hasLinkedAccounts?: boolean;
    services?: any;
}
export interface AuthResponse {
    authenticated: boolean;
    user?: AuthUser;
    error?: string;
}
export declare class AuthClient {
    private authServiceUrl;
    private secret;
    constructor(authServiceUrl?: string, secret?: string);
    verifyTokenLocal(req: NextRequest): Promise<AuthResponse>;
}
//# sourceMappingURL=auth-client.d.ts.map