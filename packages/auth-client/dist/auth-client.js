"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.AuthClient = void 0;
const jwt_1 = require("next-auth/jwt");
class AuthClient {
    constructor(authServiceUrl, secret) {
        this.authServiceUrl = authServiceUrl || process.env.AUTH_SERVICE_URL || 'http://localhost:3000';
        this.secret = secret || process.env.NEXTAUTH_SECRET || '';
    }
    async verifyTokenLocal(req) {
        try {
            const token = await (0, jwt_1.getToken)({
                req,
                secret: this.secret,
            });
            if (!token) {
                return { authenticated: false, error: 'No valid token' };
            }
            return {
                authenticated: true,
                user: {
                    id: token.id,
                    email: token.email,
                    name: token.name,
                    image: token.picture,
                    registerSource: token.registerSource,
                    groupId: token.groupId,
                    hasLinkedAccounts: token.hasLinkedAccounts,
                    services: token.services,
                }
            };
        }
        catch (error) {
            console.error('Local token verification failed:', error);
            return { authenticated: false, error: 'Token verification failed' };
        }
    }
}
exports.AuthClient = AuthClient;
//# sourceMappingURL=auth-client.js.map