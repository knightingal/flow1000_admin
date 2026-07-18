class Ship {
  final int id;
  final String shipName;
  final int shipType;

  Ship({required this.id, required this.shipName, required this.shipType});

  factory Ship.fromJson(Map<String, dynamic> json) {
    return Ship(
      id: json["id"],
      shipName: json["shipName"],
      shipType: json["shipType"],
    );
  }
}
