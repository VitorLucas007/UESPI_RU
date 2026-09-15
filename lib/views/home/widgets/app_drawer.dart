import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Item de navegação do menu lateral.
class DrawerNavItem {
  final String title;
  final IconData icon;
  final String route;

  const DrawerNavItem({
    required this.title,
    required this.icon,
    required this.route,
  });
}

/// Menu lateral personalizado (AppDrawer) do aplicativo RU UESPI.
///
/// Apresenta cabeçalho minimalista com detalhe em amarelo dourado,
/// lista de navegação com indicador visual do item selecionado e
/// rodapé com ação de sair do aplicativo.
class AppDrawer extends StatelessWidget {
  /// Rota ativa atual (ex: '/home', '/details', '/location').
  final String? currentRoute;

  /// Índice selecionado diretamente (caso não utilize rotas nomeadas).
  final int? selectedIndex;

  /// Callback customizado ao clicar em um item da lista.
  final void Function(int index, String route)? onItemTap;

  /// Callback customizado para a ação de logout/saída.
  final VoidCallback? onLogout;

  /// Largura customizada para o Drawer (padrão: ~78% da largura da tela).
  final double? width;

  const AppDrawer({
    super.key,
    this.currentRoute,
    this.selectedIndex,
    this.onItemTap,
    this.onLogout,
    this.width,
  });

