import 'package:flutter/material.dart';

class DoctorProfileScreen extends StatelessWidget {
  final Map<String, dynamic> docData;

  const DoctorProfileScreen({super.key, required this.docData});
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    Map<String, bool> appointmentDaysMap = Map<String, bool>.from(docData['available_days']);
    

    List<String> allDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];

        // Filter and sort the available days
        List<String> selectedDays = [];
        allDays.forEach((day) {
          if (appointmentDaysMap[day] == true) {
            selectedDays.add(day);
          }
        });

    String appointmentDaysString = selectedDays.join(', ');

    String formatAppointmentTimings(Map<String, dynamic> appointmentTimings) {
  if (appointmentTimings.containsKey('from') && appointmentTimings.containsKey('to')) {
    // Convert Firestore's timestamp or string to TimeOfDay if necessary, otherwise, just use the values
    String fromTime = appointmentTimings['from']; // e.g., '6:00'
    String toTime = appointmentTimings['to']; // e.g., '8:00'

    return '$fromTime - $toTime';
  } else {
    return 'N/A'; // Return a fallback value if 'from' or 'to' is missing
  }
}

    return Scaffold(
      appBar: AppBar(
        title: Text("Dr. ${docData['display_name']}"),
      ),
      body: Column(
        children: [
          Container(
            height: screenHeight * 0.3,
            width: double.infinity,
            child: Image.asset(
              "assets/images/doctor1.jpg",
              fit: BoxFit.cover,
            ),
          ),
          // Details Section - Flexible to fit the remaining space
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Speciality:",style: TextStyle(fontSize: 16)),
                      Text(
                        docData['Speciality'],
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Experience:",style: TextStyle(fontSize: 16)),
                      Text(
                        '${docData['Experience']} years',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Location:",style: TextStyle(fontSize: 16)),
                      Text(
                        docData['Location'],
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Appointment Fees:",style: TextStyle(fontSize: 16)),
                      Text(
                        'Rs.${docData['Fees']}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Appointment Days:",style: TextStyle(fontSize: 16)),
                      
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.sizeOf(context).width * 0.45
                        ),
                        child: Text(
                          appointmentDaysString,
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Appointment Timings",style: TextStyle(fontSize: 16)),
                      Text(
                        formatAppointmentTimings(docData['appointment_timings']),
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Spacer(),
                  Center(
                    child: MaterialButton(
                      onPressed: () {
                        // Handle book appointment action
                      },
                      child: Text('Book Appointment'),
                      padding: EdgeInsets.all(17),
                      textColor: Colors.white,
                      color: Colors.deepPurple.shade300,
                      minWidth: double.infinity,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(onPressed: (){
    
                      },
                      child: Row(
                        children: [
                          Icon(Icons.chat, size: 20,),
                          SizedBox(
                            width: 8,
                          ),
                          Text("Chat"),
                        ],
                      ),
                      textColor: Colors.white,
                      color: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                      ),
                      MaterialButton(onPressed: (){
    
                      },
                      child: Row(
                        children: [
                          Icon(Icons.call_made),
                          SizedBox(
                            width: 8,
                          ),
                          Text("Call"),
                        ],
                      ),
                      textColor: Colors.white,
                      color: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
