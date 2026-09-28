import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Everything the Dashboard needs about the logged-in user.
class DashboardData {
  final String name;
  final int points;
  final int quizzesCompleted;
  final int? rank; // null if the rank could not be loaded
  final int? topPercent; // e.g. 5 means "Top 5%"

  static const int pointsPerLevel = 1000;

  DashboardData({
    required this.name,
    required this.points,
    required this.quizzesCompleted,
    required this.rank,
    required this.topPercent,
  });

  String get firstName {
    final parts = name.trim().split(RegExp(r'\s+'));
    return parts.isEmpty ? '' : parts.first;
  }

  int get level => points ~/ pointsPerLevel + 1;
  int get pointsInLevel => points % pointsPerLevel;
  double get progress => pointsInLevel / pointsPerLevel;
}

/// Everything the Settings screen needs about the logged-in user.
class UserProfile {
  final String name;
  final String department; // code saved at registration, e.g. "BSIT"
  final String course; // full course name (editable in Settings)
  final String email; // contact email (NOT the login email)
  final String phone;
  final String birthdate;
  final bool emailNotifications;
  final bool deviceNotifications;
  final int points;
  final int quizzesCompleted;
  final int? rank;
  final int? topPercent;

  UserProfile({
    required this.name,
    required this.department,
    required this.course,
    required this.email,
    required this.phone,
    required this.birthdate,
    required this.emailNotifications,
    required this.deviceNotifications,
    required this.points,
    required this.quizzesCompleted,
    required this.rank,
    required this.topPercent,
  });

  int get level => points ~/ DashboardData.pointsPerLevel + 1;
  String get levelTitle =>
      level == 1 ? 'Beginner' : (level <= 4 ? 'Intermediate' : 'Advanced');

  /// Returns a copy with only the given fields changed.
  UserProfile copyWith({
    String? name,
    String? course,
    String? email,
    String? phone,
    String? birthdate,
    bool? emailNotifications,
    bool? deviceNotifications,
  }) {
    return UserProfile(
      name: name ?? this.name,
      department: department,
      course: course ?? this.course,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birthdate: birthdate ?? this.birthdate,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      deviceNotifications: deviceNotifications ?? this.deviceNotifications,
      points: points,
      quizzesCompleted: quizzesCompleted,
      rank: rank,
      topPercent: topPercent,
    );
  }
}

/// THE RANKING RULE (used by Leaderboard, Dashboard and Settings):
///   1. More points        -> better rank.
///   2. Same points        -> FEWER completed quizzes = better rank.
/// Returns true when user A ranks ahead of user B.
bool _beats(int aPoints, int aQuizzes, int bPoints, int bQuizzes) {
  if (aPoints != bPoints) return aPoints > bPoints;
  return aQuizzes < bQuizzes;
}

/// One person on the leaderboard.
class LeaderboardEntry {
  final String uid;
  final String name;
  final String role;
  final int points;
  final int quizzesCompleted;
  int rank; // set after sorting (users with identical scores share a rank)

  LeaderboardEntry({
    required this.uid,
    required this.name,
    required this.role,
    required this.points,
    required this.quizzesCompleted,
    this.rank = 0,
  });

  int get level => points ~/ DashboardData.pointsPerLevel + 1;
}

/// Everything the Leaderboard screen shows.
class LeaderboardData {
  final List<LeaderboardEntry> students; // best rank first
  final LeaderboardEntry? me; // the logged-in user, with their rank

  LeaderboardData({required this.students, required this.me});
}

/// One row in "Recent Achievements".
class ActivityItem {
  final String title;
  final int points;

  ActivityItem({required this.title, required this.points});
}

