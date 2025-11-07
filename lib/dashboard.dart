import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'health_check.dart';

class AnimatedDashboard extends StatefulWidget {
  final Map<String, dynamic>? user;
  
  const AnimatedDashboard({super.key, this.user});

  @override
  State<AnimatedDashboard> createState() => _AnimatedDashboardState();
}

class _AnimatedDashboardState extends State<AnimatedDashboard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userName = widget.user?['name'] ?? 'User';
    final userRole = widget.user?['role'] ?? 'Guest';
    
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HealthCheckScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF10B981),
        icon: const Icon(Icons.monitor_heart),
        label: const Text('Health'),
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: child,
            ),
          );
        },
        child: CustomScrollView(
          slivers: [
            // Animated App Bar
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              backgroundColor: const Color(0xFF1E293B),
              flexibleSpace: FlexibleSpaceBar(
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, $userName',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: userRole == 'FacilityManager' 
                                ? const Color(0xFF8B5CF6) 
                                : const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            userRole == 'FacilityManager' ? 'Facility Manager' : 'Resident',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF02569B), Color(0xFF0175C2)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.flutter_dash, size: 14, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                'Flutter',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF8B5CF6),
                        const Color(0xFF6366F1),
                        const Color(0xFF3B82F6),
                      ],
                    ),
                  ),
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: CirclePainter(_pulseController.value),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Dashboard Content
            SliverPadding(
              padding: const EdgeInsets.all(20.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Stats Cards Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildAnimatedStatCard(
                          'Active Tickets',
                          '24',
                          Icons.construction,
                          const Color(0xFFEF4444),
                          0,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildAnimatedStatCard(
                          'Pending Approvals',
                          '7',
                          Icons.pending_actions,
                          const Color(0xFFF59E0B),
                          200,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildAnimatedStatCard(
                          'Move Requests',
                          '3',
                          Icons.moving,
                          const Color(0xFF10B981),
                          400,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildAnimatedStatCard(
                          'Bookings Today',
                          '12',
                          Icons.event,
                          const Color(0xFF8B5CF6),
                          600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Recent Activity Section
                  _buildSectionHeader('Recent Activity'),
                  const SizedBox(height: 16),
                  
                  _buildActivityCard(
                    'Maintenance Request Approved',
                    'Unit 101 - Leaking tap',
                    '5 minutes ago',
                    Icons.check_circle,
                    const Color(0xFF10B981),
                    800,
                  ),
                  const SizedBox(height: 12),
                  _buildActivityCard(
                    'New Move Request',
                    'Unit 205 - Move Out',
                    '1 hour ago',
                    Icons.notification_important,
                    const Color(0xFFF59E0B),
                    900,
                  ),
                  const SizedBox(height: 12),
                  _buildActivityCard(
                    'Facility Booked',
                    'Tennis Court - 6:00 PM',
                    '2 hours ago',
                    Icons.sports_tennis,
                    const Color(0xFF3B82F6),
                    1000,
                  ),

                  const SizedBox(height: 32),

                  // Quick Actions Section
                  _buildSectionHeader('Quick Actions'),
                  const SizedBox(height: 16),
                  
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _buildQuickActionButton(
                        'New Ticket',
                        Icons.add_circle_outline,
                        const Color(0xFFEF4444),
                        1100,
                      ),
                      _buildQuickActionButton(
                        'View Calendar',
                        Icons.calendar_month,
                        const Color(0xFF8B5CF6),
                        1200,
                      ),
                      _buildQuickActionButton(
                        'Reports',
                        Icons.analytics,
                        const Color(0xFF3B82F6),
                        1300,
                      ),
                      _buildQuickActionButton(
                        'Settings',
                        Icons.settings,
                        const Color(0xFF6B7280),
                        1400,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildAnimatedStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
    int delayMs,
  ) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, animValue, child) {
        return Transform.scale(
          scale: animValue,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(0.3),
                  color.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: color, size: 32),
                const SizedBox(height: 12),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActivityCard(
    String title,
    String subtitle,
    String time,
    IconData icon,
    Color color,
    int delayMs,
  ) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, animValue, child) {
        return Transform.translate(
          offset: Offset((1 - animValue) * 100, 0),
          child: Opacity(
            opacity: animValue,
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              time,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    String label,
    IconData icon,
    Color color,
    int delayMs,
  ) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, animValue, child) {
        return Transform.scale(
          scale: animValue,
          child: child,
        );
      },
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for animated background circles
class CirclePainter extends CustomPainter {
  final double animationValue;

  CirclePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.max(size.width, size.height);

    for (int i = 0; i < 3; i++) {
      final radius = maxRadius * animationValue * (i + 1) / 3;
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
