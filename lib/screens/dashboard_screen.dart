import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  final List<_DashboardTile> _tiles = const [
    _DashboardTile(title: "Attendance", icon: Icons.check_circle, badge: "0%"),
    _DashboardTile(title: "Assignment", icon: Icons.assignment, badge: "0"),
    _DashboardTile(title: "Results", icon: Icons.bar_chart, badge: "5.48"),
    _DashboardTile(title: "Exams", icon: Icons.edit_document, badge: "0"),
    _DashboardTile(title: "Time Table", icon: Icons.schedule, badge: "X"),
  ];

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Today's Timetable", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildTimetableCard("PETV77", "Assignment-1", "06–07 PM"),
          _buildTimetableCard("PETV77", "Assignment-1", "07–08 PM"),
          const SizedBox(height: 20),
          const Text("Menu Tiles", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: _tiles.map((tile) => _buildTile(tile)).toList()
              ..add(_buildAddTileButton()),
          )
        ],
      ),
    );
  }

  Widget _buildTimetableCard(String subject, String info, String time) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xffFF8552), Color(0xffFFB26B)]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subject, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(info),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(time, style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(_DashboardTile tile) {
    return Stack(
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(10),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(tile.icon, size: 35, color: Colors.orange),
                  const SizedBox(height: 6),
                  Text(tile.title, style: const TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
        ),
        if (tile.badge != null)
          Positioned(
            top: 5,
            right: 5,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(tile.badge!, style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ),
      ],
    );
  }

  Widget _buildAddTileButton() {
    return InkWell(
      onTap: () {
        // Add new tile logic in future
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Icon(Icons.add, color: Colors.grey),
        ),
      ),
    );
  }
}

class _DashboardTile {
  final String title;
  final IconData icon;
  final String? badge;

  const _DashboardTile({
    required this.title,
    required this.icon,
    this.badge,
  });
}
