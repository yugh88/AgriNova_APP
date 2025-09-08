import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:math';

void main() {
  runApp(CropMonitorApp());
}

class CropMonitorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Crop Monitor',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  File? _selectedImage;
  double _riskScore = 0.0;
  String _healthStatus = 'Unknown';
  bool _isAnalyzing = false;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  
  final Random _random = Random();
  
  // Sample sensor data
  Map<String, dynamic> _sensorData = {
    'soil_moisture': 58.2,
    'temperature': 28.5,
    'humidity': 65.8,
    'ph_level': 6.8,
    'light_intensity': 45000,
    'wind_speed': 2.3,
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut)
    );
    _animationController.repeat(reverse: true);
    
    // Simulate real-time data updates
    _startDataUpdates();
  }

  void _startDataUpdates() {
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _sensorData['soil_moisture'] = 40 + _random.nextDouble() * 40;
          _sensorData['temperature'] = 20 + _random.nextDouble() * 20;
          _sensorData['humidity'] = 40 + _random.nextDouble() * 40;
        });
        _startDataUpdates();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Row(
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Icon(Icons.agriculture, color: Colors.white, size: 28),
                );
              },
            ),
            SizedBox(width: 12),
            Text('AI Crop Monitor', 
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorDataCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.sensors, color: Colors.blue[700], size: 24),
                SizedBox(width: 8),
                Text(
                  'IoT Sensor Data',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[700]),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: 2.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildSensorTile('Soil Moisture', '${_sensorData['soil_moisture']?.toStringAsFixed(1)}%', Icons.water_drop, Colors.blue, _getSensorStatus(_sensorData['soil_moisture'], 40, 70)),
                _buildSensorTile('Temperature', '${_sensorData['temperature']?.toStringAsFixed(1)}°C', Icons.thermostat, Colors.orange, _getSensorStatus(_sensorData['temperature'], 20, 35)),
                _buildSensorTile('Humidity', '${_sensorData['humidity']?.toStringAsFixed(1)}%', Icons.opacity, Colors.cyan, _getSensorStatus(_sensorData['humidity'], 50, 80)),
                _buildSensorTile('pH Level', '${_sensorData['ph_level']?.toStringAsFixed(1)}', Icons.science, Colors.purple, _getSensorStatus(_sensorData['ph_level'], 6.0, 7.5)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorTile(String label, String value, IconData icon, Color color, String status) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _getStatusColor(status),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(status, style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildAIInsightsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology, color: Colors.purple[700], size: 24),
                SizedBox(width: 8),
                Text(
                  'AI Analysis Results',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple[700]),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (_healthStatus != 'Unknown') ...[
              Row(
                children: [
                  Expanded(
                    child: _buildAnalysisMetric(
                      'Health Status',
                      _healthStatus,
                      _getHealthIcon(),
                      _getHealthColor(),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildAnalysisMetric(
                      'Risk Score',
                      '${(_riskScore * 100).toStringAsFixed(1)}%',
                      Icons.warning,
                      _getRiskColor(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getHealthColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _getHealthColor().withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(_getHealthIcon(), color: _getHealthColor(), size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('AI Recommendation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          SizedBox(height: 4),
                          Text(_getRecommendation(), style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(Icons.image_search, size: 48, color: Colors.grey[400]),
                    SizedBox(height: 8),
                    Text('Upload crop image for AI analysis', style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisMetric(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildRecommendationsCard() {
    List<Map<String, dynamic>> recommendations = [
      {'icon': '💧', 'text': 'Maintain soil moisture above 60%', 'priority': 'high'},
      {'icon': '🌡️', 'text': 'Monitor temperature during midday hours', 'priority': 'medium'},
      {'icon': '🌿', 'text': 'Consider nutrient supplementation', 'priority': 'low'},
      {'icon': '🔍', 'text': 'Schedule pest inspection next week', 'priority': 'medium'},
    ];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.amber[700], size: 24),
                SizedBox(width: 8),
                Text(
                  'Smart Recommendations',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber[700]),
                ),
              ],
            ),
            SizedBox(height: 16),
            ...recommendations.map((rec) => _buildRecommendationItem(rec['icon'], rec['text'], rec['priority'])).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationItem(String emoji, String text, String priority) {
    Color priorityColor = priority == 'high' ? Colors.red : priority == 'medium' ? Colors.orange : Colors.green;
    
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: priorityColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: priorityColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Text(emoji, style: TextStyle(fontSize: 24)),
          SizedBox(width: 12),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 14)),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: priorityColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              priority.toUpperCase(),
              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showImageSourceDialog() async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select Image Source', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                    icon: Icon(Icons.camera_alt),
                    label: Text('Camera'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                    icon: Icon(Icons.photo_library),
                    label: Text('Gallery'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _riskScore = 0.0;
          _healthStatus = 'Unknown';
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Image selected successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _analyzeImage() async {
    setState(() {
      _isAnalyzing = true;
    });

    // Simulate AI processing time
    await Future.delayed(Duration(seconds: 3));

    // Generate realistic results based on image analysis simulation
    final random = _random.nextDouble();
    setState(() {
      _riskScore = (random * 0.7 + 0.1).clamp(0.0, 1.0); // 10-80% risk
      
      if (_riskScore < 0.3) {
        _healthStatus = 'Healthy';
      } else if (_riskScore < 0.6) {
        _healthStatus = 'Moderate Stress';
      } else {
        _healthStatus = 'High Stress';
      }
      
      _isAnalyzing = false;
    });

    // Show results dialog
    _showAnalysisResultDialog();
  }

  void _showAnalysisResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(_getHealthIcon(), color: _getHealthColor(), size: 28),
            SizedBox(width: 12),
            Text('Analysis Complete'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Health Status: $_healthStatus',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Risk Score: ${(_riskScore * 100).toStringAsFixed(1)}%'),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getHealthColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _getDetailedRecommendation(),
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showDetailedReport();
            },
            child: Text('View Report'),
          ),
        ],
      ),
    );
  }

  void _showDetailedReport() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(20),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Detailed Analysis Report',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              _buildReportSection('Health Assessment', [
                'Overall Status: $_healthStatus',
                'Risk Level: ${(_riskScore * 100).toStringAsFixed(1)}%',
                'Confidence: ${(85 + _random.nextDouble() * 10).toStringAsFixed(1)}%',
              ]),
              _buildReportSection('Environmental Factors', [
                'Soil Moisture: ${_sensorData['soil_moisture']?.toStringAsFixed(1)}%',
                'Temperature: ${_sensorData['temperature']?.toStringAsFixed(1)}°C',
                'Humidity: ${_sensorData['humidity']?.toStringAsFixed(1)}%',
                'pH Level: ${_sensorData['ph_level']?.toStringAsFixed(1)}',
              ]),
              _buildReportSection('Recommendations', [
                _getDetailedRecommendation(),
                'Schedule follow-up analysis in 7 days',
                'Monitor soil conditions closely',
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportSection(String title, List<String> items) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          ...items.map((item) => Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Text('• $item', style: TextStyle(fontSize: 14)),
          )).toList(),
        ],
      ),
    );
  }

  Future<void> _refreshData() async {
    setState(() {
      // Simulate data refresh
      _sensorData['soil_moisture'] = 40 + _random.nextDouble() * 40;
      _sensorData['temperature'] = 20 + _random.nextDouble() * 20;
      _sensorData['humidity'] = 40 + _random.nextDouble() * 40;
    });
  }

  String _getSensorStatus(double? value, double min, double max) {
    if (value == null) return 'N/A';
    if (value < min) return 'LOW';
    if (value > max) return 'HIGH';
    return 'OK';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'OK': return Colors.green;
      case 'LOW': return Colors.orange;
      case 'HIGH': return Colors.red;
      default: return Colors.grey;
    }
  }

  IconData _getHealthIcon() {
    switch (_healthStatus) {
      case 'Healthy': return Icons.check_circle;
      case 'Moderate Stress': return Icons.warning;
      case 'High Stress': return Icons.error;
      default: return Icons.help;
    }
  }

  Color _getHealthColor() {
    switch (_healthStatus) {
      case 'Healthy': return Colors.green;
      case 'Moderate Stress': return Colors.orange;
      case 'High Stress': return Colors.red;
      default: return Colors.grey;
    }
  }

  Color _getRiskColor() {
    if (_riskScore < 0.3) return Colors.green;
    if (_riskScore < 0.6) return Colors.orange;
    return Colors.red;
  }

  String _getRecommendation() {
    if (_healthStatus == 'Healthy') {
      return 'Maintain current care routine. Crops are in excellent condition.';
    } else if (_healthStatus == 'Moderate Stress') {
      return 'Monitor closely and adjust irrigation. Consider nutrient supplementation.';
    } else {
      return 'Immediate attention required! Check irrigation, pests, and soil conditions.';
    }
  }

  String _getDetailedRecommendation() {
    List<String> recommendations = [];
    
    if (_sensorData['soil_moisture'] < 40) {
      recommendations.add('Increase irrigation - soil moisture is low');
    }
    if (_sensorData['temperature'] > 35) {
      recommendations.add('Provide shade during peak hours - temperature is high');
    }
    if (_riskScore > 0.6) {
      recommendations.add('Consider pest inspection and disease prevention measures');
    }
    
    return recommendations.isEmpty 
        ? 'Continue current management practices. Crops are in good condition.'
        : recommendations.join('. ');
  }
}