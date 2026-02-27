import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:suno_samjho/providers/profile_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CrisisSupportPage extends StatefulWidget {
  const CrisisSupportPage({super.key});

  @override
  State<CrisisSupportPage> createState() => _CrisisSupportPageState();
}

class _CrisisSupportPageState extends State<CrisisSupportPage> {
  List<dynamic> _helplines = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHelplines();
  }

  Future<void> _loadHelplines() async {
    try {
      final String response = await rootBundle.loadString('assets/general_info.json');
      final data = json.decode(response);
      setState(() {
        _helplines = data['crisisHelplines'] ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error, perhaps show a message
    }
  }

  Future<void> _makeCall(String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to make call')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final userPhone = profileProvider.profile?.phone ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crisis Support'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Reassuring message
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Text(
                      'You are not alone. Help is available. Please reach out to one of the resources below or contact someone you trust.',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  // Helplines section
                  const Text(
                    'Helplines',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  ..._helplines.map((helpline) => Card(
                        margin: const EdgeInsets.only(bottom: 12.0),
                        child: ListTile(
                          title: Text(helpline['name']),
                          subtitle: Text(helpline['description']),
                          trailing: ElevatedButton(
                            onPressed: () => _makeCall(helpline['phone']),
                            child: const Text('Call'),
                          ),
                        ),
                      )),
                  const SizedBox(height: 24.0),
                  // Trusted contact section
                  const Text(
                    'Contact a Trusted Person',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  if (userPhone.isNotEmpty)
                    Card(
                      child: ListTile(
                        title: const Text('Your Emergency Contact'),
                        subtitle: Text(userPhone),
                        trailing: ElevatedButton(
                          onPressed: () => _makeCall(userPhone),
                          child: const Text('Call'),
                        ),
                      ),
                    ),
                  Card(
                    child: ListTile(
                      title: const Text('Enter Custom Number'),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final controller = TextEditingController();
                          final phone = await showDialog<String>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Enter Phone Number'),
                              content: TextField(
                                controller: controller,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(hintText: 'Phone number'),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(controller.text),
                                  child: const Text('Call'),
                                ),
                              ],
                            ),
                          );
                          if (phone != null && phone.isNotEmpty) {
                            _makeCall(phone);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
