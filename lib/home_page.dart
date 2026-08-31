import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'core/responsive.dart';
import 'sections/about_section.dart';
import 'sections/contact_section.dart';
import 'sections/experience_section.dart';
import 'sections/hero_section.dart';
import 'sections/projects_section.dart';
import 'sections/skills_section.dart';
import 'widgets/fade_in_on_scroll.dart';
import 'widgets/nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _aboutKey = GlobalKey();
  final _skillsKey = GlobalKey();
  final _experienceKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _contactKey = GlobalKey();

  bool _scrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrolled = _scrollController.offset > 40;
    if (scrolled != _scrolled) setState(() => _scrolled = scrolled);
  }

  void _scrollTo(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
      alignment: 0.02,
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  List<NavItem> get _navItems => [
        NavItem(number: '01.', label: 'About', onTap: () => _scrollTo(_aboutKey)),
        NavItem(
          number: '02.',
          label: 'Experience',
          onTap: () => _scrollTo(_experienceKey),
        ),
        NavItem(
          number: '03.',
          label: 'Projects',
          onTap: () => _scrollTo(_projectsKey),
        ),
        NavItem(
          number: '04.',
          label: 'Skills',
          onTap: () => _scrollTo(_skillsKey),
        ),
        NavItem(
          number: '05.',
          label: 'Contact',
          onTap: () => _scrollTo(_contactKey),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      endDrawer: context.isMobile ? NavDrawer(items: _navItems) : null,
      body: Stack(
        children: [
          const Positioned.fill(child: _BackgroundGlow()),
          ScrollRevealScope(
            child: Scrollbar(
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    SizedBox(height: context.isMobile ? 78 : 90),
                    HeroSection(onContactPressed: () => _scrollTo(_contactKey)),
                    AboutSection(sectionKey: _aboutKey),
                    ExperienceSection(sectionKey: _experienceKey),
                    ProjectsSection(sectionKey: _projectsKey),
                    SkillsSection(sectionKey: _skillsKey),
                    ContactSection(sectionKey: _contactKey),
                    const SiteFooter(),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavBar(
              items: _navItems,
              scrolled: _scrolled,
              onMenuPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Soft radial accent glow behind the page content.
class _BackgroundGlow extends StatelessWidget {
  const _BackgroundGlow();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(-0.7, -0.9),
          radius: 1.3,
          colors: [
            AppColors.accent.withValues(alpha: 0.07),
            AppColors.background,
          ],
        ),
      ),
    );
  }
}
