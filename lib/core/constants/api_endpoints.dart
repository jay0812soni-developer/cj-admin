class ApiEndpoints {
  static const String baseUrl = 'https://cj-backend-kappa.vercel.app/api';
  
  // Auth
  static const String login = '$baseUrl/admin/auth/login';
  
  // Rates
  static const String rates = '$baseUrl/admin/rates/update';
  static const String publicRates = '$baseUrl/rates';
  
  // Inventory
  static const String inventory = '$baseUrl/admin/inventory';
  static String inventoryItem(int id) => '$baseUrl/admin/inventory/$id';
  
  // Orders
  static const String orders = '$baseUrl/admin/orders';
  
  // Reviews
  static const String reviews = '$baseUrl/admin/reviews/moderate';
  
  // Notifications
  static const String notifications = '$baseUrl/admin/notifications/send';
  
  // Analytics
  static const String analytics = '$baseUrl/admin/analytics/overview';
  
  // Users
  static const String users = '$baseUrl/admin/users';
}
