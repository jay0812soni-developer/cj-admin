import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_roles.dart';
import '../services/audio_chime_service.dart';
import '../../features/auth/bloc/auth_bloc.dart';

class AdminScaffold extends StatefulWidget {
  final Widget body;
  final String role;
  final String displayName;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final List<NavigationRailDestination> destinations;

  const AdminScaffold({
    super.key,
    required this.body,
    required this.role,
    required this.displayName,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.destinations,
  });

  @override
  State<AdminScaffold> createState() => _AdminScaffoldState();
}

class _AdminScaffoldState extends State<AdminScaffold> {
  bool _chimeEnabled = AudioChimeService.isEnabled;

  void _toggleChime() {
    AudioChimeService.toggle();
    setState(() {
      _chimeEnabled = AudioChimeService.isEnabled;
    });
    if (_chimeEnabled) {
      AudioChimeService.playOrderChime();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('?? Order Reservation Chime enabled.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('?? Order Chime muted.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleColor = widget.role == AdminRoles.superadmin
        ? AdminColors.goldAccent
        : (widget.role == AdminRoles.admin ? AdminColors.info : AdminColors.purple);

    return Scaffold(
      backgroundColor: AdminColors.darkBg,
      appBar: AppBar(
        backgroundColor: AdminColors.darkHeader,
        title: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AdminColors.primaryGold, width: 1.5),
                color: AdminColors.darkSurface,
              ),
              child: const Center(
                child: Text(
                  'CJ',
                  style: TextStyle(
                    color: AdminColors.primaryGold,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'ChandraKala Jewellers',
                  style: GoogleFonts.playfairDisplay(
                    color: AdminColors.textDarkPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  widget.displayName,
                  style: TextStyle(
                    color: roleColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: roleColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: roleColor.withOpacity(0.4)),
              ),
              child: Text(
                AdminRoles.getTitle(widget.role).toUpperCase(),
                style: TextStyle(
                  color: roleColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),
        actions: [
          // Audio Chime Toggle Button
          IconButton(
            icon: Icon(
              _chimeEnabled ? Icons.notifications_active_rounded : Icons.notifications_off_outlined,
              color: _chimeEnabled ? AdminColors.primaryGold : AdminColors.textMuted,
            ),
            tooltip: _chimeEnabled ? 'Order Sound Alert: Active (Click to Mute)' : 'Order Sound Alert: Muted',
            onPressed: _toggleChime,
          ),
          // Test Chime Action
          IconButton(
            icon: const Icon(Icons.volume_up_rounded, color: AdminColors.textMuted, size: 20),
            tooltip: 'Test Order Chime',
            onPressed: () {
              AudioChimeService.playOrderChime();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('?? Testing Order Audio Chime...')),
              );
            },
          ),
          const SizedBox(width: 8),
          // Logout Action
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AdminColors.error, size: 20),
            tooltip: 'Sign Out',
            onPressed: () {
              context.read<AuthBloc>().add(LogoutEvent());
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 768;

          if (isWide) {
            return Row(
              children: [
                NavigationRail(
                  selectedIndex: widget.selectedIndex,
                  onDestinationSelected: widget.onTabSelected,
                  backgroundColor: AdminColors.darkSurface,
                  selectedIconTheme: const IconThemeData(color: AdminColors.primaryGold),
                  unselectedIconTheme: const IconThemeData(color: AdminColors.textMuted),
                  selectedLabelTextStyle: const TextStyle(
                    color: AdminColors.primaryGold,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelTextStyle: const TextStyle(
                    color: AdminColors.textMuted,
                    fontSize: 12,
                  ),
                  labelType: NavigationRailLabelType.all,
                  destinations: widget.destinations,
                ),
                const VerticalDivider(width: 1, thickness: 1, color: AdminColors.darkBorder),
                Expanded(child: widget.body),
              ],
            );
          }

          return Column(
            children: [
              Expanded(child: widget.body),
              NavigationBar(
                selectedIndex: widget.selectedIndex,
                onDestinationSelected: widget.onTabSelected,
                backgroundColor: AdminColors.darkHeader,
                indicatorColor: AdminColors.primaryGold.withOpacity(0.2),
                destinations: widget.destinations
                    .map(
                      (d) => NavigationDestination(
                        icon: d.icon,
                        selectedIcon: d.selectedIcon,
                        label: (d.label as Text).data ?? '',
                      ),
                    )
                    .toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}
