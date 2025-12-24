import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/setup/setup_screen.dart';
import '../../presentation/screens/game_settings/game_settings_screen.dart';
import '../../presentation/screens/categories/category_selection_screen.dart';
import '../../presentation/screens/loading/loading_screen.dart';
import '../../presentation/screens/role_pass/role_pass_screen.dart';
import '../../presentation/screens/blank/blank_screen.dart';
import '../../presentation/screens/game/game_screen.dart';
import '../../presentation/screens/voting/voting_screen.dart';
import '../../presentation/screens/voting/vote_result_screen.dart';
import '../../presentation/screens/feedback/feedback_screen.dart';
import '../../presentation/screens/result/result_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/setup',
        builder: (context, state) => const SetupScreen(),
      ),
      GoRoute(
        path: '/game_settings',
        builder: (context, state) => const GameSettingsScreen(),
      ),
      GoRoute(
        path: '/categories',
        builder: (context, state) => const CategorySelectionScreen(),
      ),
      GoRoute(
        path: '/loading',
        builder: (context, state) => const LoadingScreen(),
      ),
      GoRoute(
        path: '/role_pass',
        builder: (context, state) => const RolePassScreen(),
      ),
      GoRoute(
        path: '/blank',
        builder: (context, state) => const BlankScreen(),
      ),
      GoRoute(
        path: '/game',
        builder: (context, state) => const GameScreen(),
      ),
      GoRoute(
        path: '/voting',
        builder: (context, state) => const VotingScreen(),
      ),
      GoRoute(
        path: '/vote_result',
        builder: (context, state) => const VoteResultScreen(),
      ),
      GoRoute(
        path: '/feedback',
        builder: (context, state) => const FeedbackScreen(),
      ),
      GoRoute(
        path: '/result',
        builder: (context, state) => const ResultScreen(),
      ),
    ],
  );
}
