class AppConstants {
  // App Info
  static const appName = 'EstateKart';
  static const appTagline = 'Find Your Dream Home';
  static const appVersion = '1.0.0';

  // Firebase Collections
  static const colProperties = 'properties';
  static const colUsers = 'users';
  static const colBlogs = 'blogs';
  static const colChats = 'chats';
  static const colMessages = 'messages';
  static const colLeads = 'leads';
  static const colReviews = 'reviews';
  static const colNotifications = 'notifications';
  static const colCoupons = 'coupons';
  static const colTestimonials = 'testimonials';

  // Storage Paths
  static const storageProperties = 'properties';
  static const storageAvatars = 'avatars';

  // Pagination
  static const pageSize = 20;
  static const chatPageSize = 50;

  // Property Types
  static const propertyTypes = [
    'Apartment', 'Villa', 'Plot', 'Commercial', 'Office',
    'Studio', 'Penthouse', 'Row House', 'Builder Floor'
  ];

  // BHK Options
  static const bhkOptions = ['1 RK', '1 BHK', '2 BHK', '3 BHK', '4 BHK', '4+ BHK'];

  // Purpose Options
  static const purposeOptions = ['Buy', 'Rent', 'PG/Co-living', 'Commercial'];

  // Amenities
  static const amenities = [
    'Swimming Pool', 'Gym', 'Club House', 'Power Backup',
    'Security', 'Parking', 'Lift', 'Garden', 'Play Area',
    'Jogging Track', 'Intercom', 'Fire Safety', 'CCTV',
    'Rainwater Harvesting', 'Shopping Centre', 'School Nearby',
  ];

  // Cities
  static const popularCities = [
    'Mumbai', 'Delhi', 'Bengaluru', 'Hyderabad', 'Chennai',
    'Pune', 'Kolkata', 'Ahmedabad', 'Jaipur', 'Surat',
  ];

  // Price Ranges
  static const priceRanges = [
    {'label': 'Under ₹50L', 'min': 0, 'max': 5000000},
    {'label': '₹50L - ₹1Cr', 'min': 5000000, 'max': 10000000},
    {'label': '₹1Cr - ₹2Cr', 'min': 10000000, 'max': 20000000},
    {'label': '₹2Cr - ₹5Cr', 'min': 20000000, 'max': 50000000},
    {'label': 'Above ₹5Cr', 'min': 50000000, 'max': 999999999},
  ];

  // Subscription Plans
  static const plans = [
    {
      'id': 'basic',
      'name': 'Basic',
      'price': 0,
      'listings': 3,
      'featured': false,
      'duration': 30,
    },
    {
      'id': 'pro',
      'name': 'Pro',
      'price': 1999,
      'listings': 25,
      'featured': true,
      'duration': 30,
    },
    {
      'id': 'enterprise',
      'name': 'Enterprise',
      'price': 4999,
      'listings': 100,
      'featured': true,
      'duration': 30,
    },
  ];
}
