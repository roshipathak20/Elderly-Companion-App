import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

const Color kPrimaryBlue = Color(0xFF87CEFA); // sky blue
const Color kSoftGreen = Color(0xFFCDECCB);   // soft green for help card

void main() {
  runApp(const ElderlyCareApp());
}

class ElderlyCareApp extends StatelessWidget {
  const ElderlyCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elderly Care',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7FBFF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: kPrimaryBlue,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: kPrimaryBlue,
          foregroundColor: Colors.white,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        // your Flutter version wants TabBarThemeData
        tabBarTheme: const TabBarThemeData(
          labelColor: Colors.white,
          unselectedLabelColor: Color(0xFFE0F3FF),
          indicatorColor: Colors.white,
        ),
      ),
      home: const MainTabs(),
    );
  }
}

/// Simple model for reminders
class Reminder {
  final String title;
  final DateTime dateTime;

  Reminder({required this.title, required this.dateTime});
}

// ======================= MAIN TABS =======================

class MainTabs extends StatelessWidget {
  const MainTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryBlue,
          centerTitle: true,
          title: const Text(
            'Elderly Care',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Georgia',      // serif look
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          bottom: const TabBar(


          isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.medication), text: 'Reminders'),
              Tab(icon: Icon(Icons.lightbulb_outline), text: 'Tips'),
              Tab(icon: Icon(Icons.settings), text: 'Settings'),
              Tab(icon: Icon(Icons.chat_bubble_outline), text: 'Help'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            HomeTab(),
            RemindersTab(),
            TipsTab(),
            SettingsTab(),
            HelpTab(),
          ],
        ),
      ),
    );
  }
}

