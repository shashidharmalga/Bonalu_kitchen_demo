import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PROFILE')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=400&auto=format&fit=crop'),
            ),
            const SizedBox(height: 16),
            Text(
              'John Doe',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24),
            ),
            const Text('+91 98765 43210', style: TextStyle(color: Colors.white70)),
            
            const SizedBox(height: 40),
            
            _buildProfileItem(context, Icons.history, 'Order History', () => context.push('/orders')),
            _buildProfileItem(context, Icons.location_on_outlined, 'Saved Addresses', () {}),
            _buildProfileItem(context, Icons.payment_outlined, 'Payment Methods', () {}),
            _buildProfileItem(context, Icons.notifications_none, 'Notifications', () {}),
            _buildProfileItem(context, Icons.help_outline, 'Help & Support', () {}),
            
            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.go('/splash'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.redAccent),
                ),
                child: const Text('LOGOUT', style: TextStyle(color: Colors.redAccent)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white24),
        onTap: onTap,
      ),
    );
  }
}
