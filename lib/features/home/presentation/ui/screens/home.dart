import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String name = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int bottomIndex = 0;

  void _openHelpSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const _HelpSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            const _HomeTopBar(),
            const SizedBox(height: 14),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                children: const [
                  _BannerCarousel(),
                  SizedBox(height: 16),
                  _QuickActionsGrid(),
                  SizedBox(height: 18),
                  _SectionHeader(),
                  SizedBox(height: 10),
                  _AppointmentCard(),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),

      /// Floating Help Button
      floatingActionButton: GestureDetector(
        onTap: _openHelpSheet,
        child: Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF2F63F3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.16),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.headset_mic_rounded,
            color: Colors.white,
            size: 26,
          ),
        ),
      ),


    );
  }
}

/// ───────────────────────────────── TOP BAR ─────────────────────────────────

class _HomeTopBar extends StatelessWidget {
  const _HomeTopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              'https://i.pravatar.cc/100?img=12',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good Morning!',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF7B8194),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Brooklyn Simmons',
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF141A2A),
                      height: 1.15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              size: 22,
              color: Color(0xFF141A2A),
            ),
          ),
        ],
      ),
    );
  }
}

/// ──────────────────────────────── BANNER ────────────────────────────────

class _BannerCarousel extends StatelessWidget {
  const _BannerCarousel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              SizedBox(
                height: 148,
                width: double.infinity,
                child: Image.network(
                  'https://images.unsplash.com/photo-1580281658628-86f84f6e7f1b',
                  fit: BoxFit.cover,
                ),
              ),
              const Positioned(
                left: 16,
                bottom: 16,
                child: Text(
                  'Expert Medical Care',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black45,
                        blurRadius: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _Dot(active: false),
            SizedBox(width: 6),
            _Dot(active: true),
            SizedBox(width: 6),
            _Dot(active: false),
          ],
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  final bool active;
  const _Dot({required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 6,
      width: active ? 22 : 6,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF2F63F3) : const Color(0xFFD6DAE6),
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}

/// ───────────────────────────── QUICK ACTIONS ─────────────────────────────

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Row(
          children: [
            Expanded(
              child: _QuickCard(
                icon: Icons.calendar_month_rounded,
                title: 'Book Appointment',
                iconColor: Color(0xFF2F63F3),
                bg: Color(0xFFEAF1FF),
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: _QuickCard(
                icon: Icons.description_rounded,
                title: 'My Appointments',
                iconColor: Color(0xFF2DBE60),
                bg: Color(0xFFE9FBEE),
              ),
            ),
          ],
        ),
        SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _QuickCard(
                icon: Icons.assignment_rounded,
                title: 'My Results',
                iconColor: Color(0xFF9B6CFF),
                bg: Color(0xFFF2ECFF),
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: _QuickCard(
                icon: Icons.medication_rounded,
                title: 'Pharmacy',
                iconColor: Color(0xFFFF8A34),
                bg: Color(0xFFFFEFE3),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final Color bg;

  const _QuickCard({
    required this.icon,
    required this.title,
    required this.iconColor,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              height: 1.15,
              color: Color(0xFF141A2A),
            ),
          ),
        ],
      ),
    );
  }
}

/// ───────────────────────────── SECTION HEADER ─────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Text(
          'Appointment',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF141A2A),
          ),
        ),
        Spacer(),
        Text(
          'See all',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2F63F3),
          ),
        ),
      ],
    );
  }
}

/// ───────────────────────────── APPOINTMENT CARD ─────────────────────────────


class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFAEC7FA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor Image
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              'https://i.pravatar.cc/150?img=5',
              height: 90,
              width: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),

          // Right Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + More icon
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Text(
                        'Dr. Dianne Russell',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2D3A5F),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.more_vert,
                      color: Color(0xFF2D3A5F),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                const Text(
                  'Psychiatrist',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2D3A5F),
                  ),
                ),

                const SizedBox(height: 12),

                // Date & Time pill
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6E92F2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.calendar_today,
                          size: 12, color: Colors.white),
                      SizedBox(width: 2),
                      Text(
                        'Tue, 29 Jun, 2025',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.access_time,
                          size: 12, color: Colors.white),
                      SizedBox(width: 2),
                      Text(
                        'Morning 08:00 AM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



/// ───────────────────────────── BOTTOM NAV ─────────────────────────────



/// ───────────────────────────── HELP SHEET ─────────────────────────────

class _HelpSheet extends StatelessWidget {
  const _HelpSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3367FF), Color(0xFF1E44C6)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          _HelpRow(Icons.call_rounded, 'Call Us', '6677'),
          SizedBox(height: 10),
          _HelpRow(Icons.chat_bubble_rounded, 'WhatsApp', '+465857474774'),
          SizedBox(height: 10),
          _HelpRow(Icons.email_rounded, 'Email', 'info@alihsanhospital.so'),
        ],
      ),
    );
  }
}

class _HelpRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _HelpRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.white),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFEAF0FF),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



