/// All portfolio content lives here. Edit this file to update the site.
library;

class SocialLink {
  const SocialLink({
    required this.label,
    required this.url,
    required this.handle,
  });

  final String label;
  final String url;
  final String handle;
}

class Experience {
  const Experience({
    required this.role,
    required this.company,
    required this.period,
    required this.location,
    required this.highlights,
  });

  final String role;
  final String company;
  final String period;
  final String location;
  final List<String> highlights;
}

enum StoreKind { googlePlay, appStore }

class StoreLink {
  const StoreLink({required this.kind, required this.url});

  final StoreKind kind;
  final String url;

  String get label => switch (kind) {
        StoreKind.googlePlay => 'Google Play',
        StoreKind.appStore => 'App Store',
      };

  /// True until a real store URL is filled in. Placeholder links point at a
  /// store's home page rather than a specific app, so the button is hidden
  /// instead of sending visitors somewhere wrong.
  bool get isPlaceholder =>
      url == 'https://play.google.com/store' || url == 'https://apps.apple.com';
}

class Project {
  const Project({
    required this.name,
    required this.description,
    required this.tags,
    required this.slug,
    this.shotCount = 0,
    this.links = const [],
    this.isFreelance = false,
  });

  final String name;
  final String description;
  final List<String> tags;
  final List<StoreLink> links;
  final bool isFreelance;

  /// Asset folder name under `assets/screenshots/`.
  final String slug;

  /// How many store screenshots were saved for this project. Files are named
  /// `01.jpg` … so the paths are derived rather than listed one by one.
  final int shotCount;

  List<String> get screenshots => [
        for (var i = 1; i <= shotCount; i++)
          'assets/screenshots/$slug/${i.toString().padLeft(2, '0')}.jpg',
      ];
}

class SkillGroup {
  const SkillGroup({required this.title, required this.skills});

  final String title;
  final List<String> skills;
}

abstract final class PortfolioData {
  static const name = 'Khalid Mohamed';
  static const role = 'Flutter Developer';
  static const location = 'Mansoura, Egypt';
  static const email = 'khalidmetwaley@gmail.com';
  static const phone = '+201023291641';
  static const cvAsset = 'assets/cv/khalid_mohamed_cv.pdf';
  static const cvFileName = 'Khalid_Mohamed_Flutter_Developer_CV.pdf';

  /// Hosted copy of the CV, used on non-web builds where the bundled asset has
  /// no URL the OS can open.
  static const cvUrl =
      'https://drive.google.com/file/d/126t02GDKNHSLYXI65UB6fkZbbtKPseqW/view';

  static const tagline =
      'I build high-quality mobile apps with Flutter & Dart.';

  static const about =
      'Software Engineer specializing in mobile app development using Flutter '
      'and Dart. Proven ability to design, develop, and deliver high-quality '
      'mobile apps that meet the needs of users and stakeholders. Expertise in '
      'software design and architecture, team collaboration, and rapid '
      'learning.';

  static const education = (
    degree: 'Bachelor of Computer & Information Science',
    school: 'Mansoura University',
    period: '2019 – 2023',
  );

  static const socials = <SocialLink>[
    SocialLink(
      label: 'GitHub',
      url: 'https://github.com/khalidMtwaley',
      handle: 'github.com/khalidMtwaley',
    ),
    SocialLink(
      label: 'LinkedIn',
      url: 'https://linkedin.com/in/khalid-metwaley',
      handle: 'linkedin.com/in/khalid-metwaley',
    ),
    SocialLink(
      label: 'Email',
      url: 'mailto:$email',
      handle: email,
    ),
    SocialLink(
      label: 'Phone',
      url: 'tel:$phone',
      handle: phone,
    ),
  ];

  static const stats = <({String value, String label})>[
    (value: '2+', label: 'Years Experience'),
    (value: '11+', label: 'Apps Shipped'),
    (value: '4', label: 'Companies'),
  ];

  static const experiences = <Experience>[
    Experience(
      role: 'Flutter Developer',
      company: 'Idaam Cloud',
      period: '12/2024 – Present',
      location: 'UAE · Remote',
      highlights: [
        'Built and maintained mobile applications using Clean Architecture and Cubit.',
        'Developed deep linking flows for seamless external navigation and app activation.',
        'Implemented real-time features using WebSockets for live updates.',
        'Worked with audio and video calling using LiveKit for real-time communication.',
        'Integrated AI-powered services, enabling smart automated features.',
        'Configured CI/CD pipelines to automate builds and deployments.',
      ],
    ),
    Experience(
      role: 'Flutter Developer',
      company: 'AB Avantage',
      period: '10/2025 – 01/2026',
      location: 'Egypt · Remote (Part-time)',
      highlights: [
        'Worked on production Flutter apps (EZYXS & TRJRS) using Cubit for state management.',
        'Integrated secure payment gateways.',
        'Improved code quality through refactoring and Clean Architecture practices.',
        'Enhanced UI/UX for better performance and user experience.',
      ],
    ),
    Experience(
      role: 'Flutter Developer',
      company: 'Rowad Technology',
      period: '12/2024 – 09/2025',
      location: 'KSA · Remote (Part-time)',
      highlights: [
        'Developed and maintained scalable mobile apps using Flutter, Clean Architecture, and Cubit.',
        'Implemented real-time map tracking with Pusher Channels for live order and driver updates.',
        'Integrated payment gateways, push notifications, and deep linking.',
        'Configured CI/CD pipelines to automate builds, testing, and deployment.',
      ],
    ),
    Experience(
      role: 'Flutter Developer',
      company: 'Vision Company',
      period: '05/2024 – 11/2024',
      location: 'Mansoura · Full-time',
      highlights: [
        'Developed and maintained production mobile apps using Flutter, MVVM, Cubit, and Provider.',
        'Integrated payment gateways, push notifications, and Google Maps features.',
        'Improved app performance, fixed issues, and delivered stable, high-quality releases.',
      ],
    ),
  ];

