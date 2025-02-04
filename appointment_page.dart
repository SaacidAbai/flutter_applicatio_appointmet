
  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate =
        DateTime.tryParse(_dateController.text) ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              surface: Colors.deepPurpleAccent,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        // تنسيق التاريخ بالشكل YYYY-MM-DD
        _dateController.text = picked.toIso8601String().split('T').first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Registration'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // بطاقة تسجيل الموعد
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Register Appointment',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      // Dropdown لاختيار المريض
                      Row(
                        children: [
                          Icon(Icons.person, color: Colors.deepPurple),
                          SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                labelText: 'Select Patient',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              value: selectedPatientId,
                              items: patients.map((patient) {
                                return DropdownMenuItem<int>(
                                  value: patient['id'] as int,
                                  child: Text(patient['name']),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedPatientId = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
