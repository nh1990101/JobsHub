import 'package:go_router/go_router.dart';
import '../models/job.dart';
import '../screens/home_screen.dart';
import '../screens/job_detail_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/admin_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/job-detail',
      builder: (context, state) {
        final job = state.extra as Job;
        return JobDetailScreen(job: job);
      },
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) {
        final job = state.extra as Job;
        return ChatScreen(job: job);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminScreen(),
    ),
  ],
);
