import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../ecommerce/data/repositories/mock_product_repository.dart';
import '../../../ecommerce/domain/entities/product.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authStateProvider).asData?.value;
    final userRole = ref.watch(currentUserRoleProvider).asData?.value ?? 'client';
    final isAdmin = userRole == 'admin';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.admin_panel_settings, color: Color(0xFF007AFF)),
            SizedBox(width: 8),
            Text(
              'Panel de Administrador',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            tooltip: 'Ir a Tienda',
            onPressed: () => context.go('/home'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF007AFF),
          unselectedLabelColor: Colors.black54,
          indicatorColor: const Color(0xFF007AFF),
          indicatorWeight: 3,
          tabs: const [
            Tab(
              icon: Icon(Icons.show_chart_rounded),
              text: 'Ventas en Vivo',
            ),
            Tab(
              icon: Icon(Icons.inventory_2_outlined),
              text: 'Gestión de Productos',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Banner de Perfil y Rol Activo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: isAdmin ? Colors.blue.shade50 : Colors.amber.shade50,
            child: Row(
              children: [
                Icon(
                  isAdmin ? Icons.verified_user_rounded : Icons.person_outline,
                  size: 18,
                  color: isAdmin ? Colors.blue.shade700 : Colors.amber.shade800,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    currentUser != null
                        ? '${currentUser.email} • Rol: ${isAdmin ? 'Administrador' : 'Cliente'}'
                        : 'Sesión Invitado • Rol: ${isAdmin ? 'Administrador' : 'Cliente'}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isAdmin ? Colors.blue.shade900 : Colors.amber.shade900,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (currentUser != null)
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      visualDensity: VisualDensity.compact,
                    ),
                    icon: Icon(
                      isAdmin ? Icons.swap_horiz : Icons.security,
                      size: 14,
                      color: isAdmin ? Colors.blue.shade700 : Colors.amber.shade900,
                    ),
                    label: Text(
                      isAdmin ? 'Cambiar a Cliente' : 'Activar Modo Admin',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isAdmin ? Colors.blue.shade700 : Colors.amber.shade900,
                      ),
                    ),
                    onPressed: () async {
                      await ref
                          .read(authControllerProvider.notifier)
                          .toggleAdminRole(currentUser.uid, !isAdmin);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              !isAdmin
                                  ? '🛡️ Rol cambiado a Administrador exitosamente.'
                                  : '👤 Rol cambiado a Cliente.',
                            ),
                            backgroundColor: !isAdmin ? Colors.green : Colors.blueGrey,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                _RealtimeSalesTab(),
                _ProductsManagementTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// =============================================================================
// TAB 1: VENTAS EN TIEMPO REAL
// =============================================================================
class _RealtimeSalesTab extends StatelessWidget {
  const _RealtimeSalesTab();

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final dateFormatter = DateFormat('dd/MM/yyyy • hh:mm a');

    // Stream en tiempo real de la colección global 'sales'
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('sales')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
                  const SizedBox(height: 16),
                  Text('Error al cargar ventas: ${snapshot.error}', textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data?.docs ?? [];

        // Calcular métricas
        double totalRevenue = 0;
        for (final doc in docs) {
          final data = doc.data();
          final amount = (data['totalAmount'] as num?)?.toDouble() ?? 0.0;
          totalRevenue += amount;
        }

        return CustomScrollView(
          slivers: [
            // Indicador de "En Vivo" y KPIs
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Badge En Vivo
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Sincronización en tiempo real activa (Firestore)',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Tarjetas de Métricas
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard(
                            title: 'Total Ventas',
                            value: currencyFormatter.format(totalRevenue),
                            icon: Icons.monetization_on_outlined,
                            color: const Color(0xFF007AFF),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMetricCard(
                            title: 'Órdenes',
                            value: '${docs.length}',
                            icon: Icons.receipt_long_outlined,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Historial de Ventas Recientes',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${docs.length} registros',
                          style: const TextStyle(color: Colors.black54, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Lista de Ventas
            if (docs.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Aún no hay ventas registradas.',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Realiza una compra en la tienda para verla aquí en tiempo real.',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final doc = docs[index];
                      final data = doc.data();
                      final totalAmount = (data['totalAmount'] as num?)?.toDouble() ?? 0.0;
                      final userEmail = data['userEmail'] as String? ?? 'Invitado';
                      final paymentMethod = data['paymentMethod'] as String? ?? 'Tarjeta';
                      final status = data['status'] as String? ?? 'Completado';
                      
                      DateTime date = DateTime.now();
                      if (data['createdAt'] is Timestamp) {
                        date = (data['createdAt'] as Timestamp).toDate();
                      }

                      final itemsList = (data['items'] as List<dynamic>?) ?? [];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        child: ExpansionTile(
                          shape: const Border(),
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFFE9F2FF),
                            child: const Icon(Icons.check_circle_outline, color: Color(0xFF007AFF)),
                          ),
                          title: Text(
                            currencyFormatter.format(totalAmount),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Cliente: $userEmail', style: const TextStyle(fontSize: 12)),
                              Text(dateFormatter.format(date), style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                            ],
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold, fontSize: 11),
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(height: 1),
                                  const SizedBox(height: 12),
                                  Text('Método de Pago: $paymentMethod', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 8),
                                  const Text('Productos Comprados:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  ...itemsList.map((item) {
                                    final title = item['title'] ?? item['name'] ?? 'Producto';
                                    final qty = item['quantity'] ?? 1;
                                    final price = (item['price'] as num?)?.toDouble() ?? 0.0;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('• $qty x $title', style: const TextStyle(fontSize: 12)),
                                          Text(currencyFormatter.format(price * qty), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: docs.length,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  static Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// TAB 2: GESTIÓN DE PRODUCTOS (CRUD)
// =============================================================================
class _ProductsManagementTab extends ConsumerWidget {
  const _ProductsManagementTab();

  void _showProductForm(BuildContext context, WidgetRef ref, [Product? productToEdit]) {
    final nameController = TextEditingController(text: productToEdit?.name ?? '');
    final priceController = TextEditingController(
      text: productToEdit != null ? productToEdit.price.toStringAsFixed(2) : '',
    );
    final imageController = TextEditingController(
      text: productToEdit?.imageUrl ?? 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
    );

    List<String> selectedSizes = List.from(productToEdit?.availableSizes ?? ['S', 'M', 'L']);
    List<String> selectedColors = List.from(productToEdit?.availableColors ?? ['0xFF007AFF', '0xFF000000']);

    final availableSizeOptions = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
    final availableColorOptions = [
      {'hex': '0xFF000000', 'name': 'Negro', 'color': Colors.black},
      {'hex': '0xFF007AFF', 'name': 'Azul', 'color': const Color(0xFF007AFF)},
      {'hex': '0xFFFF3B30', 'name': 'Rojo', 'color': Colors.red},
      {'hex': '0xFF34C759', 'name': 'Verde', 'color': Colors.green},
      {'hex': '0xFFFFD700', 'name': 'Dorado', 'color': Colors.amber},
      {'hex': '0xFF808080', 'name': 'Gris', 'color': Colors.grey},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          productToEdit == null ? 'Nuevo Producto' : 'Editar Producto',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(sheetContext),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del Producto',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.label_outline),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: priceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Precio (\$, €)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: imageController,
                      decoration: const InputDecoration(
                        labelText: 'URL de la Imagen',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.image_outlined),
                      ),
                      onChanged: (_) => setModalState(() {}),
                    ),
                    const SizedBox(height: 12),
                    // Preview de la imagen
                    if (imageController.text.isNotEmpty)
                      Center(
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                            image: DecorationImage(
                              image: NetworkImage(imageController.text),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    const Text('Tallas Disponibles:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: availableSizeOptions.map((size) {
                        final isSelected = selectedSizes.contains(size);
                        return FilterChip(
                          label: Text(size),
                          selected: isSelected,
                          onSelected: (selected) {
                            setModalState(() {
                              if (selected) {
                                selectedSizes.add(size);
                              } else {
                                selectedSizes.remove(size);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text('Colores Disponibles:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      children: availableColorOptions.map((opt) {
                        final hex = opt['hex'] as String;
                        final color = opt['color'] as Color;
                        final isSelected = selectedColors.contains(hex);
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              if (isSelected) {
                                selectedColors.remove(hex);
                              } else {
                                selectedColors.add(hex);
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? const Color(0xFF007AFF) : Colors.transparent,
                                width: 2.5,
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundColor: color,
                              radius: 14,
                              child: isSelected
                                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                                  : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007AFF),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          final name = nameController.text.trim();
                          final price = double.tryParse(priceController.text) ?? 0.0;
                          final img = imageController.text.trim();

                          if (name.isEmpty || price <= 0 || img.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Por favor completa todos los campos correctamente.')),
                            );
                            return;
                          }

                          final repo = ref.read(productRepositoryProvider);

                          if (productToEdit == null) {
                            // Crear Producto
                            final newProduct = Product(
                              id: '',
                              name: name,
                              price: price,
                              imageUrl: img,
                              availableSizes: selectedSizes.isNotEmpty ? selectedSizes : ['M'],
                              availableColors: selectedColors.isNotEmpty ? selectedColors : ['0xFF007AFF'],
                            );
                            await repo.createProduct(newProduct);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('✅ ¡Producto creado exitosamente!'), backgroundColor: Colors.green),
                              );
                            }
                          } else {
                            // Editar Producto
                            final updatedProduct = productToEdit.copyWith(
                              name: name,
                              price: price,
                              imageUrl: img,
                              availableSizes: selectedSizes.isNotEmpty ? selectedSizes : ['M'],
                              availableColors: selectedColors.isNotEmpty ? selectedColors : ['0xFF007AFF'],
                            );
                            await repo.updateProduct(updatedProduct);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('✅ ¡Producto actualizado con éxito!'), backgroundColor: Colors.blue),
                              );
                            }
                          }

                          if (sheetContext.mounted) {
                            Navigator.pop(sheetContext);
                          }
                        },
                        child: Text(
                          productToEdit == null ? 'Guardar Producto' : 'Actualizar Producto',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Product product) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar Producto'),
          content: Text('¿Estás seguro de que deseas eliminar "${product.name}"? Esta acción no se puede deshacer.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () async {
                final repo = ref.read(productRepositoryProvider);
                await repo.deleteProduct(product.id);
                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('🗑️ "${product.name}" ha sido eliminado.')),
                  );
                }
              },
              child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final repo = ref.watch(productRepositoryProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF007AFF),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Nuevo Producto', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () => _showProductForm(context, ref),
      ),
      body: StreamBuilder<List<Product>>(
        stream: repo.watchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No hay productos en el catálogo.'),
                  SizedBox(height: 8),
                  Text('Presiona "+ Nuevo Producto" para añadir uno.'),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
            itemCount: products.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final product = products[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      product.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_not_supported, color: Colors.grey),
                      ),
                    ),
                  ),
                  title: Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        currencyFormatter.format(product.price),
                        style: const TextStyle(color: Color(0xFF007AFF), fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tallas: ${product.availableSizes.join(", ")}',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: Color(0xFF007AFF)),
                        tooltip: 'Editar',
                        onPressed: () => _showProductForm(context, ref, product),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        tooltip: 'Eliminar',
                        onPressed: () => _confirmDelete(context, ref, product),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