// ======================= HOME TAB =======================

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String? _userName;
  String? _primaryContact;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName');
      _primaryContact = prefs.getString('emergencyContact1');
      _loading = false;
    });
  }

  Future<void> _callEmergency() async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Emergency calling only works in the phone app.'),
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final number =
    prefs.getString('emergencyContact1')?.trim().isNotEmpty == true
        ? prefs.getString('emergencyContact1')!.trim()
        : '112'; // default

    final uri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open dialer.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // We use a Scaffold here to get a floatingActionButton at the top right
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: FloatingActionButton.extended(
          heroTag: 'emergencyFab',
          onPressed: _callEmergency,
          backgroundColor: Colors.red.shade400.withOpacity(0.9),
          icon: const Icon(Icons.emergency, size: 24),
          label: const Text(
            'Emergency',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/elderly_bg.webp'),
            fit: BoxFit.cover,
            colorFilter:
            ColorFilter.mode(Colors.black45, BlendMode.darken),
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: kPrimaryBlue, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  const Text(
                  'Elderly Care',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia',
                  ),
                ),
                  const SizedBox(height: 4),
                  const Text(
                    'Care that feels like family 💙',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_loading)
                const Center(child: CircularProgressIndicator())
          else
          Text(
          _userName == null || _userName!.isEmpty
          ? 'Please fill in your personal information in setting.'
              : 'Hello, $_userName 👋',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          _primaryContact == null || _primaryContact!.isEmpty
              ? 'The Emergency button will use 112 when clicked.'
              : 'The Emergency button will call: $_primaryContact',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ======================= REMINDERS TAB =======================

class RemindersTab extends StatefulWidget {
  const RemindersTab({super.key});

  @override
  State<RemindersTab> createState() => _RemindersTabState();
}

class _RemindersTabState extends State<RemindersTab> {
  final TextEditingController _titleController = TextEditingController();
  DateTime? _selectedDateTime;
  final List<Reminder> _reminders = [];

  Future<void> _pickDateTime() async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );
    if (pickedTime == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  void _addReminder() {
    final text = _titleController.text.trim();
    if (text.isEmpty || _selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter event with Date and Time.'),
        ),
      );
      return;
    }

    setState(() {
      _reminders.add(Reminder(title: text, dateTime: _selectedDateTime!));
      _titleController.clear();
      _selectedDateTime = null;
    });
  }

  void _deleteReminder(int index) {
    setState(() {
      _reminders.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd MMM yyyy, HH:mm');

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // small calendar image header
            Row(
              children: [
                Image.asset(
                  'assets/images/reminder_calendar.png',
                  height: 70,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Medicine & Task Reminders',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 18),
              decoration: const InputDecoration(
                labelText: 'What do you want to remember?',
                labelStyle: TextStyle(fontSize: 16),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDateTime == null
                        ? 'No date & time selected'
                        : 'When: ${fmt.format(_selectedDateTime!)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: _pickDateTime,
                  child: const Text('Pick date & time'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addReminder,
                child: const Text(
                  'Add Reminder',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _reminders.isEmpty
                  ? const Center(
                child: Text(
                  'No reminders yet.\nAdd medicines, doctor visits, or other tasks.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: _reminders.length,
                itemBuilder: (context, index) {
                  final r = _reminders[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.alarm),
                      title: Text(
                        r.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        fmt.format(r.dateTime),
                        style: const TextStyle(fontSize: 14),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete,
                            color: Colors.redAccent),
                        onPressed: () => _deleteReminder(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================= TIPS TAB =======================

class TipsTab extends StatelessWidget {
  const TipsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tips = [
      'Drink enough water throughout the day.',
      'Take gentle walks or stretch every few hours.',
      'Keep medicines together in a visible, safe place.',
      'Use night lights to avoid falls.',
      'Keep emergency numbers near the phone.',
      'Eat small, regular meals with fruits and vegetables.',
      'Rest when you feel tired and sleep enough at night.',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: tips.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              children: [
                Image.asset(
                  'assets/images/tips_helpful.png',
                  height: 120,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Helpful Health Tips',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            );
          }
          final tip = tips[index - 1];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                '• $tip',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ======================= SETTINGS TAB =======================

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _contact1Controller = TextEditingController();
  final _contact2Controller = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _nameController.text = prefs.getString('userName') ?? '';
    _phoneController.text = prefs.getString('userPhone') ?? '';
    _contact1Controller.text = prefs.getString('emergencyContact1') ?? '';
    _contact2Controller.text = prefs.getString('emergencyContact2') ?? '';
    setState(() {
      _loading = false;
    });
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', _nameController.text.trim());
    await prefs.setString('userPhone', _phoneController.text.trim());
    await prefs.setString(
        'emergencyContact1', _contact1Controller.text.trim());
    await prefs.setString(
        'emergencyContact2', _contact2Controller.text.trim());

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile & contacts saved')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Profile',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Your name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Your phone number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Emergency Contacts (Close Person)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _contact1Controller,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Primary contact phone',
                helperText: 'If empty, app uses 112 as default emergency number.',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _contact2Controller,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Secondary contact phone (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================= HELP TAB =======================

class HelpTab extends StatefulWidget {
  const HelpTab({super.key});

  @override
  State<HelpTab> createState() => _HelpTabState();
}

class _HelpTabState extends State<HelpTab> {
  final TextEditingController _questionController = TextEditingController();

  void _sendQuestion() {
    final text = _questionController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please type your question first.')),
      );
      return;
    }
    _questionController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Thank you! A support person will contact you.\n'
              'You can also call 123456788 or email elder@gmail.com.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final faqs = [
      'What is the Emergency button?\nIt calls your saved loved one (if set) or 112 by default.',
      'How do I change my name or contacts?\nUse the Settings tab and press Save.',
      'How do reminders work?\nAdd a title, pick date & time, then tap "Add Reminder".',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(
              'assets/images/help_support.png',
              height: 140,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kSoftGreen,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Need help?\n\n'
                    'Customer service:\n'
                    '📞 123456788\n'
                    '✉️ elder@gmail.com',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Common questions',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            ...faqs.map(
                  (q) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(q, style: const TextStyle(fontSize: 16)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Ask your own question',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Ask your question and tap Send:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _questionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Type your question here...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _sendQuestion,
                  icon: const Icon(Icons.send),
                  label: const Text('Send'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(80, 48),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
