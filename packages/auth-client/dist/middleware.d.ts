import { NextRequest } from 'next/server';
import type { AuthUser } from './auth-client';
export declare function withAuth(req: NextRequest, callback: (req: NextRequest, user: AuthUser) => Promise<Response>): Promise<Response>;
//# sourceMappingURL=middleware.d.ts.map