class NetworkLink {
  const NetworkLink({
    required this.fromId,
    required this.toId,
    required this.strength,
  });

  final int fromId;
  final int toId;
  final double strength;
}
