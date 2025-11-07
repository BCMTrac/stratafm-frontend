import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'health_check.dart';
import 'showcase.dart';

class AdminDashboard extends StatefulWidget {
  final Map<String, dynamic>? user;
  
  const AdminDashboard({super.key, this.user});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
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
    final userName = widget.user?['name'] ?? 'Admin';
    
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
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
                      'Admin Dashboard',
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
                            gradient: const LinearGradient(
                              colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.admin_panel_settings, size: 14, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                'Administrator',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
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
                        const Color(0xFFEF4444),
                        const Color(0xFFDC2626),
                        const Color(0xFFB91C1C),
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
                  // Welcome Message
                  Text(
                    'Welcome, $userName! 👋',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You have full administrative access',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Admin Quick Actions
                  _buildSectionHeader('Admin Tools'),
                  const SizedBox(height: 16),
                  
                  _buildAdminActionCard(
                    'Database Health Check',
                    'Monitor database connection, performance, and statistics',
                    Icons.monitor_heart,
                    const Color(0xFF10B981),
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HealthCheckScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildAdminActionCard(
                    'Development Showcase',
                    'View the interactive development journey presentation',
                    Icons.slideshow,
                    const Color(0xFF8B5CF6),
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowcasePage(user: widget.user),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildAdminActionCard(
                    'System Metrics',
                    'View performance monitoring and system statistics',
                    Icons.analytics,
                    const Color(0xFF3B82F6),
                    () {
                      // TODO: Navigate to system metrics
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('System Metrics - Coming Soon')),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildAdminActionCard(
                    'User Management',
                    'Manage users, roles, and permissions',
                    Icons.people,
                    const Color(0xFFF59E0B),
                    () {
                      // TODO: Navigate to user management
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('User Management - Coming Soon')),
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // System Status Cards
                  _buildSectionHeader('System Status'),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatusCard(
                          'API Status',
                          'Online',
                          Icons.cloud_done,
                          const Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatusCard(
                          'Database',
                          'Connected',
                          Icons.storage,
                          const Color(0xFF3B82F6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatusCard(
                          'Users',
                          '4 Active',
                          Icons.person,
                          const Color(0xFF8B5CF6),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatusCard(
                          'Uptime',
                          '99.9%',
                          Icons.timer,
                          const Color(0xFFF59E0B),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Recent Activity
                  _buildSectionHeader('Recent Activity'),
                  const SizedBox(height: 16),
                  
                  _buildActivityItem(
                    'Gary logged in',
                    'Just now',
                    Icons.login,
                    const Color(0xFF10B981),
                  ),
                  const SizedBox(height: 12),
                  _buildActivityItem(
                    'Database health check performed',
                    '5 minutes ago',
                    Icons.check_circle,
                    const Color(0xFF3B82F6),
                  ),
                  const SizedBox(height: 12),
                  _buildActivityItem(
                    'System metrics updated',
                    '15 minutes ago',
                    Icons.refresh,
                    const Color(0xFF8B5CF6),
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

  Widget _buildAdminActionCard(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.3),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
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
              fontSize: 24,
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
    );
  }

  Widget _buildActivityItem(
    String title,
    String time,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
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
