import { NextRequest } from 'next/server';
import { GET, POST } from '../route';
import { prismaMock, resetPrismaMock } from '@/lib/test-utils/prisma-mock';
import { createMockPost, createMockUser, createMockComment } from '@/lib/test-utils/factories';
import {
    createAuthRequest,
    createUnauthRequest,
    mockAuthUser,
    clearAuthMock,
    createMockAuthUser,
} from '@/lib/test-utils/auth-mock';

describe('API /api/posts/[id]/comments', () => {
    beforeEach(() => {
        resetPrismaMock();
        clearAuthMock();
    });

    describe('GET /api/posts/[id]/comments', () => {
        it('should return comments list', async () => {
            const mockUser = createMockUser({ id: 'usr_123' });
            const mockPost = createMockPost({ id: 'post_1', userId: 'usr_123' });
            const mockComments = [
                { ...createMockComment({ id: 'cmt_1', postId: 'post_1', userId: 'usr_123' }), user: createMockUser({ id: 'usr_123' }) },
                { ...createMockComment({ id: 'cmt_2', postId: 'post_1', userId: 'usr_456' }), user: createMockUser({ id: 'usr_456' }) },
            ];

            prismaMock.post.findUnique.mockResolvedValue(mockPost);
            prismaMock.user.findUnique.mockResolvedValue(mockUser);
            prismaMock.comment.findMany.mockResolvedValue(mockComments);

            const request = new NextRequest('http://localhost:3000/api/posts/post_1/comments');
            const params = Promise.resolve({ id: 'post_1' });
            const response = await GET(request, { params });
            const data = await response.json();

            expect(response.status).toBe(200);
            expect(data.data).toHaveLength(2);
        });

        it('should return 404 if post not found', async () => {
            prismaMock.post.findUnique.mockResolvedValue(null);

            const request = new NextRequest('http://localhost:3000/api/posts/nonexistent/comments');
            const params = Promise.resolve({ id: 'nonexistent' });
            const response = await GET(request, { params });
            const data = await response.json();

            expect(response.status).toBe(404);
        });
    });

    describe('POST /api/posts/[id]/comments', () => {
        it('should create a comment', async () => {
            const authUser = createMockAuthUser({ id: 'usr_123' });
            mockAuthUser(authUser);

            const mockPost = createMockPost({ id: 'post_1', userId: 'usr_456' });
            const mockComment = {
                ...createMockComment({
                    id: 'cmt_new',
                    postId: 'post_1',
                    userId: 'usr_123',
                    content: 'Nice post!',
                }),
                user: createMockUser({ id: 'usr_123' }),
            };

            prismaMock.post.findUnique.mockResolvedValue(mockPost);
            prismaMock.comment.create.mockResolvedValue(mockComment);
            // Mock notification creation if needed, but store.ts handles it gracefully usually
            // Assuming addComment handles it.

            const request = createAuthRequest('http://localhost:3000/api/posts/post_1/comments', {
                method: 'POST',
                body: JSON.stringify({ content: 'Nice post!' }),
            });
            const params = Promise.resolve({ id: 'post_1' });
            const response = await POST(request, { params });
            const data = await response.json();

            expect(response.status).toBe(201);
            expect(data.content).toBe('Nice post!');
        });

        it('should return 401 if not authenticated', async () => {
            mockAuthUser(null);
            const request = createUnauthRequest('http://localhost:3000/api/posts/post_1/comments', {
                method: 'POST',
                body: JSON.stringify({ content: 'Nice post!' }),
            });
            const params = Promise.resolve({ id: 'post_1' });
            const response = await POST(request, { params });
            expect(response.status).toBe(401);
        });
    });
});
