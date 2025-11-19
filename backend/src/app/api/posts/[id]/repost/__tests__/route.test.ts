import { NextRequest } from 'next/server';
import { POST, DELETE } from '../route';
import { prismaMock, resetPrismaMock } from '@/lib/test-utils/prisma-mock';
import { createMockPost } from '@/lib/test-utils/factories';
import {
    createAuthRequest,
    mockAuthUser,
    clearAuthMock,
    createMockAuthUser,
} from '@/lib/test-utils/auth-mock';

describe('API /api/posts/[id]/repost', () => {
    beforeEach(() => {
        resetPrismaMock();
        clearAuthMock();
    });

    describe('POST /api/posts/[id]/repost', () => {
        it('should repost a post', async () => {
            const authUser = createMockAuthUser({ id: 'usr_123' });
            mockAuthUser(authUser);

            const mockPost = createMockPost({ id: 'post_1' });
            prismaMock.post.findUnique.mockResolvedValue(mockPost);
            prismaMock.repost.findUnique.mockResolvedValue(null); // Not reposted yet
            prismaMock.repost.create.mockResolvedValue({
                id: 'rp_1',
                userId: 'usr_123',
                originalPostId: 'post_1',
                createdAt: new Date(),
            });
            prismaMock.post.update.mockResolvedValue({ ...mockPost, repostsCount: 1 });

            const request = createAuthRequest('http://localhost:3000/api/posts/post_1/repost', {
                method: 'POST',
            });
            const params = Promise.resolve({ id: 'post_1' });
            const response = await POST(request, { params });
            const data = await response.json();

            expect(response.status).toBe(201);
            expect(data.reposted).toBe(true);
            expect(data.repostsCount).toBe(1);
        });
    });

    describe('DELETE /api/posts/[id]/repost', () => {
        it('should unrepost a post', async () => {
            const authUser = createMockAuthUser({ id: 'usr_123' });
            mockAuthUser(authUser);

            const mockPost = createMockPost({ id: 'post_1' });
            prismaMock.post.findUnique.mockResolvedValue(mockPost);
            prismaMock.repost.findUnique.mockResolvedValue({
                id: 'rp_1',
                userId: 'usr_123',
                originalPostId: 'post_1',
                createdAt: new Date(),
            }); // Reposted
            prismaMock.repost.delete.mockResolvedValue({
                id: 'rp_1',
                userId: 'usr_123',
                originalPostId: 'post_1',
                createdAt: new Date(),
            });
            prismaMock.post.update.mockResolvedValue({ ...mockPost, repostsCount: 0 });

            const request = createAuthRequest('http://localhost:3000/api/posts/post_1/repost', {
                method: 'DELETE',
            });
            const params = Promise.resolve({ id: 'post_1' });
            const response = await DELETE(request, { params });
            const data = await response.json();

            expect(response.status).toBe(200);
            expect(data.reposted).toBe(false);
            expect(data.repostsCount).toBe(0);
        });
    });
});
