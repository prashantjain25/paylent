/// Environment-specific variables such as API keys, base URLs, etc.
///
/// Storing environment variables in a dedicated class makes it easy to
/// manage different configurations for development, staging, and production.
/// This file should be added to .gitignore to prevent sensitive data from
/// being committed to version control.
class Env {
  /// The name of the application.
  static const String appName = 'Paylent';

  // Add more environment-specific variables as needed. For example:
  //
  // /// The base URL for the API.
  // static const String apiBaseUrl = 'https://api.paylent.com';
  //
  // /// The API key for a third-party service.
  // static const String thirdPartyApiKey = 'your-api-key-here';
}
