import 'package:flutter/material.dart';
import 'package:janpro/Utitlity/custom_color.dart';

class OperationVisitTablePage extends StatelessWidget {
  final List<VisitEntry> entries = [
    VisitEntry(
      // client: 'Client A',
      site: 'Site A1',
      date: '10/07/2025',
      time: '10:30',
      purpose: 'Routine inspection',
      // remarks: 'Everything was clean',
      imagePath: 'assets/sample1.jpg',
    ),
    VisitEntry(
      // client: 'Client B',
      site: 'Site B2',
      date: '09/07/2025',
      time: '14:15',
      purpose: 'Complaint follow-up',
      // remarks: 'Issue resolved onsite',
      imagePath: 'assets/sample2.jpg',
    ),
    VisitEntry(
      // client: 'Client A',
      site: 'Site A1',
      date: '10/07/2025',
      time: '10:30',
      purpose: 'Routine inspection',
      // remarks: 'Everything was clean',
      imagePath: 'assets/sample1.jpg',
    ),
    VisitEntry(
      // client: 'Client B',
      site: 'Site B2',
      date: '09/07/2025',
      time: '14:15',
      purpose: 'Complaint follow-up',
      // remarks: 'Issue resolved onsite',
      imagePath: 'assets/sample2.jpg',
    ),
    VisitEntry(
      // client: 'Client A',
      site: 'Site A1',
      date: '10/07/2025',
      time: '10:30',
      purpose: 'Routine inspection',
      // remarks: 'Everything was clean',
      imagePath: 'assets/sample1.jpg',
    ),
    VisitEntry(
      // client: 'Client B',
      site: 'Site B2',
      date: '09/07/2025',
      time: '14:15',
      purpose: 'Complaint follow-up',
      // remarks: 'Issue resolved onsite',
      imagePath: 'assets/sample2.jpg',
    ),
  ];

  OperationVisitTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Visit Data Table"),
        backgroundColor: customcolor.blue,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(customcolor.blue),
                dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return customcolor.blue;
                    }
                    return null;
                  },
                ),
                headingTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                columns: const [
                  // DataColumn(
                  //   label: Padding(
                  //     padding: EdgeInsets.all(8),
                  //     child: Text('Client'),
                  //   ),
                  // ),
                  DataColumn(
                    label: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Site'),
                    ),
                  ),
                  DataColumn(
                    label: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Date'),
                    ),
                  ),
                  DataColumn(
                    label: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Time'),
                    ),
                  ),
                  DataColumn(
                    label: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Purpose'),
                    ),
                  ),

                  DataColumn(
                    label: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Image'),
                    ),
                  ),
                ],
                rows: List.generate(entries.length, (index) {
                  final entry = entries[index];
                  return DataRow(
                    color: MaterialStateProperty.all(
                      index % 2 == 0 ? Colors.white : Colors.grey.shade100,
                    ),
                    cells: [
                      DataCell(Padding(
                          padding: EdgeInsets.all(8), child: Text(entry.site))),
                      DataCell(Padding(
                          padding: EdgeInsets.all(8), child: Text(entry.date))),
                      DataCell(Padding(
                          padding: EdgeInsets.all(8), child: Text(entry.time))),
                      DataCell(Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(entry.purpose))),
                      DataCell(
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: GestureDetector(
                            onTap: () {
                              // Full image preview
                              showDialog(
                                context: context,
                                builder: (_) => Dialog(


                                  
                                  backgroundColor: Colors.transparent,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(entry.imagePath,
                                        fit: BoxFit.contain),
                                  ),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.asset(
                                entry.imagePath,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.broken_image),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VisitEntry {
  // final String client;
  final String site;
  final String date;
  final String time;
  final String purpose;
  // final String remarks;
  final String imagePath;

  VisitEntry({
    // required this.client,
    required this.site,
    required this.date,
    required this.time,
    required this.purpose,
    // required this.remarks,
    required this.imagePath,
  });
}
