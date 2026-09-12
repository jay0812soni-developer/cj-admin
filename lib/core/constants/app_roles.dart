class AdminRoles {
  static const String superadmin = 'superadmin';
  static const String admin = 'admin';
  static const String deven = 'deven';

  static String getTitle(String role) {
    switch (role.toLowerCase()) {
      case superadmin:
        return 'Super Administrator';
      case admin:
        return 'Store Admin (Hasmukh)';
      case deven:
        return 'Store Concierge (Deven)';
      default:
        return 'Staff Operator';
    }
  }

  static bool canManageUsers(String role) => role.toLowerCase() == superadmin;
  static bool canBroadcastPush(String role) => role.toLowerCase() == superadmin;
  static bool canUpdateRates(String role) => role.toLowerCase() == superadmin || role.toLowerCase() == admin;
  static bool canManageInventory(String role) => role.toLowerCase() == superadmin || role.toLowerCase() == admin;
  static bool canManageOrders(String role) => true; // All roles can manage or view orders
  static bool canModerateReviews(String role) => role.toLowerCase() == superadmin || role.toLowerCase() == admin;
}
