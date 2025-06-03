import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:country_picker/src/utils.dart';

class CountrySelectionScreen extends StatefulWidget {
  final String? initialCountry;

  const CountrySelectionScreen({Key? key, this.initialCountry})
    : super(key: key);

  @override
  State<CountrySelectionScreen> createState() => _CountrySelectionScreenState();
}

class _CountrySelectionScreenState extends State<CountrySelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Country> _allCountries = [];
  List<Country> _filteredCountries = [];
  Country? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _initCountries();
  }

  void _initCountries() {
    // Obtener todos los países del paquete country_picker
    List<Country> countries = [];
    for (var countryData in Countries.countryList) {
      try {
        countries.add(Country.from(json: countryData));
      } catch (e) {
        // Ignorar si hay un error al cargar un país específico
      }
    }

    setState(() {
      _allCountries.addAll(countries);
      _filteredCountries = List.from(_allCountries);

      // Si hay un país inicial seleccionado, lo marcamos
      if (widget.initialCountry != null && widget.initialCountry!.isNotEmpty) {
        try {
          _selectedCountry = _allCountries.firstWhere(
            (country) =>
                country.name.toLowerCase() ==
                widget.initialCountry!.toLowerCase(),
          );
        } catch (e) {
          // Si no encuentra el país, no selecciona ninguno
        }
      }
    });
  }

  void _filterCountries(String query) {
    query = query.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCountries = List.from(_allCountries);
      } else {
        _filteredCountries =
            _allCountries
                .where((country) => country.name.toLowerCase().contains(query))
                .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.black)),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Country',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),

          // Barra de búsqueda
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _filterCountries,
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.grey[500]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
              cursorColor: const Color(0xFF004CFF),
            ),
          ),

          const SizedBox(height: 8),

          // Lista de categorías alfabéticas
          _buildCategoryHeader(),

          // Lista de países
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCountries.length,
              itemBuilder: (context, index) {
                final country = _filteredCountries[index];
                final isSelected = _selectedCountry?.name == country.name;

                return ListTile(
                  title: Text(country.name),
                  trailing:
                      isSelected
                          ? const Icon(
                            Icons.check_circle,
                            color: Color(0xFF004CFF),
                          )
                          : null,
                  onTap: () {
                    Navigator.pop(context, country);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader() {
    if (_filteredCountries.isEmpty) return const SizedBox.shrink();

    String currentLetter = '';
    if (_searchController.text.isNotEmpty && _filteredCountries.isNotEmpty) {
      currentLetter = _filteredCountries[0].name[0].toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[100],
      width: double.infinity,
      child: Text(
        currentLetter,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}
