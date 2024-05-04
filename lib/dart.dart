// import 'package:flutter/material.dart';

// class _EventCardState extends State<EventCard> {
//   bool _expanded = false;
// // Color(0xff30cd2a),
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Color(0xFF426D53),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       borderOnForeground: false,
//       // color: Color(0xfff5e19b),
//       elevation: 3,
//       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           InkWell(
//             onTap: () {
//               setState(() {
//                 _expanded = !_expanded;
//               });
//             },
//             child: Padding(
//               padding: EdgeInsets.all(16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     //namee of the plant or picture of it .
//                     widget.event.name,
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     //متى زرعت
//                     'Date Planted: ${widget.event.startDate.toString()}',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           if (_expanded) ...[
//             SizedBox(height: 8),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 4),
//                   Text(
//                     //Humidity
//                     'Temperature: ${widget.event.participants.length}',
//                     style: TextStyle(fontSize: 16, color: Colors.white),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     //
//                     'Moisure: ${widget.event.amount}',
//                     style: TextStyle(fontSize: 16, color: Colors.white),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     //
//                     'Light: ${widget.event.amount}',
//                     style: TextStyle(fontSize: 16, color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 8),
//             Divider(), // Divider to separate buttons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 TextButton.icon(
//                   onPressed: () {},
//                   icon: Icon(
//                     Icons.view_agenda_rounded,
//                     color: Colors.white,
//                   ),
//                   label: Text(
//                     'View',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 Divider(), // Divider to separate buttons
//                 TextButton.icon(
//                   onPressed: () {
//                     showDialog(
//                         context: context,
//                         builder: (context) {
//                           // Delete Participant functionality
//                           return AlertDialog(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(
//                                   20.0,
//                                 ),
//                               ),
//                             ),
//                             contentPadding: EdgeInsets.only(
//                               top: 10.0,
//                             ),
//                             title: Text(
//                               "Are you sure you want to remove this plant ?",
//                               style: TextStyle(
//                                   fontSize: 24.0, color: Colors.black),
//                             ),
//                             content: Container(
//                                 height: 100,
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       child: TextButton(
//                                         style: TextButton.styleFrom(
//                                           foregroundColor: Colors.green,
//                                         ),
//                                         onPressed: () {},
//                                         child: Text(
//                                           'Yes',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 20,
//                                               color: Color(0xFF426D53)),
//                                         ),
//                                       ),
//                                     ),
//                                     Divider(),
//                                     Expanded(
//                                       child: TextButton(
//                                         style: TextButton.styleFrom(
//                                           foregroundColor: Colors.red,
//                                         ),
//                                         onPressed: () {
//                                           // Implement what you want the second button to do
//                                           Navigator.pop(context);
//                                         },
//                                         child: Text(
//                                           'No',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 20,
//                                               color: Color(0xFF426D53)),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 )),
//                           );

//                           // setState(() {
//                           //   print("Deleted ${widget.event.name}");
//                           //   DatabaseVii.remove(widget.event);
//                           // });
//                         });
//                   },
//                   icon: Icon(
//                     Icons.delete_forever,
//                     color: Colors.white,
//                   ),
//                   label: Text(
//                     'Delete',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }
