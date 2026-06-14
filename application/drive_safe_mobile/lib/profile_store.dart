import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_bootstrap.dart';

class ProfileData {
  final String fullName;
  final String phone;

  const ProfileData({
    required this.fullName,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phone': phone,
    };
  }

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      fullName: json['fullName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );
  }
}

class ProfileStore {
  static Future<ProfileData> load({User? user}) async {
    final activeUser = _signedInUser(user);
    final prefs = await SharedPreferences.getInstance();
    final localName = prefs.getString(_fullNameKey(activeUser)) ?? '';
    final localPhone = prefs.getString(_phoneKey(activeUser)) ?? '';

    var data = ProfileData(
      fullName: localName,
      phone: localPhone,
    );

    if (activeUser == null) {
      return data;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(activeUser.uid)
          .collection('meta')
          .doc('profile')
          .get();
      final remote = doc.data();
      if (remote != null) {
        data = ProfileData.fromJson(remote);
      }
    } catch (_) {
    }

    return data;
  }

  static Future<void> save(ProfileData data, {User? user}) async {
    final activeUser = _signedInUser(user);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fullNameKey(activeUser), data.fullName);
    await prefs.setString(_phoneKey(activeUser), data.phone);

    if (activeUser == null) {
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(activeUser.uid)
          .collection('meta')
          .doc('profile')
          .set(data.toJson(), SetOptions(merge: true));
    } catch (_) {
    }
  }

  static String _fullNameKey(User? user) => 'profile_fullName_${_identityKey(user)}';

  static String _phoneKey(User? user) => 'profile_phone_${_identityKey(user)}';

  static String _identityKey(User? user) {
    final uid = user?.uid;
    if (uid == null || uid.isEmpty) {
      return 'guest';
    }
    return uid;
  }

  static User? _signedInUser([User? user]) {
    if (!FirebaseBootstrap.isEnabled) {
      return null;
    }
    final activeUser = user ?? FirebaseAuth.instance.currentUser;
    if (activeUser == null || activeUser.isAnonymous) {
      return null;
    }
    return activeUser;
  }
}
