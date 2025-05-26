import 'package:flutter/material.dart';

class CountryPickerDrawer extends StatefulWidget {
  final void Function(String, String) onCountrySelected;
  final VoidCallback onClose;
  final String selectedCountry;

  const CountryPickerDrawer({
    Key? key,
    required this.onCountrySelected,
    required this.onClose,
    required this.selectedCountry,
  }) : super(key: key);

  @override
  State<CountryPickerDrawer> createState() => _CountryPickerDrawerState();
}

class _CountryPickerDrawerState extends State<CountryPickerDrawer> {
  final List<Map<String, String>> countries = [
    {'name': 'India', 'code': '+91'},
    {'name': 'Afghanistan', 'code': '+93'},
    {'name': 'Albania', 'code': '+355'},
    {'name': 'Andorra', 'code': '+376'},
    {'name': 'Antigua & Barbuda', 'code': '+1-268'},
    {'name': 'Armenia', 'code': '+374'},
    {'name': 'Australia', 'code': '+61'},
    {'name': 'Austria', 'code': '+43'},
    // Add more countries as needed
  ];
  String search = '';

  @override
  Widget build(BuildContext context) {
    final filtered = countries
        .where((c) => c['name']!.toLowerCase().contains(search.toLowerCase()))
        .toList();
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Your Country Code',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  GestureDetector(
                    onTap: widget.onClose,
                    child: const Text(
                      'Close',
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search For Country',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (val) => setState(() => search = val),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final country = filtered[index];
                  final isSelected = country['name'] == widget.selectedCountry;
                  return ListTile(
                    title: Text(country['name']!),
                    trailing: Text(country['code']!),
                    selected: isSelected,
                    selectedTileColor: Colors.blue.withOpacity(0.1),
                    onTap: () => widget.onCountrySelected(country['name']!, country['code']!),
                    leading: isSelected
                        ? const Icon(Icons.check_circle, color: Colors.blue)
                        : const SizedBox(width: 24),
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