import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Replace these two values with your details from Lab 01.
const String studentName = 'JASMINE WONG MING MING';
const String studentId = 'BCS24090045';

void main() {
  runApp(const Lab02App());
}

class Lab02App extends StatelessWidget {
  const Lab02App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CSS3344 Lab 02',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF455BB6),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F8FE),
      ),
      home: const Lab02Page(),
    );
  }
}

class Lab02Page extends StatefulWidget {
  const Lab02Page({super.key});

  @override
  State<Lab02Page> createState() => _Lab02PageState();
}

class _Lab02PageState extends State<Lab02Page> {
  DateTime? _selectedDate;
  String _selectedRole = 'Student';
  static const List<String> _roles = ['Student', 'Developer', 'Designer'];

  String get _dateLabel {
    if (_selectedDate == null) return 'Not selected';
    final date = _selectedDate!;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  Future<void> _selectMaterialDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && mounted) {
      setState(() => _selectedDate = picked);
    }
  }

  void _showCupertinoDatePicker() {
    final DateTime now = DateTime.now();
    showCupertinoModalPopup<void>(
      context: context,
      builder: (popupContext) => Container(
        height: 300,
        color: CupertinoColors.systemBackground.resolveFrom(popupContext),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: CupertinoButton(
                  onPressed: () => Navigator.of(popupContext).pop(),
                  child: const Text('Done'),
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _selectedDate ?? now,
                  minimumDate: DateTime(1950),
                  maximumDate: now,
                  onDateTimeChanged: (DateTime date) {
                    setState(() => _selectedDate = date);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCupertinoRolePicker() {
    final controller = FixedExtentScrollController(
      initialItem: _roles.indexOf(_selectedRole),
    );
    showCupertinoModalPopup<void>(
      context: context,
      builder: (popupContext) => Container(
        height: 260,
        color: CupertinoColors.systemBackground.resolveFrom(popupContext),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: CupertinoButton(
                  onPressed: () => Navigator.of(popupContext).pop(),
                  child: const Text('Done'),
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  scrollController: controller,
                  itemExtent: 36,
                  onSelectedItemChanged: (index) {
                    setState(() => _selectedRole = _roles[index]);
                  },
                  children: _roles
                      .map((role) => Center(child: Text(role)))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    ).whenComplete(controller.dispose);
  }

  Widget _buildPickers() {
    return PickerSection(
      selectedDate: _dateLabel,
      selectedRole: _selectedRole,
      roles: _roles,
      onMaterialDatePressed: _selectMaterialDate,
      onCupertinoDatePressed: _showCupertinoDatePicker,
      onRoleChanged: (value) {
        if (value != null) setState(() => _selectedRole = value);
      },
      onCupertinoRolePressed: _showCupertinoRolePicker,
    );
  }

  Widget _buildPortraitView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const StudentDetailsSection(name: studentName, studentId: studentId),
        const SizedBox(height: 12),
        const TitleSection(
          name: 'Oeschinen Lake',
          location: 'Kandersteg, Switzerland',
          starCount: 41,
        ),
        const ImageSection(imagePath: 'assets/images/lake.jpg'),
        const SizedBox(height: 12),
        const ActionButtonsSection(),
        const TextSection(),
        const SizedBox(height: 12),
        _buildPickers(),
      ],
    );
  }

  Widget _buildLandscapeView() {
    return Row(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(12),
            children: [
              StudentDetailsSection(name: studentName, studentId: studentId),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              const TitleSection(
                name: 'Oeschinen Lake',
                location: 'Kandersteg, Switzerland',
                starCount: 41,
              ),
              const ImageSection(imagePath: 'assets/images/lake.jpg'),
              const SizedBox(height: 12),
              const ActionButtonsSection(),
              const TextSection(),
              const SizedBox(height: 12),
              _buildPickers(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSS3344 Mobile App Dev - Lab 02'),
        backgroundColor: const Color(0xFFDDE4FF),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _buildPortraitView()
              : _buildLandscapeView();
        },
      ),
    );
  }
}

class StudentDetailsSection extends StatelessWidget {
  final String name;
  final String studentId;

  const StudentDetailsSection({
    super.key,
    required this.name,
    required this.studentId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF455BB6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 39,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Color(0xFF455BB6), size: 48),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text('Student ID: $studentId',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70)),
          const Divider(height: 26, color: Colors.white38),
          const Text(
            'CSS3344 Mobile Application Development\nLab 02: UI Fundamentals and Layout',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  final String name;
  final String location;
  final int starCount;

  const TitleSection({
    super.key,
    required this.name,
    required this.location,
    required this.starCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(location, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
          Icon(Icons.star, color: Colors.red[500]),
          const SizedBox(width: 4),
          Text('$starCount'),
        ],
      ),
    );
  }
}

class ImageSection extends StatelessWidget {
  final String imagePath;
  const ImageSection({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: const Color(0xFFDCEAF7),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.landscape, size: 70, color: Color(0xFF455BB6)),
                Text('Add an image at assets/images/lake.jpg',
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ActionButtonsSection extends StatelessWidget {
  const ActionButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    Widget action(IconData icon, String label) {
      return Expanded(
        child: TextButton(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$label tapped')),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon),
              const SizedBox(height: 4),
              Text(label),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        action(Icons.call, 'CALL'),
        action(Icons.near_me, 'ROUTE'),
        action(Icons.share, 'SHARE'),
      ],
    );
  }
}

class TextSection extends StatelessWidget {
  const TextSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(12),
      child: Text(
        'This screen demonstrates reusable Flutter widgets, responsive portrait '
            'and landscape layouts, and Material and Cupertino pickers.',
        style: TextStyle(height: 1.5),
      ),
    );
  }
}

class PickerSection extends StatelessWidget {
  final String selectedDate;
  final String selectedRole;
  final List<String> roles;
  final VoidCallback onMaterialDatePressed;
  final VoidCallback onCupertinoDatePressed;
  final ValueChanged<String?> onRoleChanged;
  final VoidCallback onCupertinoRolePressed;

  const PickerSection({
    super.key,
    required this.selectedDate,
    required this.selectedRole,
    required this.roles,
    required this.onMaterialDatePressed,
    required this.onCupertinoDatePressed,
    required this.onRoleChanged,
    required this.onCupertinoRolePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Interactive Pickers (Lab 2.2)',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const Divider(height: 24),
            Text('Selected date: $selectedDate'),
            const SizedBox(height: 4),
            Text('Selected role: $selectedRole'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton(
                  onPressed: onMaterialDatePressed,
                  child: const Text('Material Date Picker'),
                ),
                OutlinedButton(
                  onPressed: onCupertinoDatePressed,
                  child: const Text('Cupertino Date Picker'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Material Dropdown'),
            DropdownButton<String>(
              value: selectedRole,
              isExpanded: true,
              items: roles
                  .map((role) => DropdownMenuItem<String>(
                value: role,
                child: Text(role),
              ))
                  .toList(),
              onChanged: onRoleChanged,
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: onCupertinoRolePressed,
              child: const Text('Cupertino Wheel Picker'),
            ),
          ],
        ),
      ),
    );
  }
}