  static const projects = <Project>[
    Project(
      name: 'Keme Meet',
      slug: 'keme_meet',
      shotCount: 6,
      description:
          'Brain Health USA\'s official communication and video conferencing app '
          'for staff and the Residency Program. Delivers secure, high-quality '
          'virtual meetings with instant access through meeting IDs or direct '
          'links. Supports background services on Android and iOS to maintain '
          'meeting continuity, Picture-in-Picture mode for multitasking during '
          'active calls, and deep linking to join meetings from shared invites.',
      tags: ['LiveKit', 'Video Calls', 'Deep Linking', 'PiP', 'Background Services'],
      links: [
        StoreLink(
          kind: StoreKind.googlePlay,
          url: 'https://play.google.com/store/apps/details?id=com.brain.brainhealth.meet',
        ),
        StoreLink(
          kind: StoreKind.appStore,
          url: 'https://apps.apple.com/us/app/keme-meet/id6742255880',
        ),
      ],
    ),
    Project(
      name: 'Best Touch',
      slug: 'best_touch',
      shotCount: 3,
      description:
          'A comprehensive automotive service platform that connects users with '
          'trusted car care professionals. Customers can book services such as '
          'car washing, detailing, and maintenance, while securely sharing their '
          'location and service requests directly with providers.',
      tags: ['Google Maps', 'Booking', 'Location Services'],
      links: [
        StoreLink(
          kind: StoreKind.googlePlay,
          url: 'https://play.google.com/store/apps/details?id=com.visionco.best_touch',
        ),
        StoreLink(
          kind: StoreKind.appStore,
          url: 'https://apps.apple.com/eg/app/%D8%A7%D9%81%D8%B6%D9%84-%D9%84%D9%85%D8%B3%D9%87/id6502757840',
        ),
      ],
    ),
    Project(
      name: 'Brain Health',
      slug: 'brain_health',
      shotCount: 6,
      description:
          'Personalized support for individuals looking to improve their '
          'cognitive well-being. Licensed professionals offer therapy, coaching, '
          'and mental health services. Clients can access their personalized '
          'treatment plan, schedule appointments, and communicate with their '
          'therapist or coach.',
      tags: ['Healthcare', 'Scheduling', 'Chat', 'Clean Architecture'],
      links: [
        StoreLink(
          kind: StoreKind.googlePlay,
          url: 'https://play.google.com/store/apps/details?id=com.newhealthy.app',
        ),
        StoreLink(
          kind: StoreKind.appStore,
          url: 'https://apps.apple.com/eg/app/brain-health-usa/id1667963400',
        ),
      ],
    ),
    Project(
      name: 'Zado',
      slug: 'zado',
      shotCount: 4,
      description:
          'A food delivery platform in Iraq that connects users with leading '
          'restaurants. Customers can browse menus, place orders, and track '
          'deliveries in real time, backed by a dedicated driver app for '
          'efficient order fulfillment.',
      tags: ['Real-time Tracking', 'Pusher', 'Payments', 'Google Maps'],
      links: [
        StoreLink(
          kind: StoreKind.googlePlay,
          url: 'https://play.google.com/store/apps/details?id=com.zado.zadoapp',
        ),
        StoreLink(
          kind: StoreKind.appStore,
          url: 'https://apps.apple.com/us/app/zado/id6775782254',
        ),
      ],
    ),
    Project(
      name: 'Zado Driver',
      slug: 'zado_driver',
      shotCount: 4,
      description:
          'A dedicated delivery application that allows drivers to receive, '
          'accept, and manage delivery requests in real time. Provides order '
          'details, customer locations, live navigation, delivery status '
          'updates, and real-time location tracking.',
      tags: ['Live Navigation', 'Real-time', 'Background Location'],
      links: [
        StoreLink(
          kind: StoreKind.googlePlay,
          url: 'https://play.google.com/store/apps/details?id=com.zado.zadodriverapp',
        ),
        StoreLink(
          kind: StoreKind.appStore,
          url: 'https://apps.apple.com/us/app/zado-driver/id6775603643',
        ),
      ],
    ),
    Project(
      name: 'Zado Restaurant',
      slug: 'zado_restaurant',
      shotCount: 4,
      description:
          'A restaurant management application that enables owners to manage '
          'restaurants, orders, and products from one platform. Add, edit, or '
          'remove menu items, view incoming orders, update statuses, and manage '
          'the full order lifecycle.',
      tags: ['Dashboard', 'Order Management', 'Cubit'],
      links: [
        StoreLink(
          kind: StoreKind.googlePlay,
          url: 'https://play.google.com/store/apps/details?id=com.zado.zadoresturant',
        ),
      ],
    ),
    Project(
      name: 'EZYXS',
      slug: 'ezyxs',
      shotCount: 7,
      description:
          'A sports venue booking platform that enables users to discover and '
          'reserve football, basketball, and other sports facilities. Provides '
          'real-time time-slot selection, secure online payments, and a seamless '
          'booking experience from venue discovery to confirmation.',
      tags: ['Booking', 'Payment Gateway', 'Real-time Slots'],
      links: [
        StoreLink(
          kind: StoreKind.googlePlay,
          url: 'https://play.google.com/store/apps/details?id=com.abavantage.ezyxs',
        ),
        StoreLink(
          kind: StoreKind.appStore,
          url: 'https://apps.apple.com/us/app/ezyxs-easy-access/id6759061233',
        ),
      ],
    ),
    Project(
      name: 'TRJRS',
      slug: 'trjrs',
      shotCount: 5,
      description:
          'An e-commerce platform specializing in handcrafted products, '
          'particularly Pharaonic-inspired creations. Users browse products, add '
          'to cart, save favorites, and place orders. Sellers can create '
          'accounts, showcase products, manage stores, and handle orders.',
      tags: ['E-commerce', 'Multi-vendor', 'Payments'],
      links: [
        StoreLink(
          kind: StoreKind.googlePlay,
          url: 'https://play.google.com/store/apps/details?id=com.abavantage.trjrs',
        ),
      ],
    ),
    Project(
      name: '3D Titanium',
      slug: 'titanium_3d',
      shotCount: 6,
      description:
          'A mobile platform designed for dentists, patients, and dental '
          'material suppliers. Dentists create professional profiles, manage '
          'appointments, and receive bookings. Companies register to showcase '
          'and sell dental materials. Patients browse doctors, view profiles, '
          'and book appointments — all in one app.',
      tags: ['Multi-role', 'Marketplace', 'Appointments'],
      isFreelance: true,
      links: [
        StoreLink(
          kind: StoreKind.googlePlay,
          url: 'https://play.google.com/store/apps/details?id=com.titanuim.titanuimdental',
        ),
      ],
    ),
    Project(
      name: 'Mrkabti',
      slug: 'mrkabti',
      shotCount: 7,
      description:
          'A transport app for Palestine, allowing users to register with their '
          'driving license. Provides built-in insurance services, instant '
          'accident reporting, and contact with ambulance, police, or emergency '
          'support through a dedicated chat system. Includes a full marketplace '
          'to list, sell, and purchase products.',
      tags: ['Transport', 'Insurance', 'Chat', 'Marketplace'],
      isFreelance: true,
      links: [
        StoreLink(
          kind: StoreKind.googlePlay,
          url: 'https://play.google.com/store/apps/details?id=com.app.mrkbati.mobile',
        ),
      ],
    ),
    Project(
      name: 'Koshk',
      slug: 'koshk',
      shotCount: 3,
      description:
          'A smart electronics marketplace that enables users to browse and '
          'purchase devices such as smartphones, tablets, and televisions. '
          'Customers discover nearby vendors based on their location and '
          'communicate directly by phone for inquiries and purchasing.',
      tags: ['Marketplace', 'Geolocation', 'E-commerce'],
      links: [
        StoreLink(
          kind: StoreKind.googlePlay,
          url: 'https://play.google.com/store/apps/details?id=com.visionco.koshk',
        ),
        StoreLink(
          kind: StoreKind.appStore,
          url: 'https://apps.apple.com/us/app/koshk-aljawal/id6739207745',
        ),
      ],
    ),
  ];

  static const skillGroups = <SkillGroup>[
    SkillGroup(
      title: 'Languages & Core',
      skills: ['Flutter', 'Dart', 'OOP', 'SOLID', 'Design Patterns'],
    ),
    SkillGroup(
      title: 'State Management',
      skills: ['Bloc / Cubit', 'Provider', 'GetX', 'Riverpod'],
    ),
    SkillGroup(
      title: 'Architecture',
      skills: ['Clean Architecture', 'MVVM', 'Flavors'],
    ),
    SkillGroup(
      title: 'Real-time & Networking',
      skills: [
        'WebSockets',
        'Pusher Channels',
        'Socket.IO',
        'Dio',
        'HTTP',
      ],
    ),
    SkillGroup(
      title: 'Integrations',
      skills: [
        'Firebase',
        'Google Maps',
        'Payment Gateways',
        'Push Notifications',
        'Deep Linking',
      ],
    ),
    SkillGroup(
      title: 'Storage & Tooling',
      skills: [
        'SharedPreferences',
        'Hive',
        'CI/CD',
        'GitHub',
        'GitLab',
      ],
    ),
  ];
}
