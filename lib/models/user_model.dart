class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String role; // buyer, seller, agent, builder, admin
  final String? photoUrl;
  final String? phone;
  final bool isVerified;
  final String? subscriptionPlan; // basic, pro, enterprise
  final String? subscriptionExpiry;
  final List<String> wishlist;
  final List<String> recentlyViewed;
  final List<String> compareList;
  final String createdAt;

  const UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
    this.photoUrl,
    this.phone,
    this.isVerified = false,
    this.subscriptionPlan,
    this.subscriptionExpiry,
    this.wishlist = const [],
    this.recentlyViewed = const [],
    this.compareList = const [],
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      role: map['role'] ?? 'buyer',
      photoUrl: map['photoUrl'],
      phone: map['phone'],
      isVerified: map['isVerified'] ?? false,
      subscriptionPlan: map['subscriptionPlan'],
      subscriptionExpiry: map['subscriptionExpiry'],
      wishlist: List<String>.from(map['wishlist'] ?? []),
      recentlyViewed: List<String>.from(map['recentlyViewed'] ?? []),
      compareList: List<String>.from(map['compareList'] ?? []),
      createdAt: map['createdAt'] ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'role': role,
        'photoUrl': photoUrl,
        'phone': phone,
        'isVerified': isVerified,
        'subscriptionPlan': subscriptionPlan,
        'subscriptionExpiry': subscriptionExpiry,
        'wishlist': wishlist,
        'recentlyViewed': recentlyViewed,
        'compareList': compareList,
        'createdAt': createdAt,
      };

  UserModel copyWith({
    String? displayName,
    String? photoUrl,
    String? phone,
    bool? isVerified,
    String? subscriptionPlan,
    String? subscriptionExpiry,
    List<String>? wishlist,
    List<String>? recentlyViewed,
    List<String>? compareList,
  }) {
    return UserModel(
      uid: uid, email: email,
      displayName: displayName ?? this.displayName,
      role: role,
      photoUrl: photoUrl ?? this.photoUrl,
      phone: phone ?? this.phone,
      isVerified: isVerified ?? this.isVerified,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
      subscriptionExpiry: subscriptionExpiry ?? this.subscriptionExpiry,
      wishlist: wishlist ?? this.wishlist,
      recentlyViewed: recentlyViewed ?? this.recentlyViewed,
      compareList: compareList ?? this.compareList,
      createdAt: createdAt,
    );
  }

  bool get isSeller => role == 'seller' || role == 'agent' || role == 'builder';
  bool get isAdmin => role == 'admin' || role == 'super_admin';
  bool get hasPro => subscriptionPlan == 'pro' || subscriptionPlan == 'enterprise';
}


class ChatModel {
  final String id;
  final List<String> participants;
  final String lastMessage;
  final String lastMessageTime;
  final String propertyId;
  final String propertyTitle;
  final Map<String, int> unreadCount;

  const ChatModel({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.propertyId,
    required this.propertyTitle,
    required this.unreadCount,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map, String docId) {
    return ChatModel(
      id: docId,
      participants: List<String>.from(map['participants'] ?? []),
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: map['lastMessageTime'] ?? '',
      propertyId: map['propertyId'] ?? '',
      propertyTitle: map['propertyTitle'] ?? '',
      unreadCount: Map<String, int>.from(map['unreadCount'] ?? {}),
    );
  }
}

class MessageModel {
  final String id;
  final String senderId;
  final String text;
  final String timestamp;
  final bool isRead;
  final String? imageUrl;

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.isRead = false,
    this.imageUrl,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map, String docId) {
    return MessageModel(
      id: docId,
      senderId: map['senderId'] ?? '',
      text: map['text'] ?? '',
      timestamp: map['timestamp'] ?? '',
      isRead: map['isRead'] ?? false,
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() => {
        'senderId': senderId,
        'text': text,
        'timestamp': timestamp,
        'isRead': isRead,
        'imageUrl': imageUrl,
      };
}

class ReviewModel {
  final String id;
  final String userId;
  final String userName;
  final String? userPhoto;
  final double rating;
  final String comment;
  final String createdAt;

  const ReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userPhoto,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map, String docId) {
    return ReviewModel(
      id: docId,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userPhoto: map['userPhoto'],
      rating: (map['rating'] ?? 0).toDouble(),
      comment: map['comment'] ?? '',
      createdAt: map['createdAt'] ?? '',
    );
  }
}

class BlogModel {
  final String id;
  final String title;
  final String content;
  final String excerpt;
  final String coverImage;
  final String author;
  final String category;
  final List<String> tags;
  final String createdAt;
  final int readTime;

  const BlogModel({
    required this.id,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.coverImage,
    required this.author,
    required this.category,
    required this.tags,
    required this.createdAt,
    required this.readTime,
  });

  factory BlogModel.fromMap(Map<String, dynamic> map, String docId) {
    return BlogModel(
      id: docId,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      excerpt: map['excerpt'] ?? '',
      coverImage: map['coverImage'] ?? '',
      author: map['author'] ?? '',
      category: map['category'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      createdAt: map['createdAt'] ?? '',
      readTime: map['readTime'] ?? 5,
    );
  }
}
