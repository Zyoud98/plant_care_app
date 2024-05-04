import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'lib.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget buildSettingsUI(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Color(0xFF426D53),
      title: Text(
        'Settings',
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
    ),
    body: ListView(
      children: [
        buildSettingOption('About Us', () {
          // Navigate to the About Us page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LinksPage()),
          );
        }),
        buildSettingOption('Security - Change Password', () {
          // Navigate to the Change Password page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ForgetPasswordPage()),
          );
        }),
        buildSettingOption('Log out', () {
          // Call the logout function
          _logout(context);
        }),
      ],
    ),
  );
}

Widget buildSettingOption(String optionName, Function()? onTap) {
  return ListTile(
    title: Text(optionName),
    onTap: onTap != null ? () => onTap() : null,
  );
}

void _logout(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    // Navigate to login screen or any other desired screen after logout
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => LoginApp(),
    ));
  } catch (e) {
    print("Error logging out: $e");
    // Handle error
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Failed to log out. Please try again later."),
    ));
  }
}

// class AboutUsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('About Us'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'About Us Page',
//               style: TextStyle(fontSize: 24),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 // Open links page
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => LinksPage()),
//                 );
//               },
//               child: Text('Open Links'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class LinksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF426D53),
        title: Text(
          'Links',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(80.0),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              buildLinkItem('Plantify', FontAwesomeIcons.facebook, Colors.blue,
                  Colors.blue, () {
                _launchURL('https://www.facebook.com/');
              }),
              SizedBox(
                height: 20,
              ),
              buildLinkItem('Plantify', FontAwesomeIcons.instagram,
                  Colors.purple, Colors.purple, () {
                _launchURL('https://www.instagram.com/');
              }),
              SizedBox(
                height: 20,
              ),
              buildLinkItem(
                  'Plantify', FontAwesomeIcons.youtube, Colors.red, Colors.red,
                  () {
                _launchURL('https://www.youtube.com/');
              }),
              // Add more links as needed
            ],
          ),
        ),
      ),
    );
  }
}

// class ChangePasswordPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Change Password'),
//       ),
//       body: Center(
//         child: Text(
//           'Change Password Page',
//           style: TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }
void _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Widget buildLinkItem(String linkName, IconData icon, Color iconColor,
    Color textColor, Function()? onTap) {
  return ListTile(
    leading: Icon(
      icon,
      color: iconColor,
      size: 60,
    ),
    title: Text(
      linkName,
      style: TextStyle(
          color: textColor, fontSize: 25, fontWeight: FontWeight.bold),
    ),
    onTap: onTap != null ? () => onTap() : null,
  );
}