/// Reads and writes the logged-in user's data in Cloud Firestore.
///
/// Firestore layout:
///   users/{uid}                       -> name, department, points, quizzesCompleted, ...
///   users/{uid}/activities/{autoId}   -> title, points, type, createdAt
class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Full course names for the department codes used in the register/login
  /// dropdowns. Used as the starting value of "Change Course" in Settings.
  static const Map<String, String> courseNames = {
    'BSIT': 'Bachelor of Science in Information Technology',
    'BSCS': 'Bachelor of Science in Computer Science',
    'BSED': 'Bachelor of Secondary Education',
    'BEED': 'Bachelor of Elementary Education',
    'BSN': 'Bachelor of Science in Nursing',
    'BSBA': 'Bachelor of Science in Business Administration',
    'BSHM': 'Bachelor of Science in Hospitality Management',
    'BSCrim': 'Bachelor of Science in Criminology',
    'BSCE': 'Bachelor of Science in Civil Engineering',
  };

  String? get _uid => _auth.currentUser?.uid;

  /// True when someone is logged in.
  bool get isLoggedIn => _auth.currentUser != null;

  DocumentReference<Map<String, dynamic>> _userRef(String uid) =>
      _db.collection('users').doc(uid);

  // ---------------------------------------------------------------------------
  // Name (used by the top header)
  // ---------------------------------------------------------------------------
  Stream<String> userNameStream() {
    final uid = _uid;
    if (uid == null) return Stream.value('');
    return _userRef(uid)
        .snapshots()
        .map((snap) => (snap.data()?['name'] as String?) ?? '');
  }

  // ---------------------------------------------------------------------------
  // Dashboard numbers (updates live whenever the user's document changes)
  // ---------------------------------------------------------------------------
  Stream<DashboardData> dashboardStream() {
    final uid = _uid;
    if (uid == null) return Stream.error('Not logged in');

    return _userRef(uid).snapshots().asyncMap((snap) async {
      final data = snap.data();
      if (data == null) throw StateError('Profile not found');

      final points = (data['points'] as num?)?.toInt() ?? 0;
      final quizzes = (data['quizzesCompleted'] as num?)?.toInt() ?? 0;

      final rankInfo = await _loadRank(points, quizzes);

      return DashboardData(
        name: (data['name'] as String?) ?? '',
        points: points,
        quizzesCompleted: quizzes,
        rank: rankInfo[0],
        topPercent: rankInfo[1],
      );
    });
  }

  /// Campus rank = 1 + the number of students who rank ahead of you
  /// (see the ranking rule at the top of this file).
  /// Returns [rank, topPercent]; both null if it could not be loaded
  /// (the rest of the screen still works).
  Future<List<int?>> _loadRank(int points, int quizzes) async {
    try {
      final snapshot = await _db
          .collection('users')
          .where('role', isEqualTo: 'student')
          .get();

      var ahead = 0;
      for (final doc in snapshot.docs) {
        final d = doc.data();
        final p = (d['points'] as num?)?.toInt() ?? 0;
        final q = (d['quizzesCompleted'] as num?)?.toInt() ?? 0;
        if (_beats(p, q, points, quizzes)) ahead++;
      }

      final myRank = ahead + 1;
      final total = snapshot.docs.isEmpty ? 1 : snapshot.docs.length;
      final percent = ((myRank / total) * 100).ceil().clamp(1, 100).toInt();
      return [myRank, percent];
    } catch (_) {
      return [null, null];
    }
  }

  // ---------------------------------------------------------------------------
  // LEADERBOARD (updates live whenever anyone's points / quizzes change)
  // ---------------------------------------------------------------------------
  Stream<LeaderboardData> leaderboardStream() {
    final myUid = _uid;

    return _db.collection('users').snapshots().map((snapshot) {
      final everyone = snapshot.docs.map((doc) {
        final d = doc.data();
        return LeaderboardEntry(
          uid: doc.id,
          name: (d['name'] as String?) ?? '',
          role: (d['role'] as String?) ?? '',
          points: (d['points'] as num?)?.toInt() ?? 0,
          quizzesCompleted: (d['quizzesCompleted'] as num?)?.toInt() ?? 0,
        );
      }).toList();

      // Only students are listed. Sort best -> worst using the ranking rule
      // (name is only used to keep the order stable for identical scores).
      final students = everyone.where((e) => e.role == 'student').toList();
      students.sort((a, b) {
        if (_beats(
            a.points, a.quizzesCompleted, b.points, b.quizzesCompleted)) {
          return -1;
        }
        if (_beats(
            b.points, b.quizzesCompleted, a.points, a.quizzesCompleted)) {
          return 1;
        }
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });

      // Give out rank numbers. Identical points AND quizzes share a rank.
      for (var i = 0; i < students.length; i++) {
        final current = students[i];
        final previous = i > 0 ? students[i - 1] : null;
        final sameAsPrevious = previous != null &&
            previous.points == current.points &&
            previous.quizzesCompleted == current.quizzesCompleted;
        current.rank = sameAsPrevious ? previous!.rank : i + 1;
      }

      // The logged-in user (student or faculty) for the "Your Rank" banner.
      LeaderboardEntry? me;
      for (final e in everyone) {
        if (e.uid == myUid) me = e;
      }
      if (me != null) {
        final mine = me!;
        mine.rank = students
                .where((s) => _beats(s.points, s.quizzesCompleted, mine.points,
                    mine.quizzesCompleted))
                .length +
            1;
      }

      return LeaderboardData(students: students, me: me);
    });
  }

  // ---------------------------------------------------------------------------
  // SETTINGS: read + update the logged-in user's profile
  // ---------------------------------------------------------------------------
  /// Loads the profile for the Settings screen (fresh from Firestore).
  Future<UserProfile> loadProfile() async {
    final uid = _uid;
    if (uid == null) throw StateError('Not logged in');

    final snap = await _userRef(uid).get();
    final data = snap.data();
    if (data == null) throw StateError('Profile not found');

    final points = (data['points'] as num?)?.toInt() ?? 0;
    final department = (data['department'] as String?) ?? '';
    final savedCourse = (data['course'] as String?) ?? '';
    final quizzes = (data['quizzesCompleted'] as num?)?.toInt() ?? 0;
    final rankInfo = await _loadRank(points, quizzes);

    return UserProfile(
      name: (data['name'] as String?) ?? '',
      department: department,
      // Until the user edits it, show the full name of their department.
      course: savedCourse.isNotEmpty
          ? savedCourse
          : (courseNames[department] ?? department),
      email: (data['email'] as String?) ?? '',
      phone: (data['phone'] as String?) ?? '',
      birthdate: (data['birthdate'] as String?) ?? '',
      emailNotifications: (data['emailNotifications'] as bool?) ?? true,
      deviceNotifications: (data['deviceNotifications'] as bool?) ?? true,
      points: points,
      quizzesCompleted: quizzes,
      rank: rankInfo[0],
      topPercent: rankInfo[1],
    );
  }

  /// Saves the "Account Setting" form under users/{uid}.
  /// Note: `department` is NOT touched, because Login checks it.
  Future<void> updateAccountInfo({
    required String name,
    required String email,
    required String phone,
    required String birthdate,
    required String course,
  }) async {
    final uid = _uid;
    if (uid == null) throw StateError('Not logged in');

    await _userRef(uid).update({
      'name': name,
      'email': email,
      'phone': phone,
      'birthdate': birthdate,
      'course': course,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Keep the Firebase Auth display name in sync (not critical if it fails).
    try {
      await _auth.currentUser?.updateDisplayName(name);
    } catch (_) {}
  }

  /// Saves the notification switches. Pass only the one that changed.
  Future<void> updateNotificationSettings({bool? email, bool? device}) async {
    final uid = _uid;
    if (uid == null) throw StateError('Not logged in');

    final changes = <String, dynamic>{};
    if (email != null) changes['emailNotifications'] = email;
    if (device != null) changes['deviceNotifications'] = device;
    if (changes.isEmpty) return;

    await _userRef(uid).update(changes);
  }

  // ---------------------------------------------------------------------------
  // Activities (quizzes, challenges, daily trivia the user has answered)
  // ---------------------------------------------------------------------------
  /// Newest first. Pass [limit] for "recent" lists, or leave it null for all.
  Stream<List<ActivityItem>> activitiesStream({int? limit}) {
    final uid = _uid;
    if (uid == null) return Stream.value(<ActivityItem>[]);

    Query<Map<String, dynamic>> query = _userRef(uid)
        .collection('activities')
        .orderBy('createdAt', descending: true);
    if (limit != null) query = query.limit(limit);

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final d = doc.data();
        return ActivityItem(
          title: (d['title'] as String?) ?? '',
          points: (d['points'] as num?)?.toInt() ?? 0,
        );
      }).toList();
    });
  }

  /// Call this when the user finishes a quiz / challenge / daily trivia.
  /// It saves the activity AND adds the points, together, in one step.
  ///
  /// Example:
  ///   await UserService().addActivity(
  ///     title: 'Completed University History Quiz',
  ///     points: 150,
  ///     type: 'quiz', // 'quiz', 'challenge' or 'daily'
  ///   );
  Future<void> addActivity({
    required String title,
    required int points,
    String type = 'quiz',
  }) async {
    final uid = _uid;
    if (uid == null) throw StateError('Not logged in');

    final userRef = _userRef(uid);
    final activityRef = userRef.collection('activities').doc();

    final batch = _db.batch();
    batch.set(activityRef, {
      'title': title,
      'points': points,
      'type': type,
      'createdAt': FieldValue.serverTimestamp(),
    });
    batch.update(userRef, {
      'points': FieldValue.increment(points),
      'quizzesCompleted': FieldValue.increment(1),
    });
    await batch.commit();
  }
}
