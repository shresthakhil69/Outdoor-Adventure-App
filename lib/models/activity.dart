import 'package:flutter/material.dart';

class Activity {
  final String id;
  final String label;
  final IconData icon;

  const Activity({required this.id, required this.label, required this.icon});
}

/// Static data for now (frontend only). Replace with API data later.
const List<Activity> activities = [
  Activity(id: 'trekking', label: 'Trekking & High Passes', icon: Icons.terrain),
  Activity(id: 'mtb', label: 'Mountain Biking (MTB)', icon: Icons.directions_bike),
  Activity(
    id: 'camping',
    label: 'Wilderness Camping',
    icon: Icons.change_history_outlined,
  ),
  Activity(id: 'day_hiking', label: 'Day Hiking', icon: Icons.hiking),
  Activity(id: 'glacier', label: 'Glacier Exploration', icon: Icons.ac_unit),
  Activity(id: 'trail_running', label: 'Trail Running', icon: Icons.directions_run),
  Activity(
    id: 'photography',
    label: 'Photography & Birding',
    icon: Icons.photo_camera_outlined,
  ),
  Activity(
    id: 'teahouse',
    label: 'Cultural Teahouse Routes',
    icon: Icons.home_outlined,
  ),
];