  /// Lista padrão de itens de navegação principal conforme especificação.
  static const List<DrawerNavItem> defaultItems = [
    DrawerNavItem(
      title: 'Cardápio Completo',
      icon: Icons.restaurant_menu_outlined,
      route: '/details',
    ),
    DrawerNavItem(
      title: 'Localização',
      icon: Icons.location_on_outlined,
      route: '/location',
    ),
    DrawerNavItem(
      title: 'Informações sobre o RU',
      icon: Icons.info_outline,
      route: '/info',
    ),
    DrawerNavItem(
      title: 'Configurações',
      icon: Icons.settings_outlined,
      route: '/settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final drawerWidth = width ?? (screenWidth * 0.78);

    return Drawer(
      width: drawerWidth,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Minimalista do App
            _buildHeader(),

            const SizedBox(height: 12),

            // Lista de Navegação Principal
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: defaultItems.length,
                itemBuilder: (context, index) {
                  final item = defaultItems[index];
                  final isSelected = _isItemSelected(index, item.route);
                  return _buildNavItem(context, item, index, isSelected);
                },
              ),
            ),

            // Rodapé com Divisor e Opção "Sair do App"
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  /// Verifica se um item está atualmente ativo.
  bool _isItemSelected(int index, String route) {
    if (selectedIndex != null) {
      return selectedIndex == index;
    }
    if (currentRoute != null) {
      return currentRoute == route;
    }
    return false;
  }

  /// Cabeçalho minimalista com detalhe vertical amarelo dourado e marca "RU UESPI".
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Row(
        children: [
          // Detalhe vertical em amarelo dourado (#FFB300)
          Container(
            width: 4,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFFFFB300),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          // Texto "RU UESPI" em negrito no azul escuro (#003366)
          const Text(
            'RU UESPI',
            style: TextStyle(
              color: Color(0xFF003366),
              fontWeight: FontWeight.w900,
              fontSize: 22,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói um item de navegação individual com estilo ativo/inativo.
  Widget _buildNavItem(
    BuildContext context,
    DrawerNavItem item,
    int index,
    bool isSelected,
  ) {
    const primaryColor = Color(0xFF003366);
    const goldenColor = Color(0xFFFFB300);
    const activeBackground = Color(0xFFE8F0FE);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? activeBackground : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _handleItemTap(context, index, item.route),
        borderRadius: BorderRadius.circular(12),
        splashColor: primaryColor.withValues(alpha: 0.1),
        highlightColor: primaryColor.withValues(alpha: 0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              // Ícone
              Icon(
                item.icon,
                size: 22,
                color: isSelected ? primaryColor : const Color(0xFF555555),
              ),
              const SizedBox(width: 14),

              // Título
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? primaryColor : const Color(0xFF333333),
                  ),
                ),
              ),

              // Indicador visual à direita (pílula dourada) para item ativo
              if (isSelected)
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: goldenColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Trata o clique no item fechando o Drawer antes de navegar.
  void _handleItemTap(BuildContext context, int index, String route) {
    // 1. Fecha o Drawer primeiro
    Navigator.pop(context);

    // 2. Executa callback customizado se fornecido
    if (onItemTap != null) {
      onItemTap!(index, route);
      return;
    }

    // 3. Comportamento de navegação padrão
    if (route == currentRoute) {
      return; // Já está na rota atual
    }

    switch (route) {
      case '/details':
      case '/location':
        Navigator.pushNamed(context, route);
        break;
      case '/info':
        _showRuInfoDialog(context);
        break;
      case '/settings':
        _showSettingsDialog(context);
        break;
      default:
        Navigator.pushNamed(context, route);
    }
  }

  /// Rodapé com divisor e opção "Sair do App".
  Widget _buildFooter(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(
          height: 1,
          thickness: 1,
          indent: 16,
          endIndent: 16,
          color: Color(0xFFEBEBEB),
        ),
        const SizedBox(height: 6),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: InkWell(
            onTap: () => _handleLogoutTap(context),
            borderRadius: BorderRadius.circular(12),
            splashColor: Colors.red.withValues(alpha: 0.1),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    size: 22,
                    color: Color(0xFFD32F2F),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Sair do App',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFD32F2F),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  /// Ação ao clicar em "Sair do App": fecha o Drawer e abre o diálogo de confirmação.
  void _handleLogoutTap(BuildContext context) {
    // Fecha o Drawer
    Navigator.pop(context);

    if (onLogout != null) {
      onLogout!();
      return;
    }

    // Diálogo padrão de confirmação de saída
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Sair do App',
          style: TextStyle(
            color: Color(0xFF003366),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: const Text(
          'Tem certeza de que deseja fechar o aplicativo RU UESPI?',
          style: TextStyle(fontSize: 14, color: Color(0xFF555555)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Color(0xFF757575), fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              SystemNavigator.pop();
            },
            child: const Text(
              'Sair',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  /// Exibe diálogo informativo com detalhes operacionais do RU UESPI.
  void _showRuInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Color(0xFF003366)),
            SizedBox(width: 8),
            Text(
              'Informações do RU',
              style: TextStyle(
                color: Color(0xFF003366),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Restaurante Universitário - UESPI',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(height: 8),
            Text('• Campus: Poeta Torquato Neto (Teresina - PI)'),
            SizedBox(height: 4),
            Text('• Almoço: 11:00 às 13:30'),
            SizedBox(height: 4),
            Text('• Jantar: 17:30 às 19:00'),
            SizedBox(height: 4),
            Text('• Tarifa Estudante: R\$ 1,00'),
            SizedBox(height: 4),
            Text('• Pagamento: PIX e Ticket no guichê'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Fechar',
              style: TextStyle(
                color: Color(0xFF003366),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Exibe diálogo de configurações do aplicativo.
  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.settings_outlined, color: Color(0xFF003366)),
            SizedBox(width: 8),
            Text(
              'Configurações',
              style: TextStyle(
                color: Color(0xFF003366),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.notifications_active_outlined, color: Color(0xFF003366)),
              title: Text('Notificações', style: TextStyle(fontSize: 14)),
              subtitle: Text('Alertas de cardápio e horário', style: TextStyle(fontSize: 12)),
              trailing: Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 20),
            ),
            Divider(height: 1),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.info_outline, color: Color(0xFF003366)),
              title: Text('Versão do App', style: TextStyle(fontSize: 14)),
              subtitle: Text('v1.0.0 (Build 1)', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Fechar',
              style: TextStyle(
                color: Color(0xFF003366),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

