import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/diary/data/models/diary_post.dart';
import '../../../features/diary/data/models/diary_search.dart';
import '../../../features/diary/domain/providers/diary_providers.dart';
import '../../widgets/diary_post_card.dart';
import 'post_create_screen.dart';
import 'post_detail_screen.dart';

enum _SearchTab { posts, users, hashtags }

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchState<T> {
  const _SearchState({
    this.items = const [],
    this.nextCursor,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.initialized = false,
    this.errorMessage,
  });

  final List<T> items;
  final String? nextCursor;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final bool initialized;
  final String? errorMessage;

  _SearchState<T> copyWith({
    List<T>? items,
    String? nextCursor,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    bool? initialized,
    String? errorMessage,
  }) {
    return _SearchState<T>(
      items: items ?? this.items,
      nextCursor: nextCursor ?? this.nextCursor,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      initialized: initialized ?? this.initialized,
      errorMessage: errorMessage,
    );
  }
}

class _SearchScreenState extends ConsumerState<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _queryController = TextEditingController();
  final Map<_SearchTab, dynamic> _states = {
    _SearchTab.posts: const _SearchState<DiaryPost>(),
    _SearchTab.users: const _SearchState<DiaryUserSummary>(),
    _SearchTab.hashtags: const _SearchState<DiaryHashtagTrend>(),
  };
  final Map<_SearchTab, ScrollController> _scrollControllers = {};
  String _query = '';
  Timer? _debounce;
  List<String> _history = const [];

  _SearchState<T> _stateFor<T>(_SearchTab tab) =>
      _states[tab] as _SearchState<T>;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _SearchTab.values.length, vsync: this)
      ..addListener(() {
        if (_tabController.indexIsChanging) return;
        _ensureLoaded(_currentTab);
      });
    for (final tab in _SearchTab.values) {
      final controller = ScrollController();
      controller.addListener(() => _maybeLoadMore(tab));
      _scrollControllers[tab] = controller;
    }
    _loadHistory();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureLoaded(_currentTab);
    });
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final entries = prefs.getStringList('diary_search_history') ?? [];
    setState(() => _history = entries);
  }

  Future<void> _saveHistory(String term) async {
    if (term.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final entries = [
      term,
      ..._history.where((item) => item != term),
    ].take(8).toList();
    await prefs.setStringList('diary_search_history', entries);
    setState(() => _history = entries);
  }

  _SearchTab get _currentTab => _SearchTab.values[_tabController.index];

  @override
  void dispose() {
    _queryController.dispose();
    _tabController.dispose();
    _debounce?.cancel();
    for (final controller in _scrollControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _maybeLoadMore(_SearchTab tab) {
    final controller = _scrollControllers[tab];
    if (controller == null) return;
    if (controller.position.pixels >=
        controller.position.maxScrollExtent - 200) {
      _search(tab, loadMore: true);
    }
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      setState(() => _query = value.trim());
      _resetStates();
      _ensureLoaded(_currentTab);
      _saveHistory(_query);
    });
  }

  void _resetStates() {
    for (final tab in _SearchTab.values) {
      _states[tab] = _stateFor<dynamic>(tab).copyWith(
        items: const [],
        nextCursor: null,
        hasMore: false,
        initialized: false,
        errorMessage: null,
      );
    }
  }

  void _ensureLoaded(_SearchTab tab) {
    final state = _stateFor<dynamic>(tab);
    if (state.initialized || state.isLoading) return;
    _search(tab);
  }

  Future<void> _search(
    _SearchTab tab, {
    bool loadMore = false,
  }) async {
    final repository = ref.read(diaryRepositoryProvider);
    switch (tab) {
      case _SearchTab.posts:
        final current = _stateFor<DiaryPost>(tab);
        if (loadMore) {
          if (!current.hasMore || current.isLoadingMore) return;
          _states[tab] = current.copyWith(isLoadingMore: true);
        } else {
          _states[tab] = current.copyWith(isLoading: true);
        }
        setState(() {});
        try {
          final page = await repository.searchPosts(
            _query,
            cursor: loadMore ? current.nextCursor : null,
          );
          final items =
              loadMore ? [...current.items, ...page.posts] : page.posts;
          _states[tab] = _SearchState<DiaryPost>(
            items: items,
            nextCursor: page.nextCursor,
            hasMore: page.hasNextPage,
            isLoading: false,
            isLoadingMore: false,
            initialized: true,
          );
        } catch (error) {
          _states[tab] = current.copyWith(
            isLoading: false,
            isLoadingMore: false,
            errorMessage: error.toString(),
          );
        }
        break;
      case _SearchTab.users:
        final current = _stateFor<DiaryUserSummary>(tab);
        if (loadMore) {
          if (!current.hasMore || current.isLoadingMore) return;
          _states[tab] = current.copyWith(isLoadingMore: true);
        } else {
          _states[tab] = current.copyWith(isLoading: true);
        }
        setState(() {});
        try {
          final page = await repository.searchUsers(
            _query,
            cursor: loadMore ? current.nextCursor : null,
          );
          final items =
              loadMore ? [...current.items, ...page.users] : page.users;
          _states[tab] = _SearchState<DiaryUserSummary>(
            items: items,
            nextCursor: page.nextCursor,
            hasMore: page.hasNextPage,
            isLoading: false,
            isLoadingMore: false,
            initialized: true,
          );
        } catch (error) {
          _states[tab] = current.copyWith(
            isLoading: false,
            isLoadingMore: false,
            errorMessage: error.toString(),
          );
        }
        break;
      case _SearchTab.hashtags:
        final current = _stateFor<DiaryHashtagTrend>(tab);
        if (loadMore) {
          if (!current.hasMore || current.isLoadingMore) return;
          _states[tab] = current.copyWith(isLoadingMore: true);
        } else {
          _states[tab] = current.copyWith(isLoading: true);
        }
        setState(() {});
        try {
          final page = await repository.searchHashtags(
            _query,
            cursor: loadMore ? current.nextCursor : null,
          );
          final items =
              loadMore ? [...current.items, ...page.tags] : page.tags;
          _states[tab] = _SearchState<DiaryHashtagTrend>(
            items: items,
            nextCursor: page.nextCursor,
            hasMore: page.hasNextPage,
            isLoading: false,
            isLoadingMore: false,
            initialized: true,
          );
        } catch (error) {
          _states[tab] = current.copyWith(
            isLoading: false,
            isLoadingMore: false,
            errorMessage: error.toString(),
          );
        }
        break;
    }
    setState(() {});
  }

  void _openPost(DiaryPost post) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PostDetailScreen(initialPost: post),
      ),
    );
  }

  void _quotePost(DiaryPost post) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PostCreateScreen(quotedPost: post),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final postsState = _stateFor<DiaryPost>(_SearchTab.posts);
    final usersState = _stateFor<DiaryUserSummary>(_SearchTab.users);
    final tagsState = _stateFor<DiaryHashtagTrend>(_SearchTab.hashtags);

    return Scaffold(
      appBar: AppBar(
        title: const Text('検索'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _queryController,
              decoration: InputDecoration(
                hintText: '投稿、ユーザー、ハッシュタグを検索',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _queryController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _queryController.clear();
                          _onQueryChanged('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onChanged: _onQueryChanged,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                _onQueryChanged(value);
                _saveHistory(value.trim());
              },
            ),
          ),
          if (_query.isEmpty && _history.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8,
                  children: _history
                      .map(
                        (item) => ActionChip(
                          label: Text(item),
                          onPressed: () {
                            _queryController.text = item;
                            _queryController.selection =
                                TextSelection.fromPosition(
                              TextPosition(offset: item.length),
                            );
                            _onQueryChanged(item);
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: '投稿'),
              Tab(text: 'ユーザー'),
              Tab(text: 'ハッシュタグ'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _PostsResultList(
                  state: postsState,
                  controller: _scrollControllers[_SearchTab.posts]!,
                  onRefresh: () => _search(_SearchTab.posts),
                  onPostTap: _openPost,
                  onQuote: _quotePost,
                  ref: ref,
                ),
                _UsersResultList(
                  state: usersState,
                  controller: _scrollControllers[_SearchTab.users]!,
                  onRefresh: () => _search(_SearchTab.users),
                ),
                _TagsResultList(
                  state: tagsState,
                  controller: _scrollControllers[_SearchTab.hashtags]!,
                  onRefresh: () => _search(_SearchTab.hashtags),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PostsResultList extends StatelessWidget {
  const _PostsResultList({
    required this.state,
    required this.controller,
    required this.onRefresh,
    required this.onPostTap,
    required this.onQuote,
    required this.ref,
  });

  final _SearchState<DiaryPost> state;
  final ScrollController controller;
  final Future<void> Function() onRefresh;
  final ValueChanged<DiaryPost> onPostTap;
  final ValueChanged<DiaryPost> onQuote;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Builder(
        builder: (context) {
          if (state.isLoading && state.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null && state.items.isEmpty) {
            return Center(child: Text(state.errorMessage!));
          }
          if (state.items.isEmpty) {
            return const Center(child: Text('投稿が見つかりません'));
          }
          return ListView.builder(
            controller: controller,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= state.items.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final post = state.items[index];
              return DiaryPostCard(
                post: post,
                onTap: () => onPostTap(post),
                onToggleLike: () => ref
                    .read(diaryTimelineControllerProvider.notifier)
                    .toggleLike(post.id, like: !post.liked),
                onToggleBookmark: () => ref
                    .read(diaryTimelineControllerProvider.notifier)
                    .toggleBookmark(post.id, bookmark: !post.bookmarked),
                onToggleRepost: () => ref
                    .read(diaryTimelineControllerProvider.notifier)
                    .toggleRepost(post.id, repost: !post.reposted),
                onComment: () => onPostTap(post),
                onQuote: () => onQuote(post),
              );
            },
          );
        },
      ),
    );
  }
}

class _UsersResultList extends StatelessWidget {
  const _UsersResultList({
    required this.state,
    required this.controller,
    required this.onRefresh,
  });

  final _SearchState<DiaryUserSummary> state;
  final ScrollController controller;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Builder(
        builder: (context) {
          if (state.isLoading && state.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null && state.items.isEmpty) {
            return Center(child: Text(state.errorMessage!));
          }
          if (state.items.isEmpty) {
            return const Center(child: Text('ユーザーが見つかりません'));
          }
          return ListView.separated(
            controller: controller,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              if (index >= state.items.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final user = state.items[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: user.profileImageUrl != null
                      ? NetworkImage(user.profileImageUrl!)
                      : null,
                  child: user.profileImageUrl == null
                      ? Text(user.displayName.substring(0, 1))
                      : null,
                ),
                title: Text(user.displayName),
                subtitle: Text('@${user.username}'),
              );
            },
          );
        },
      ),
    );
  }
}

class _TagsResultList extends StatelessWidget {
  const _TagsResultList({
    required this.state,
    required this.controller,
    required this.onRefresh,
  });

  final _SearchState<DiaryHashtagTrend> state;
  final ScrollController controller;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Builder(
        builder: (context) {
          if (state.isLoading && state.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null && state.items.isEmpty) {
            return Center(child: Text(state.errorMessage!));
          }
          if (state.items.isEmpty) {
            return const Center(child: Text('ハッシュタグが見つかりません'));
          }
          return ListView.builder(
            controller: controller,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= state.items.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final tag = state.items[index];
              return ListTile(
                title: Text('#${tag.tag}'),
                subtitle: Text('${tag.usage} 件の投稿'),
              );
            },
          );
        },
      ),
    );
  }
}
