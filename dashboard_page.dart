          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: _navItems,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            elevation: 10,
            onTap: _onItemTapped,
            showUnselectedLabels: true,
            selectedFontSize: 14,
            unselectedFontSize: 12,
          ),
        ),
      ),
    );
  }
}
