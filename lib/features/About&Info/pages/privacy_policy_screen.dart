import 'package:MilanMandap/core/const/app_colors.dart';
import 'package:MilanMandap/core/const/globals.dart';
import 'package:MilanMandap/core/const/numberextension.dart';
import 'package:MilanMandap/core/const/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: Typo.bold,
              fontSize: 18.sp,
              color: AppColors.primary,
            ),
          ),
          8.heightBox,
          Text(
            content,
            style: TextStyle(
              fontFamily: Typo.medium,
              fontSize: 15.sp,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => token.accessToken == null
              ? router.goNamed(Routes.signup.name)
              : router.goNamed(Routes.homescreen.name),
        ),
        title: const Text(
          "Privacy Policy",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 100.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.r),
                  bottomRight: Radius.circular(40.r),
                ),
                color: AppColors.primary,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Card(
                margin: EdgeInsets.all(20.w),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection(
                        "Information We Collect",
                        "We collect information to provide and improve the Service, communicate with you, and enhance your experience.\n\n"
                            "a) Personal Information You Provide\n- Name, email, phone number\n- Profile photo, gender, date of birth\n- Wedding details (date, venue, guest list)\n- Contact list (if you sync)\n- Payment info (for purchases)\n- Messages, comments, reviews\n- Other voluntary info (feedback, surveys)\n\n"
                            "b) Device & Usage Info\n- Device identifiers, OS, app version\n- IP address, browser type\n- Log data (pages visited, clicks, session time)\n- Analytics data\n\n"
                            "c) Permissions & Sensor Data\n- Camera/photos (uploads)\n- Storage (saving images/docs)\n- Calendar (reminders)\n- Contacts (invite guests)",
                      ),
                      _buildSection(
                        "How We Use Your Information",
                        "We use your data to:\n- Provide, operate, maintain the App\n- Enable account & profile management\n- Facilitate features (guest list, vendors, reminders)\n- Process payments & subscriptions\n- Send notifications & updates\n- Personalize content & offers\n- Respond to feedback\n- Detect & prevent fraud/security issues\n- Analytics & improvements\n- Marketing (if you opt in)",
                      ),
                      _buildSection(
                        "Data Sharing & Disclosure",
                        "We don’t sell data. We may share:\n- With Service Providers (payments, cloud, analytics)\n- With Vendors (only necessary details)\n- With Other Users (event name, photos as per your settings)\n- For Legal Reasons\n- During Business Transfers (merger/acquisition)",
                      ),
                      _buildSection(
                        "Data Retention",
                        "We keep data only as long as needed for stated purposes or as required by law. Once no longer needed, it will be deleted or anonymized.",
                      ),
                      _buildSection(
                        "Security",
                        "We implement safeguards to protect your data, but no system is 100% secure. We cannot guarantee absolute security during transmission or storage.",
                      ),
                      _buildSection(
                        "Your Rights & Choices",
                        "Depending on your location, you may:\n- Access, correct, delete your data\n- Restrict or object to processing\n- Request portability\n- Withdraw consent (may affect features)\n\nContact us to exercise these rights.",
                      ),
                      _buildSection(
                        "Children",
                        "Our App is not for children under 16. We don’t knowingly collect data from them. If discovered, it will be deleted.",
                      ),
                      _buildSection(
                        "Changes to This Policy",
                        "We may update this Policy. Significant changes will be notified via email or in-app. Continued use means acceptance.",
                      ),
                      _buildSection(
                        "Contact Us",
                        "If you have questions or want to exercise rights, please contact us at info@milanmandap.com or call +91 9850569363.",
                      ),
                    ],
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
