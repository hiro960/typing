import { NextRequest } from 'next/server';
import { GET, PATCH, DELETE } from '../route';
import { prismaMock, resetPrismaMock } from '@/lib/test-utils/prisma-mock';
import { createMockPost, createMockUser } from '@/lib/test-utils/factories';
import {
    createAuthRequest,
    createUnauthRequest,
    mockAuthUser,
    clearAuthMock,
    createMockAuthUser,
} from '@/lib/test-utils/auth-mock';

describe('API /api/posts/[id]', () => {
    beforeEach(() => {
        resetPrismaMock();
        clearAuthMock();
    });

    describe('GET /api/posts/[id]', () => {
        it('should return post details', async () => {
            const mockUser = createMockUser({ id: 'usr_123' });
            const mockPost = createMockPost({
                id: 'post_1',
                userId: 'usr_123',
                visibility: 'public',
            });

            prismaMock.post.findUnique.mockResolvedValue(mockPost);
            prismaMock.user.findUnique.mockResolvedValue(mockUser);

            const request = new NextRequest('http://localhost:3000/api/posts/post_1');
            const params = Promise.resolve({ id: 'post_1' });
            const response = await GET(request, { params });
            const data = await response.json();

            expect(response.status).toBe(200);
            expect(data.id).toBe('post_1');
        });

        it('should return 404 if post not found', async () => {
            prismaMock.post.findUnique.mockResolvedValue(null);

            const request = new NextRequest('http://localhost:3000/api/posts/nonexistent');
            const params = Promise.resolve({ id: 'nonexistent' });
            const response = await GET(request, { params });
            const data = await response.json();

            expect(response.status).toBe(404);
            expect(data.error.code).toBe('NOT_FOUND');
        });
    });

    describe('PATCH /api/posts/[id]', () => {
        it('should update post content', async () => {
            const authUser = createMockAuthUser({ id: 'usr_123' });
            mockAuthUser(authUser);

            const mockPost = createMockPost({
                id: 'post_1',
                userId: 'usr_123',
                content: 'Old content',
                createdAt: new Date(), // Set to now to allow editing
            });
            prismaMock.post.findUnique.mockResolvedValue(mockPost);
            prismaMock.post.update.mockResolvedValue({ ...mockPost, content: 'New content' });

            const request = createAuthRequest('http://localhost:3000/api/posts/post_1', {
                method: 'PATCH',
                body: JSON.stringify({ content: 'New content' }),
            });
            const params = Promise.resolve({ id: 'post_1' });
            const response = await PATCH(request, { params });
            const data = await response.json();

            expect(response.status).toBe(200);
            expect(data.content).toBe('New content');
        });

        it('should return 403 if user is not owner', async () => {
            const authUser = createMockAuthUser({ id: 'usr_456' });
            mockAuthUser(authUser);

            const mockPost = createMockPost({
                id: 'post_1',
                userId: 'usr_123', // Different user
            });
            prismaMock.post.findUnique.mockResolvedValue(mockPost);

            const request = createAuthRequest('http://localhost:3000/api/posts/post_1', {
                method: 'PATCH',
                body: JSON.stringify({ content: 'New content' }),
            });
            const params = Promise.resolve({ id: 'post_1' });
            const response = await PATCH(request, { params });
            const data = await response.json();

            expect(response.status).toBe(403);
            expect(data.error.code).toBe('FORBIDDEN');
        });
    });

    describe('DELETE /api/posts/[id]', () => {
        it('should delete post', async () => {
            const authUser = createMockAuthUser({ id: 'usr_123' });
            mockAuthUser(authUser);

            const mockPost = createMockPost({
                id: 'post_1',
                userId: 'usr_123',
            });
            prismaMock.post.findUnique.mockResolvedValue(mockPost);
            prismaMock.post.delete.mockResolvedValue(mockPost);

            const request = createAuthRequest('http://localhost:3000/api/posts/post_1', {
                method: 'DELETE',
            });
            const params = Promise.resolve({ id: 'post_1' });
            const response = await DELETE(request, { params });

            expect(response.status).toBe(204);
        });
    });
});
