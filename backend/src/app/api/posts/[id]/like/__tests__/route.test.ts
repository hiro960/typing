import { NextRequest } from 'next/server';
import { POST, DELETE } from '../route';
import { prismaMock, resetPrismaMock } from '@/lib/test-utils/prisma-mock';
import { createMockPost, createMockLike } from '@/lib/test-utils/factories';
import {
    createAuthRequest,
    mockAuthUser,
    clearAuthMock,
    createMockAuthUser,
} from '@/lib/test-utils/auth-mock';

describe('API /api/posts/[id]/like', () => {
    beforeEach(() => {
        resetPrismaMock();
        clearAuthMock();
    });

    describe('POST /api/posts/[id]/like', () => {
        it('should like a post', async () => {
            const authUser = createMockAuthUser({ id: 'usr_123' });
            mockAuthUser(authUser);

            const mockPost = createMockPost({ id: 'post_1' });
            prismaMock.post.findUnique.mockResolvedValue(mockPost);
            prismaMock.like.findUnique.mockResolvedValue(null); // Not liked yet
            prismaMock.like.create.mockResolvedValue(createMockLike({ postId: 'post_1', userId: 'usr_123' }));
            prismaMock.post.update.mockResolvedValue({ ...mockPost, likesCount: 1 });

            const request = createAuthRequest('http://localhost:3000/api/posts/post_1/like', {
                method: 'POST',
            });
            const params = Promise.resolve({ id: 'post_1' });
            const response = await POST(request, { params });
            const data = await response.json();

            expect(response.status).toBe(201);
            expect(data.liked).toBe(true);
        });

        it('should return 409 if already liked', async () => {
            const authUser = createMockAuthUser({ id: 'usr_123' });
            mockAuthUser(authUser);

            const mockPost = createMockPost({ id: 'post_1' });
            prismaMock.post.findUnique.mockResolvedValue(mockPost);
            prismaMock.like.findUnique.mockResolvedValue(createMockLike()); // Already liked

            const request = createAuthRequest('http://localhost:3000/api/posts/post_1/like', {
                method: 'POST',
            });
            const params = Promise.resolve({ id: 'post_1' });
            const response = await POST(request, { params });

            expect(response.status).toBe(409);
        });
    });

    describe('DELETE /api/posts/[id]/like', () => {
        it('should unlike a post', async () => {
            const authUser = createMockAuthUser({ id: 'usr_123' });
            mockAuthUser(authUser);

            const mockPost = createMockPost({ id: 'post_1' });
            prismaMock.post.findUnique.mockResolvedValue(mockPost);
            prismaMock.like.findUnique.mockResolvedValue(createMockLike()); // Liked
            prismaMock.like.delete.mockResolvedValue(createMockLike());
            prismaMock.post.update.mockResolvedValue({ ...mockPost, likesCount: 0 });

            const request = createAuthRequest('http://localhost:3000/api/posts/post_1/like', {
                method: 'DELETE',
            });
            const params = Promise.resolve({ id: 'post_1' });
            const response = await DELETE(request, { params });
            const data = await response.json();

            expect(response.status).toBe(200);
            expect(data.liked).toBe(false);
        });

        it('should return 404 if not liked', async () => {
            const authUser = createMockAuthUser({ id: 'usr_123' });
            mockAuthUser(authUser);

            const mockPost = createMockPost({ id: 'post_1' });
            prismaMock.post.findUnique.mockResolvedValue(mockPost);
            prismaMock.like.findUnique.mockResolvedValue(null); // Not liked

            const request = createAuthRequest('http://localhost:3000/api/posts/post_1/like', {
                method: 'DELETE',
            });
            const params = Promise.resolve({ id: 'post_1' });
            const response = await DELETE(request, { params });

            expect(response.status).toBe(404);
        });
    });
});
