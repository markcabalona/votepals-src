// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

class PlaceCandidate extends Equatable {
  final String? id;
  final String name;
  final String longitude;
  final String latitude;
  final String city;
  final String formattedAddress;
  final int? voteCount;
  const PlaceCandidate({
    this.id,
    required this.name,
    required this.longitude,
    required this.latitude,
    required this.city,
    required this.formattedAddress,
    this.voteCount,
  });

  @override
  List<Object> get props => [
        if (id != null) id!,
        name,
        longitude,
        latitude,
        city,
        formattedAddress,
      ];

  factory PlaceCandidate.fromMap(Map<String, dynamic> map) {
    return PlaceCandidate(
      name: map['name'] ??
          map['suburb'] ??
          (map['formatted'] as String?)?.split(',').first ??
          'Unknown',
      longitude: (map['lon'] is num) ? map['lon'].toString() : map['lon'],
      latitude: (map['lat'] is num) ? map['lat'].toString() : map['lat'],
      city: map['city'] ?? '-',
      formattedAddress: map['formatted'] ?? '-',
      id: map['id'],
      voteCount: map['vote_count'],
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'lon': longitude,
        'lat': latitude,
        'city': city,
        'formatted': formattedAddress,
        'vote_count': voteCount ?? 0,
      };
}
