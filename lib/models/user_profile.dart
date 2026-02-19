/// UserProfile model representing user profile data from Supabase
class UserProfile {
  final String id;
  final String fullName;
  final String jobTitle;
  final String location;
  final String bio;
  final List<String> interests;
  final String workStatus;
  final String education;
  final String phone;
  final String email;

  UserProfile({
    required this.id,
    required this.fullName,
    required this.jobTitle,
    required this.location,
    required this.bio,
    required this.interests,
    required this.workStatus,
    required this.education,
    required this.phone,
    required this.email,
  });

  /// Create UserProfile from Supabase JSON data
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      fullName: json['full_name'] as String? ?? '',
      jobTitle: json['job_title'] as String? ?? '',
      location: json['location'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      interests: (json['interests'] as List<dynamic>?)?.cast<String>() ?? [],
      workStatus: json['work_status'] as String? ?? '',
      education: json['education'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }

  /// Convert UserProfile to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'job_title': jobTitle,
      'location': location,
      'bio': bio,
      'interests': interests,
      'work_status': workStatus,
      'education': education,
      'phone': phone,
      'email': email,
    };
  }

  /// Create a copy with updated fields
  UserProfile copyWith({
    String? id,
    String? fullName,
    String? jobTitle,
    String? location,
    String? bio,
    List<String>? interests,
    String? workStatus,
    String? education,
    String? phone,
    String? email,
  }) {
    return UserProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      jobTitle: jobTitle ?? this.jobTitle,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
      workStatus: workStatus ?? this.workStatus,
      education: education ?? this.education,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }

  /// Mock data for development/testing
  static UserProfile get mockProfile {
    return UserProfile(
      id: 'mock-user-id',
      fullName: 'Arpit Gupta',
      jobTitle: 'Product Designer',
      location: 'New Delhi, India',
      bio: 'Designer, developer and a curious lifelong learner. Loves sketching product ideas and building delightful user experiences.',
      interests: ['Product Design', 'Photography', 'Reading', 'Cycling'],
      workStatus: 'Full-time, currently at Acme Co.',
      education: 'B.Des — NID',
      phone: '+91 98765 43210',
      email: 'arpit@example.com',
    );
  }
}
