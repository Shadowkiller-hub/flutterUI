import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Settings state
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _darkMode = false;
  String _language = 'English';
  double _fontSize = 1.0;

  // Bus app specific settings
  bool _showLiveTraffic = true;
  bool _showNearbyStops = true;
  bool _showFaresInSearch = true;
  String _distanceUnit = 'Kilometers';
  String _fareDisplay = 'Indian Rupee (₹)';
  int _refreshInterval = 30;
  bool _autoRefreshEnabled = true;
  bool _vibrationFeedback = true;
  bool _soundFeedback = false;
  bool _showAccessibleRoutes = false;
  bool _showLessWalking = false;
  bool _showFavoriteRoutesFirst = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Settings'),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bus Route Preferences section
            _buildSectionTitle('Route Preferences'),
            SwitchListTile(
              title: const Text('Show Live Traffic'),
              subtitle: const Text('Display traffic conditions on the map'),
              value: _showLiveTraffic,
              activeColor: Colors.amber,
              onChanged: (value) {
                setState(() {
                  _showLiveTraffic = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Show Nearby Bus Stops'),
              subtitle: const Text('Display bus stops near your location'),
              value: _showNearbyStops,
              activeColor: Colors.amber,
              onChanged: (value) {
                setState(() {
                  _showNearbyStops = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Show Accessible Routes'),
              subtitle: const Text('Prioritize wheelchair accessible routes'),
              value: _showAccessibleRoutes,
              activeColor: Colors.amber,
              onChanged: (value) {
                setState(() {
                  _showAccessibleRoutes = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Less Walking Routes'),
              subtitle: const Text(
                'Prefer routes with minimal walking distance',
              ),
              value: _showLessWalking,
              activeColor: Colors.amber,
              onChanged: (value) {
                setState(() {
                  _showLessWalking = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Favorite Routes First'),
              subtitle: const Text(
                'Show your favorite routes at the top of search results',
              ),
              value: _showFavoriteRoutesFirst,
              activeColor: Colors.amber,
              onChanged: (value) {
                setState(() {
                  _showFavoriteRoutesFirst = value;
                });
              },
            ),
            const Divider(),

            // Display Options section
            _buildSectionTitle('Display Options'),
            ListTile(
              title: const Text('Distance Unit'),
              subtitle: Text(_distanceUnit),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showDistanceUnitDialog();
              },
            ),
            ListTile(
              title: const Text('Fare Display'),
              subtitle: Text(_fareDisplay),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showFareDisplayDialog();
              },
            ),
            SwitchListTile(
              title: const Text('Show Fares in Search Results'),
              subtitle: const Text(
                'Display ticket prices in route search results',
              ),
              value: _showFaresInSearch,
              activeColor: Colors.amber,
              onChanged: (value) {
                setState(() {
                  _showFaresInSearch = value;
                });
              },
            ),
            const Divider(),

            // Bus Tracking section
            _buildSectionTitle('Bus Tracking'),
            ListTile(
              title: const Text('Refresh Interval'),
              subtitle: Text('$_refreshInterval seconds'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showRefreshIntervalDialog();
              },
            ),
            SwitchListTile(
              title: const Text('Auto Refresh'),
              subtitle: const Text('Automatically update bus locations'),
              value: _autoRefreshEnabled,
              activeColor: Colors.amber,
              onChanged: (value) {
                setState(() {
                  _autoRefreshEnabled = value;
                });
              },
            ),
            const Divider(),

            // Notifications section
            _buildSectionTitle('Notifications'),
            SwitchListTile(
              title: const Text('Push Notifications'),
              subtitle: const Text(
                'Receive alerts about bus arrivals and promotions',
              ),
              value: _notificationsEnabled,
              activeColor: Colors.amber,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
            ListTile(
              title: const Text('Notification Preferences'),
              subtitle: const Text('Choose which notifications to receive'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showNotificationPreferencesDialog();
              },
            ),
            const Divider(),

            // Accessibility section
            _buildSectionTitle('Accessibility'),
            // Font size slider
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Text Size'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('A', style: TextStyle(fontSize: 14)),
                      Expanded(
                        child: Slider(
                          value: _fontSize,
                          min: 0.8,
                          max: 1.2,
                          divisions: 4,
                          activeColor: Colors.amber,
                          onChanged: (value) {
                            setState(() {
                              _fontSize = value;
                            });
                          },
                        ),
                      ),
                      const Text('A', style: TextStyle(fontSize: 24)),
                    ],
                  ),
                ],
              ),
            ),
            SwitchListTile(
              title: const Text('Vibration Feedback'),
              subtitle: const Text('Vibrate when actions are performed'),
              value: _vibrationFeedback,
              activeColor: Colors.amber,
              onChanged: (value) {
                setState(() {
                  _vibrationFeedback = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Sound Feedback'),
              subtitle: const Text('Play sounds for notifications and alerts'),
              value: _soundFeedback,
              activeColor: Colors.amber,
              onChanged: (value) {
                setState(() {
                  _soundFeedback = value;
                });
              },
            ),
            const Divider(),

            // Location section
            _buildSectionTitle('Location'),
            SwitchListTile(
              title: const Text('Location Services'),
              subtitle: const Text(
                'Allow app to access your location for better service',
              ),
              value: _locationEnabled,
              activeColor: Colors.amber,
              onChanged: (value) {
                setState(() {
                  _locationEnabled = value;
                });
              },
            ),
            const Divider(),

            // Appearance section
            _buildSectionTitle('Appearance'),
            SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Use dark theme for the app'),
              value: _darkMode,
              activeColor: Colors.amber,
              onChanged: (value) {
                setState(() {
                  _darkMode = value;
                });
                // Show message that this feature is coming soon
                if (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Dark mode coming soon!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
            const Divider(),

            // Language section
            _buildSectionTitle('Language'),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'English',
              groupValue: _language,
              activeColor: Colors.amber,
              onChanged: (value) {
                setState(() {
                  _language = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Hindi'),
              value: 'Hindi',
              groupValue: _language,
              activeColor: Colors.amber,
              onChanged: (value) {
                setState(() {
                  _language = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Kannada'),
              value: 'Kannada',
              groupValue: _language,
              activeColor: Colors.amber,
              onChanged: (value) {
                setState(() {
                  _language = value!;
                });
              },
            ),
            const Divider(),

            // Data & Storage section
            _buildSectionTitle('Data & Storage'),
            ListTile(
              title: const Text('Clear Cache'),
              subtitle: const Text('Free up storage space'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showClearCacheDialog();
              },
            ),
            ListTile(
              title: const Text('Download Bus Routes'),
              subtitle: const Text('Save routes for offline use'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showDownloadRoutesDialog();
              },
            ),
            const Divider(),

            // About section
            _buildSectionTitle('About'),
            ListTile(
              title: const Text('Terms of Service'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to terms of service
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Terms of Service')),
                );
              },
            ),
            ListTile(
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to privacy policy
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Privacy Policy')));
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear Cache'),
            content: const Text(
              'This will clear all cached data. Are you sure?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Show confirmation
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cache cleared successfully')),
                  );
                },
                child: const Text('CLEAR'),
              ),
            ],
          ),
    );
  }

  void _showDistanceUnitDialog() {
    showDialog(
      context: context,
      builder:
          (context) => SimpleDialog(
            title: const Text('Distance Unit'),
            children: [
              RadioListTile<String>(
                title: const Text('Kilometers'),
                value: 'Kilometers',
                groupValue: _distanceUnit,
                onChanged: (value) {
                  setState(() {
                    _distanceUnit = value!;
                  });
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<String>(
                title: const Text('Miles'),
                value: 'Miles',
                groupValue: _distanceUnit,
                onChanged: (value) {
                  setState(() {
                    _distanceUnit = value!;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
    );
  }

  void _showFareDisplayDialog() {
    showDialog(
      context: context,
      builder:
          (context) => SimpleDialog(
            title: const Text('Fare Display'),
            children: [
              RadioListTile<String>(
                title: const Text('Indian Rupee (₹)'),
                value: 'Indian Rupee (₹)',
                groupValue: _fareDisplay,
                onChanged: (value) {
                  setState(() {
                    _fareDisplay = value!;
                  });
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<String>(
                title: const Text('US Dollar (\$)'),
                value: 'US Dollar (\$)',
                groupValue: _fareDisplay,
                onChanged: (value) {
                  setState(() {
                    _fareDisplay = value!;
                  });
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<String>(
                title: const Text('Euro (€)'),
                value: 'Euro (€)',
                groupValue: _fareDisplay,
                onChanged: (value) {
                  setState(() {
                    _fareDisplay = value!;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
    );
  }

  void _showRefreshIntervalDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Refresh Interval'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select how often to refresh bus locations (in seconds)',
                ),
                const SizedBox(height: 16),
                Slider(
                  value: _refreshInterval.toDouble(),
                  min: 10,
                  max: 60,
                  divisions: 5,
                  label: _refreshInterval.toString(),
                  activeColor: Colors.amber,
                  onChanged: (value) {
                    setState(() {
                      _refreshInterval = value.toInt();
                    });
                  },
                ),
                Text('${_refreshInterval.toString()} seconds'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('SAVE'),
              ),
            ],
          ),
    );
  }

  void _showNotificationPreferencesDialog() {
    bool busDelays = true;
    bool routeChanges = true;
    bool promotions = false;
    bool fareUpdates = true;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: const Text('Notification Preferences'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CheckboxListTile(
                        title: const Text('Bus Delays'),
                        value: busDelays,
                        activeColor: Colors.amber,
                        onChanged: (value) {
                          setState(() {
                            busDelays = value!;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Route Changes'),
                        value: routeChanges,
                        activeColor: Colors.amber,
                        onChanged: (value) {
                          setState(() {
                            routeChanges = value!;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Promotions & Offers'),
                        value: promotions,
                        activeColor: Colors.amber,
                        onChanged: (value) {
                          setState(() {
                            promotions = value!;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Fare Updates'),
                        value: fareUpdates,
                        activeColor: Colors.amber,
                        onChanged: (value) {
                          setState(() {
                            fareUpdates = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('CANCEL'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Notification preferences saved'),
                          ),
                        );
                      },
                      child: const Text('SAVE'),
                    ),
                  ],
                ),
          ),
    );
  }

  void _showDownloadRoutesDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Download Bus Routes'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Select routes to download for offline use:'),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.directions_bus),
                  title: const Text('Popular Routes'),
                  subtitle: const Text('12 MB'),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                    child: const Text('DOWNLOAD'),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.directions_bus),
                  title: const Text('All Bangalore Routes'),
                  subtitle: const Text('45 MB'),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                    child: const Text('DOWNLOAD'),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('CLOSE'),
              ),
            ],
          ),
    );
  }
}
