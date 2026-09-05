class AppConfig {
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );
  static const liveKitUrl = String.fromEnvironment(
    'LIVEKIT_URL',
    defaultValue: 'wss://replace-with-your-livekit-host',
  );
}
