import 'package:flutter/material.dart';

class ShowcasePage extends StatefulWidget {
  final Map<String, dynamic> user;

  const ShowcasePage({Key? key, required this.user}) : super(key: key);

  @override
  State<ShowcasePage> createState() => _ShowcasePageState();
}

class _ShowcasePageState extends State<ShowcasePage>
    with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<ShowcaseStep> _steps = [
    ShowcaseStep(
      number: '01',
      title: 'The Challenge',
      subtitle: 'Building a Modern Facility Management System',
      mainText:
          'We needed a complete solution for strata property management—from concept to production deployment.',
      details: [
        'Multi-property management',
        'User authentication & roles',
        'Real-time data access',
        'Mobile & web access',
        'Scalable architecture',
      ],
      color: Color(0xFFE74C3C), // Red
      icon: '⚡',
    ),
    ShowcaseStep(
      number: '02',
      title: 'Frontend Development',
      subtitle: 'Flutter Cross-Platform UI',
      mainText:
          'Built beautiful, responsive interface using Flutter 3.24.5 with Material Design 3.',
      details: [
        'Login screen with authentication',
        'Animated dashboard interface',
        'Role-based access control',
        'Dark theme aesthetic',
        'Cross-platform (Web, iOS, Android)',
      ],
      color: Color(0xFF3498DB), // Blue
      icon: '📱',
      code: '''// Flutter Login Screen
TextField(
  controller: emailController,
  decoration: InputDecoration(
    labelText: 'Email',
    prefixIcon: Icon(Icons.email),
  ),
)''',
    ),
    ShowcaseStep(
      number: '03',
      title: 'Backend API',
      subtitle: 'NestJS TypeScript Server',
      mainText:
          'Created enterprise-grade REST API using NestJS with TypeScript on Node.js 24.',
      details: [
        'POST /api/auth/login endpoint',
        'Database connection layer',
        'CORS configuration',
        'Error handling & validation',
        'Production-ready architecture',
      ],
      color: Color(0xFF2ECC71), // Green
      icon: '⚙️',
      code: '''// NestJS Auth Controller
@Post('login')
async login(@Body() loginDto) {
  return this.authService
    .validateUser(loginDto);
}''',
    ),
    ShowcaseStep(
      number: '04',
      title: 'Database Layer',
      subtitle: 'MS SQL Server Integration',
      mainText:
          'Connected to SQL Server 2019 on 192.168.125.133:50430 with secure authentication.',
      details: [
        'StrataFM database created',
        'TestUsers table with roles',
        'Secure SQL authentication',
        'Connection pooling',
        'EIAM architecture prepared',
      ],
      color: Color(0xFFF39C12), // Orange
      icon: '🗄️',
      code: '''-- User Authentication
SELECT * FROM TestUsers
WHERE Email = @email
AND Password = @password''',
    ),
    ShowcaseStep(
      number: '05',
      title: 'Production Deployment',
      subtitle: 'Ubuntu Linux Server',
      mainText:
          'Deployed to production server 192.168.125.22 using PM2 process manager.',
      details: [
        'Backend API: Port 3030',
        'Frontend Web: Port 3035',
        'PM2 auto-restart enabled',
        '24/7 uptime monitoring',
        'Zero-downtime deployments',
      ],
      color: Color(0xFF9B59B6), // Purple
      icon: '🐧',
      code: '''# PM2 Process Management
pm2 start dist/main.js 
  --name stratafm-api
pm2 start http-server 
  --name stratafm-web''',
    ),
    ShowcaseStep(
      number: '06',
      title: 'Version Control',
      subtitle: 'GitHub Integration',
      mainText:
          'Published to private GitHub repositories for collaboration and version tracking.',
      details: [
        'Backend: RupertBcmtrac/stratafm-backend',
        'Frontend: RupertBcmtrac/stratafm-frontend',
        'Private repository security',
        'Commit history tracking',
        'Branch management',
      ],
      color: Color(0xFF34495E), // Dark gray
      icon: '📦',
      code: '''# Git Workflow
git add .
git commit -m "Feature: ..."
git push origin main''',
    ),
    ShowcaseStep(
      number: '07',
      title: 'CI/CD Pipeline',
      subtitle: 'Automated Deployment',
      mainText:
          'Configured GitHub Actions with self-hosted runners for push-to-deploy automation.',
      details: [
        'Self-hosted runners on Linux',
        'Automated testing & building',
        'Deploy on push to main',
        '2-3 minute deployment time',
        'Automatic PM2 restarts',
      ],
      color: Color(0xFFE67E22), // Deep orange
      icon: '🚀',
      code: '''# GitHub Actions
on: push
jobs:
  deploy:
    runs-on: self-hosted
    steps: build → deploy''',
    ),
    ShowcaseStep(
      number: '✓',
      title: 'Complete System',
      subtitle: 'Production Ready',
      mainText:
          'Full-stack application with professional development workflow—all built in one session.',
      details: [
        'Login → API → Database → Response',
        'Auto-deployment pipeline',
        'Professional architecture',
        'Scalable foundation',
        'Ready for production use',
      ],
      color: Color(0xFF16A085), // Teal
      icon: '✨',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
      _controller.reset();
      _controller.forward();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_currentStep];
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Progress bar
            _buildProgressBar(),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left side - Content
                    Expanded(
                      flex: screenSize.width > 1200 ? 6 : 10,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: _buildContent(step),
                        ),
                      ),
                    ),

                    // Right side - Visual
                    if (screenSize.width > 1200)
                      Expanded(
                        flex: 4,
                        child: _buildVisual(step),
                      ),
                  ],
                ),
              ),
            ),

            // Navigation
            _buildNavigation(step),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Row(
        children: [
          // Logo
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'SF',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'StrataFM',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'Development Showcase',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          Spacer(),
          // User info
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      widget.user['name'][0],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  widget.user['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      height: 4,
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: List.generate(
          _steps.length,
          (index) => Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < _steps.length - 1 ? 4 : 0),
              decoration: BoxDecoration(
                color: index <= _currentStep
                    ? _steps[index].color
                    : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ShowcaseStep step) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number
          Text(
            step.number,
            style: TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w900,
              color: step.color.withOpacity(0.2),
              height: 0.9,
            ),
          ),
          SizedBox(height: 8),

          // Title
          Text(
            step.title,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              height: 1.1,
              letterSpacing: -1,
            ),
          ),
          SizedBox(height: 12),

          // Subtitle
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: step.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              step.subtitle,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: step.color,
                letterSpacing: 0.5,
              ),
            ),
          ),
          SizedBox(height: 32),

          // Main text
          Text(
            step.mainText,
            style: TextStyle(
              fontSize: 20,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 32),

          // Details
          ...step.details.map(
            (detail) => Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: EdgeInsets.only(top: 8, right: 16),
                    decoration: BoxDecoration(
                      color: step.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      detail,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Code snippet
          if (step.code != null) ...[
            SizedBox(height: 24),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Color(0xFFFF5F56),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 12,
                        height: 12,
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFBD2E),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Color(0xFF27C93F),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    step.code!,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      color: Color(0xFF00FF00),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVisual(ShowcaseStep step) {
    return Container(
      margin: EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: step.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          step.icon,
          style: TextStyle(fontSize: 120),
        ),
      ),
    );
  }

  Widget _buildNavigation(ShowcaseStep step) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous button
          TextButton.icon(
            onPressed: _currentStep > 0 ? _previousStep : null,
            icon: Icon(Icons.arrow_back),
            label: Text('Previous'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black87,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),

          // Progress indicator
          Row(
            children: List.generate(
              _steps.length,
              (index) => Container(
                width: 8,
                height: 8,
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: index == _currentStep
                      ? step.color
                      : Colors.black12,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          // Next button
          ElevatedButton.icon(
            onPressed: _currentStep < _steps.length - 1 ? _nextStep : null,
            icon: Text(_currentStep < _steps.length - 1 ? 'Next' : 'Done'),
            label: Icon(Icons.arrow_forward),
            style: ElevatedButton.styleFrom(
              backgroundColor: step.color,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShowcaseStep {
  final String number;
  final String title;
  final String subtitle;
  final String mainText;
  final List<String> details;
  final Color color;
  final String icon;
  final String? code;

  ShowcaseStep({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.mainText,
    required this.details,
    required this.color,
    required this.icon,
    this.code,
  });
}
