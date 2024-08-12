class InputValidations {
  static const periodError = "The IP address must contain 3 octets";
  static const integerError = "Only integers are allowed";
  static const octetRangeError = "Must be between 0 and 255 inclusive";
  static const lastOctetRangeError = "For last octet, number must be between 1 and 254 inclusive";
  static const portRangeError = "Must be between 1025 and 65535 inclusive";

  static String? ipAddress(String? ip) {
    if (ip == null) return null;

    final periodCount = '.'.allMatches(ip).length;
    if (periodCount != 3) return periodError;

    final octets = ip
        .split('.') //
        .map((octet) => int.tryParse(octet))
        .toList();
    final lastOctet = octets.removeLast();

    for (int? x in octets) {
      if (x == null) return integerError;
      if (x < 0 || x > 255) return octetRangeError;
    }

    if (lastOctet == null) return integerError;
    if (lastOctet <= 0 || lastOctet >= 255) return lastOctetRangeError;
    return null;
  }

  static String? portNumber(String? port) {
    if (port == null) return null;
    int? x = int.tryParse(port);
    if (x == null) return integerError;
    if (x < 1025 || x > 65535) return portRangeError;
    return null;
  }
}
