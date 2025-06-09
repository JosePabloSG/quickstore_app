import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Notificaciones de ofertas'),
            subtitle: const Text('Recibe notificaciones sobre ofertas especiales'),
            value: user?.notificationPreferences?.offers ?? false,
            onChanged: (value) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Próximamente'),
                  content: const Text('La configuración de notificaciones estará disponible en la próxima actualización.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Entendido'),
                    ),
                  ],
                ),
              );
            },
          ),
          SwitchListTile(
            title: const Text('Notificaciones de pedidos'),
            subtitle: const Text('Recibe actualizaciones sobre tus pedidos'),
            value: user?.notificationPreferences?.orders ?? false,
            onChanged: (value) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Próximamente'),
                  content: const Text('La configuración de notificaciones estará disponible en la próxima actualización.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Entendido'),
                    ),
                  ],
                ),
              );
            },
          ),
          SwitchListTile(
            title: const Text('Notificaciones de marketing'),
            subtitle: const Text('Recibe información sobre nuevos productos'),
            value: user?.notificationPreferences?.marketing ?? false,
            onChanged: (value) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Próximamente'),
                  content: const Text('La configuración de notificaciones estará disponible en la próxima actualización.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Entendido'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
