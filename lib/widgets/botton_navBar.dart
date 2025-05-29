import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.black,
      unselectedItemColor: const Color(0xFF004CFF),
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/ShopIcon.svg',
            colorFilter: ColorFilter.mode(
              currentIndex == 0 ? Colors.black : const Color(0xFF004CFF),
              BlendMode.srcIn,
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/CategoriesIcon.svg',
            colorFilter: ColorFilter.mode(
              currentIndex == 1 ? Colors.black : const Color(0xFF004CFF),
              BlendMode.srcIn,
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/WishlistIcon.svg',
            colorFilter: ColorFilter.mode(
              currentIndex == 2 ? Colors.black : const Color(0xFF004CFF),
              BlendMode.srcIn,
            ),
          ),
          label: '',
        ),

        // Ícono del carrito con badge dinámico
        BottomNavigationBarItem(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              SvgPicture.asset(
                'assets/icons/BagIcon.svg',
                colorFilter: ColorFilter.mode(
                  currentIndex == 3 ? Colors.black : const Color(0xFF004CFF),
                  BlendMode.srcIn,
                ),
              ),
              Positioned(
                top: -4,
                right: -6,
                child: Consumer<CartProvider>(
                  builder: (context, cart, child) {
                    final count = cart.totalQuantity;
                    if (count == 0) return const SizedBox.shrink();
                    return Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          label: '',
        ),

        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/ProfileIcon.svg',
            colorFilter: ColorFilter.mode(
              currentIndex == 4 ? Colors.black : const Color(0xFF004CFF),
              BlendMode.srcIn,
            ),
          ),
          label: '',
        ),
      ],
    );
  }
}
