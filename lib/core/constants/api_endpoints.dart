class ApiEndpoints {
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://cj-backend-kappa.vercel.app/api',
  );

  static const String login = '$baseUrl/admin/auth/login';
  static const String rates = '$baseUrl/admin/rates/update';
  static const String publicRates = '$baseUrl/rates';
  static const String inventory = '$baseUrl/admin/inventory';
  static String inventoryItem(int id) => '$baseUrl/admin/inventory/$id';
  static const String orders = '$baseUrl/admin/orders';
  static const String reviews = '$baseUrl/admin/reviews/moderate';
  static const String notifications = '$baseUrl/admin/notifications/send';
  static const String analytics = '$baseUrl/admin/analytics/overview';
  static const String users = '$baseUrl/admin/users';
}
