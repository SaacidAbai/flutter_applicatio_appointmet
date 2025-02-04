            // Card wrapping the DataTable for better appearance.
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Scrollbar(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Colors.blue.shade50,
                    ),
                    columns: [
                      DataColumn(
                        label: Text(
                          'ID',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'NAME',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'AGE',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'ACTIONS',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: patients.map((patient) {
                      return DataRow(
                        color: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (patient['id'] == _selectedPatientId) {
                              return Colors.blue.shade100;
                            }
                            return patients.indexOf(patient) % 2 == 0
                                ? Colors.grey.shade50
                                : Colors.white;
                          },
                        ),
                        cells: [
                          DataCell(Text('#${patient['id']}')),
                          DataCell(Text(patient['name'])),
                          DataCell(Text(patient['age'].toString())),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  tooltip: 'Edit',
                                  onPressed: () {
                                    setState(() {
                                      _nameController.text = patient['name'];
                                      _ageController.text =
                                          patient['age'].toString();
                                      _selectedPatientId = patient['id'];
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  tooltip: 'Delete',
                                  onPressed: () => deletePatient(patient['id']),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
     ),
);
}
}
