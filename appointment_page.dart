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
                              backgroundColor: Colors.deepPurple,
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
                              backgroundColor: Colors.orange,
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
                                            appointment['patientId'] as int;
                                            selectedDoctorId =
                                            appointment['doctorId'] as int;
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
