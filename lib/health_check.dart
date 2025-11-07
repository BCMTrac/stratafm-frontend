import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HealthCheckScreen extends StatefulWidget {
  const HealthCheckScreen({super.key});

  @override
  State<HealthCheckScreen> createState() => _HealthCheckScreenState();
}

class _HealthCheckScreenState extends State<HealthCheckScreen> {
  Map<String, dynamic>? _healthData;
  Map<String, dynamic>? _dbHealthData;
  Map<String, dynamic>? _tablesData;
  bool _isLoading = false;
  String _errorMessage = '';
  DateTime? _lastChecked;

  @override
  void initState() {
    super.initState();
    _checkHealth();
  }

  Future<void> _checkHealth() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Check general health
      final healthResponse = await http.get(
        Uri.parse('http://192.168.125.22:3030/health'),
      );

      // Check database health
      final dbHealthResponse = await http.get(
        Uri.parse('http://192.168.125.22:3030/health/db'),
      );

      // Get tables list
      final tablesResponse = await http.get(
        Uri.parse('http://192.168.125.22:3030/health/db/tables'),
      );

      setState(() {
        _healthData = json.decode(healthResponse.body);
        _dbHealthData = json.decode(dbHealthResponse.body);
        _tablesData = json.decode(tablesResponse.body);
        _lastChecked = DateTime.now();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error connecting to server: $e';
        _isLoading = false;
      });
    }
  }

  Color _getStatusColor(String? status) {
    if (status == 'healthy' || status == 'success') return Colors.green;
    if (status == 'unhealthy' || status == 'error') return Colors.red;
    return Colors.orange;
  }

  Widget _buildInfoCard(String title, String value, {Color? valueColor, IconData? icon}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: valueColor ?? Colors.white70, size: 20),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: valueColor ?? Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Database Health Check'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _checkHealth,
          ),
        ],
      ),
      body: _isLoading && _healthData == null
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF8B5CF6),
              ),
            )
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _checkHealth,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B5CF6),
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  color: const Color(0xFF8B5CF6),
                  onRefresh: _checkHealth,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Last Checked
                      if (_lastChecked != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            'Last checked: ${_lastChecked!.toString().substring(0, 19)}',
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      // Overall Status
                      if (_healthData != null) ...[
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _healthData!['status'] == 'healthy'
                                  ? [Colors.green.shade700, Colors.green.shade900]
                                  : [Colors.red.shade700, Colors.red.shade900],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                _healthData!['status'] == 'healthy'
                                    ? Icons.check_circle
                                    : Icons.error,
                                size: 48,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _healthData!['status'] == 'healthy'
                                    ? 'System Healthy'
                                    : 'System Unhealthy',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // API Info
                        const Text(
                          'API Information',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoCard(
                          'Environment',
                          _healthData!['environment'] ?? 'Unknown',
                          icon: Icons.public,
                        ),
                        const SizedBox(height: 8),
                        _buildInfoCard(
                          'Uptime',
                          '${(_healthData!['uptime'] ?? 0).toStringAsFixed(0)}s',
                          icon: Icons.timer,
                        ),
                        const SizedBox(height: 8),
                        _buildInfoCard(
                          'Response Time',
                          _healthData!['api']?['responseTime'] ?? 'N/A',
                          icon: Icons.speed,
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Database Health
                      if (_dbHealthData != null) ...[
                        const Text(
                          'Database Health',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoCard(
                          'Status',
                          _dbHealthData!['status'] ?? 'Unknown',
                          valueColor: _getStatusColor(_dbHealthData!['status']),
                          icon: Icons.storage,
                        ),
                        const SizedBox(height: 8),
                        _buildInfoCard(
                          'Connection',
                          _dbHealthData!['connected'] == true ? 'Connected' : 'Disconnected',
                          valueColor: _dbHealthData!['connected'] == true
                              ? Colors.green
                              : Colors.red,
                          icon: Icons.link,
                        ),
                        const SizedBox(height: 8),
                        _buildInfoCard(
                          'Latency',
                          _dbHealthData!['latency'] ?? 'N/A',
                          icon: Icons.network_ping,
                        ),
                        const SizedBox(height: 8),
                        if (_dbHealthData!['server'] != null) ...[
                          _buildInfoCard(
                            'Server',
                            _dbHealthData!['server']['ServerName'] ?? 'N/A',
                            icon: Icons.dns,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoCard(
                            'Database',
                            _dbHealthData!['server']['DatabaseName'] ?? 'N/A',
                            icon: Icons.storage,
                          ),
                          const SizedBox(height: 8),
                        ],
                        _buildInfoCard(
                          'Tables',
                          _dbHealthData!['tableCount']?.toString() ?? 'N/A',
                          icon: Icons.table_chart,
                        ),
                        const SizedBox(height: 24),

                        // Connection Pool Stats
                        if (_dbHealthData!['poolStats'] != null) ...[
                          const Text(
                            'Connection Pool',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Size:',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    Text(
                                      '${_dbHealthData!['poolStats']['size'] ?? 0}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(color: Colors.white24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Available:',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    Text(
                                      '${_dbHealthData!['poolStats']['available'] ?? 0}',
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(color: Colors.white24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Borrowed:',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    Text(
                                      '${_dbHealthData!['poolStats']['borrowed'] ?? 0}',
                                      style: const TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(color: Colors.white24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Pending:',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    Text(
                                      '${_dbHealthData!['poolStats']['pending'] ?? 0}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ],

                      // Tables List
                      if (_tablesData != null && _tablesData!['status'] == 'success') ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Database Tables',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B5CF6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${_tablesData!['count']} tables',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...(_tablesData!['tables'] as List).map((table) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  table['TABLE_TYPE'] == 'VIEW'
                                      ? Icons.visibility
                                      : Icons.table_rows,
                                  color: const Color(0xFF8B5CF6),
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        table['TABLE_NAME'] ?? 'Unknown',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${table['TABLE_SCHEMA']}.${table['TABLE_NAME']}',
                                        style: const TextStyle(
                                          color: Colors.white54,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: table['TABLE_TYPE'] == 'VIEW'
                                        ? Colors.blue.withOpacity(0.2)
                                        : Colors.purple.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    table['TABLE_TYPE'] ?? 'TABLE',
                                    style: TextStyle(
                                      color: table['TABLE_TYPE'] == 'VIEW'
                                          ? Colors.blue
                                          : Colors.purple,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ],
                  ),
                ),
    );
  }
}
