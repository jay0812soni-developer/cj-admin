import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/admin_theme.dart';
import 'core/constants/app_roles.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/views/secret_login_view.dart';
import 'features/dashboard/views/superadmin_dashboard_view.dart';
import 'features/dashboard/views/admin_dashboard_view.dart';
import 'features/dashboard/views/deven_dashboard_view.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc()..add(CheckAuthEvent()),
      child: MaterialApp(
        title: 'ChandraKala Jewellers � Admin Control Center',
        theme: AdminTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              final role = state.role.toLowerCase();
              if (role == AdminRoles.superadmin) {
                return SuperadminDashboardView(displayName: state.displayName);
              } else if (role == AdminRoles.deven) {
                return DevenDashboardView(displayName: state.displayName);
              } else {
                return AdminDashboardView(displayName: state.displayName);
              }
            }
            return const SecretLoginView();
          },
        ),
      ),
    );
  }
}
