import { NextRequest } from 'next/server';
import { DELETE } from '../route';
import { prismaMock, resetPrismaMock } from '@/lib/test-utils/prisma-mock';
import { createMockComment, createMockUser } from '@/lib/test-utils/factories';
import {
    createAuthRequest,
    mockAuthUser,
    clearAuthMock,
    createMockAuthUser,
} from '@/lib/test-utils/auth-mock';

describe('API /api/comments/[id]', () => {
    beforeEach(() => {
        resetPrismaMock();
        clearAuthMock();
    });

    describe('DELETE /api/comments/[id]', () => {
        it('should delete comment', async () => {
            const authUser = createMockAuthUser({ id: 'usr_123' });
            mockAuthUser(authUser);

            const mockComment = createMockComment({
                id: 'cmt_1',
                userId: 'usr_123',
                postId: 'post_1',
            });

            prismaMock.comment.findUnique.mockResolvedValue(mockComment);
            prismaMock.comment.delete.mockResolvedValue(mockComment);

            const request = createAuthRequest('http://localhost:3000/api/comments/cmt_1', {
                method: 'DELETE',
            });
            const params = Promise.resolve({ id: 'cmt_1' });
            const response = await DELETE(request, { params });

            expect(response.status).toBe(204);
        });

        it('should return 403 if user is not owner', async () => {
            const authUser = createMockAuthUser({ id: 'usr_456' });
            mockAuthUser(authUser);

            const mockComment = createMockComment({
                id: 'cmt_1',
                userId: 'usr_123', // Different user
            });

            prismaMock.comment.findUnique.mockResolvedValue(mockComment);

            const request = createAuthRequest('http://localhost:3000/api/comments/cmt_1', {
                method: 'DELETE',
            });
            const params = Promise.resolve({ id: 'cmt_1' });
            const response = await DELETE(request, { params });
            const data = await response.json();

            expect(response.status).toBe(403);
            expect(data.error.code).toBe('FORBIDDEN');
        });

        it('should return 404 if comment not found', async () => {
            const authUser = createMockAuthUser({ id: 'usr_123' });
            mockAuthUser(authUser);

            prismaMock.comment.findUnique.mockResolvedValue(null);

            const request = createAuthRequest('http://localhost:3000/api/comments/nonexistent', {
                method: 'DELETE',
            });
            const params = Promise.resolve({ id: 'nonexistent' });
            const response = await DELETE(request, { params });
            const data = await response.json();

            expect(response.status).toBe(404);
        });
    });
});
