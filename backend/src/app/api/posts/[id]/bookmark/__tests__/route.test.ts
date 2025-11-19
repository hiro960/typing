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

describe('API /api/posts/[id]/bookmark', () => {
    beforeEach(() => {
        resetPrismaMock();
        clearAuthMock();
    });

    describe('POST /api/posts/[id]/bookmark', () => {
        it('should bookmark a post', async () => {
            const authUser = createMockAuthUser({ id: 'usr_123' });
            mockAuthUser(authUser);

            const mockPost = createMockPost({ id: 'post_1' });
            prismaMock.post.findUnique.mockResolvedValue(mockPost);
            prismaMock.bookmark.findUnique.mockResolvedValue(null); // Not bookmarked yet
            prismaMock.bookmark.create.mockResolvedValue({
                id: 'bm_1',
                userId: 'usr_123',
                postId: 'post_1',
                createdAt: new Date(),
            });

            const request = createAuthRequest('http://localhost:3000/api/posts/post_1/bookmark', {
                method: 'POST',
            });
            const params = Promise.resolve({ id: 'post_1' });
            const response = await POST(request, { params });
            const data = await response.json();

            expect(response.status).toBe(201);
            expect(data.bookmarked).toBe(true);
        });
    });

    describe('DELETE /api/posts/[id]/bookmark', () => {
        it('should unbookmark a post', async () => {
            const authUser = createMockAuthUser({ id: 'usr_123' });
            mockAuthUser(authUser);

            const mockPost = createMockPost({ id: 'post_1' });
            prismaMock.post.findUnique.mockResolvedValue(mockPost);
            prismaMock.bookmark.findUnique.mockResolvedValue({
                id: 'bm_1',
                userId: 'usr_123',
                postId: 'post_1',
                createdAt: new Date(),
            }); // Bookmarked
            prismaMock.bookmark.delete.mockResolvedValue({
                id: 'bm_1',
                userId: 'usr_123',
                postId: 'post_1',
                createdAt: new Date(),
            });

            const request = createAuthRequest('http://localhost:3000/api/posts/post_1/bookmark', {
                method: 'DELETE',
            });
            const params = Promise.resolve({ id: 'post_1' });
            const response = await DELETE(request, { params });
            const data = await response.json();

            expect(response.status).toBe(200);
            expect(data.bookmarked).toBe(false);
        });
    });
});
