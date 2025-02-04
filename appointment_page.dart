import 'package:flutter/material.dart';
import 'database_helper.dart';

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  List<Map<String, dynamic>> appointments = [];
  List<Map<String, dynamic>> patients = [];
  List<Map<String, dynamic>> doctors = [];

  int? selectedPatientId;
  int? selectedDoctorId;
  int? selectedAppointmentId; // معرف الموعد المختار للتحديث

  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAppointments();
    loadPatients();
    loadDoctors();
  }

  void loadAppointments() async {
    final db = await DatabaseHelper.database;
    final data = await db.query('appointments');
    setState(() {
      appointments = data;
    });
  }

  void loadPatients() async {
    final db = await DatabaseHelper.database;
    final data = await db.query('patients');
    setState(() {
      patients = data;
      // إذا لم يتم تحديد مريض مسبقاً يتم اختيار الأول افتراضيًا
      if (data.isNotEmpty && selectedPatientId == null) {
        selectedPatientId = data.first['id'] as int;
      }
    });
  }

  void loadDoctors() async {
    final db = await DatabaseHelper.database;
    final data = await db.query('doctors');
    setState(() {
      doctors = data;
      // إذا لم يتم تحديد طبيب مسبقاً يتم اختيار الأول افتراضيًا
      if (data.isNotEmpty && selectedDoctorId == null) {
        selectedDoctorId = data.first['id'] as int;
      }
    });
  }

  void addAppointment() async {
    String date = _dateController.text;
    if (selectedPatientId != null &&
        selectedDoctorId != null &&
        date.isNotEmpty) {
      await DatabaseHelper.insertAppointment({
        'patientId': selectedPatientId,
        'doctorId': selectedDoctorId,
        'date': date,
      });
      _dateController.clear();
      loadAppointments();
    }
  }

  void updateAppointment(int id) async {
    String date = _dateController.text;
    if (selectedPatientId != null &&
        selectedDoctorId != null &&
        date.isNotEmpty) {
      await DatabaseHelper.updateAppointment(id, {
        'patientId': selectedPatientId,
        'doctorId': selectedDoctorId,
        'date': date,
      });
      _dateController.clear();
      setState(() {
        selectedAppointmentId = null; // إعادة تعيين المتغير بعد التحديث
      });
      loadAppointments();
    }
  }

  void deleteAppointment(int id) async {
    await DatabaseHelper.deleteAppointment(id);
    loadAppointments();
  }

  // دوال مساعدة لاسترجاع اسم المريض والطبيب من الـ id
  String getPatientName(int patientId) {
    var patient = patients.firstWhere(
          (element) => element['id'] == patientId,
      orElse: () => {},
    );
    return patient.isNotEmpty ? patient['name'] : '';
  }

  String getDoctorName(int doctorId) {
    var doctor = doctors.firstWhere(
          (element) => element['id'] == doctorId,
      orElse: () => {},
    );
    return doctor.isNotEmpty ? doctor['name'] : '';
  }

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
                      SizedBox(height: 20),
                      // Dropdown لاختيار الطبيب
                      Row(
                        children: [
                          Icon(Icons.local_hospital,
                              color: Colors.deepPurple),
                          SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                labelText: 'Select Doctor',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              value: selectedDoctorId,
                              items: doctors.map((doctor) {
                                return DropdownMenuItem<int>(
                                  value: doctor['id'] as int,
                                  child: Text(doctor['name']),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedDoctorId = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // حقل اختيار التاريخ باستخدام التقويم
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              color: Colors.deepPurple),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _dateController,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Select Date',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                suffixIcon: Icon(Icons.arrow_drop_down,
                                    color: Colors.deepPurple),
                              ),
                              onTap: () {
                                _selectDate(context);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // أزرار الإضافة والتحديث
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.deepPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: addAppointment,
                            icon: Icon(Icons.add),
                            label: Text('Add'),
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              if (selectedAppointmentId != null) {
                                updateAppointment(selectedAppointmentId!);
                              }
                            },
                            icon: Icon(Icons.update),
                            label: Text('Update'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              // بطاقة قائمة المواعيد
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
                        'Appointments List',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.all(
                              Colors.deepPurple.shade100),
                          dataRowColor: MaterialStateProperty.all(
                              Colors.grey.shade50),
                          columns: const [
                            DataColumn(
                                label: Text('ID',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Patient',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Doctor',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Date',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Actions',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                          ],
                          rows: appointments.map((appointment) {
                            return DataRow(
                              cells: [
                                DataCell(Text(appointment['id'].toString())),
                                DataCell(Text(getPatientName(
                                    appointment['patientId'] as int))),
                                DataCell(Text(getDoctorName(
                                    appointment['doctorId'] as int))),
                                DataCell(Text(appointment['date'])),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () {
                                          setState(() {
                                            // حفظ بيانات الموعد المختار
                                            selectedAppointmentId =
                                            appointment['id'] as int;
                                            selectedPatientId =
                                            appointment['patientId']
                                            as int;
                                            selectedDoctorId =
                                            appointment['doctorId']
                                            as int;
                                            _dateController.text =
                                            appointment['date'];
                                          });
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => deleteAppointment(
                                            appointment['id'] as int),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
