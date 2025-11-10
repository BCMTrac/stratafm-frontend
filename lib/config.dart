import 'package:flutter/foundation.dart' show kIsWeb;

class Config {
  // Detect if we're running on the domain or internal IP
  static String get apiBaseUrl {
    if (kIsWeb) {
      // On web, check the current host
      final host = Uri.base.host;
      
      // If accessing via domain, use relative URLs (proxy will handle it)
      if (host.contains('stratatrac.com.au') || host.contains('stratafm.')) {
        return ''; // Relative URLs - proxy handles routing
      }
      
      // If accessing via internal IP, use explicit backend port
      return 'http://192.168.125.22:3030';
    }
    
    // Default for non-web (mobile apps would use this)
    return 'http://192.168.125.22:3030';
  }
  
  static String getApiUrl(String endpoint) {
    final base = apiBaseUrl;
    if (base.isEmpty) {
      // Relative URL
      return endpoint;
    }
    // Absolute URL
    return '$base$endpoint';
  }
}
