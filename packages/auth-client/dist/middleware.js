"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.withAuth = withAuth;
const auth_client_1 = require("./auth-client");
async function withAuth(req, callback) {
    const authClient = new auth_client_1.AuthClient();
    try {
        const authResult = await authClient.verifyTokenLocal(req);
        if (!authResult.authenticated) {
            return new Response(JSON.stringify({ error: 'Authentication required' }), {
                status: 401,
                headers: { 'Content-Type': 'application/json' }
            });
        }
        return await callback(req, authResult.user);
    }
    catch (error) {
        console.error('Auth middleware error:', error);
        return new Response(JSON.stringify({ error: 'Authentication failed' }), {
            status: 401,
            headers: { 'Content-Type': 'application/json' }
        });
    }
}
//# sourceMappingURL=middleware.js.map