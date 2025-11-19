import { NextRequest } from 'next/server';
import { GET } from '../route';
import { prismaMock, resetPrismaMock } from '@/lib/test-utils/prisma-mock';
import { createMockUser } from '@/lib/test-utils/factories';
import {
    createAuthRequest,
    mockAuthUser,
    clearAuthMock,
    createMockAuthUser,
} from '@/lib/test-utils/auth-mock';

describe('API /api/notifications', () => {
    beforeEach(() => {
        resetPrismaMock();
        clearAuthMock();
    });

    describe('GET /api/notifications', () => {
        it('should return notifications list', async () => {
            const authUser = createMockAuthUser({ id: 'usr_123' });
            mockAuthUser(authUser);

            const mockNotifications = [
                {
                    id: 'notif_1',
                    userId: 'usr_123',
                    type: 'LIKE',
                    actorId: 'usr_456',
                    postId: 'post_1',
                    isRead: false,
                    createdAt: new Date(),
                    actor: createMockUser({ id: 'usr_456' }),
                    post: { id: 'post_1', content: 'Test' },
                },
            ];

            prismaMock.notification.findMany.mockResolvedValue(mockNotifications as any);

            const request = createAuthRequest('http://localhost:3000/api/notifications');
            const response = await GET(request);
            const data = await response.json();

            expect(response.status).toBe(200);
            expect(data.data).toHaveLength(1);
        });
    });
});
