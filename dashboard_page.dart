import 'package:flutter/material.dart';
import 'database_helper.dart';

class DashboardPage extends StatefulWidget {
  final String username;
  final String role;

  DashboardPage({required this.username, required this.role});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int patientCount = 0;
  int doctorCount = 0;
  int appointmentCount = 0;
  int userCount = 0;

  final List<String> bannerImages = [
    "img/1.jpg",
    "img/2.jpg",
    "img/3.jpg",
  ];

  int currentBannerIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    int pCount = await DatabaseHelper.getPatientCount();
    int dCount = await DatabaseHelper.getDoctorCount();
    int aCount = await DatabaseHelper.getAppointmentCount();
    int uCount = await DatabaseHelper.getUserCount();

    setState(() {
      patientCount = pCount;
      doctorCount = dCount;
      appointmentCount = aCount;
      userCount = uCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // SafeArea لضمان عدم تداخل المحتوى مع مناطق النظام (notch، status bar)
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
          // تغليف المحتوى بـ SingleChildScrollView لتفادي حدوث overflow على الشاشات الصغيرة
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // قسم البنرات مع تأثير تدرجي وحواف دائرية جذابة
                Container(
                  height: 230,
                  margin: EdgeInsets.fromLTRB(16, 40, 16, 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        PageView.builder(
                          itemCount: bannerImages.length,
                          onPageChanged: (index) =>
                              setState(() => currentBannerIndex = index),
                          itemBuilder: (context, index) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(bannerImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.5),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // مؤشر الصفحات (dots)
                        Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              bannerImages.length,
                                  (index) => AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                width: currentBannerIndex == index ? 12 : 8,
                                height: currentBannerIndex == index ? 12 : 8,
                                decoration: BoxDecoration(
                                  color: currentBannerIndex == index
                                      ? Colors.white
                                      : Colors.white70,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // قسم الترحيب مع نصوص أنيقة
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, ${widget.username}!',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo[900],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Role: ${widget.role}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 28),
                // شبكة الكروت (Cards Grid) بتباعد مناسب ونسبة أبعاد محسنة
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    // نسبة أبعاد محسنة لتفادي تجاوز المساحة
                    childAspectRatio: 0.95,
                    children: [
                      // كل كارت مصمم باستخدام CustomStatCard المُعدل
                      CustomStatCard(
                        title: "Patients",
                        count: patientCount,
                        icon: Icons.people,
                        primaryColor: Color(0xFF6366F1),
                        secondaryColor: Color(0xFF4338CA),
                      ),
                      CustomStatCard(
                        title: "Doctors",
                        count: doctorCount,
                        icon: Icons.medical_services,
                        primaryColor: Color(0xFF10B981),
                        secondaryColor: Color(0xFF059669),
                      ),
                      CustomStatCard(
                        title: "Appointments",
                        count: appointmentCount,
                        icon: Icons.calendar_today,
                        primaryColor: Color(0xFFF59E0B),
                        secondaryColor: Color(0xFFD97706),
                      ),
                      if (widget.role.toLowerCase() == "admin")
                        CustomStatCard(
                          title: "Users",
                          count: userCount,
                          icon: Icons.supervised_user_circle,
                          primaryColor: Color(0xFF8B5CF6),
                          secondaryColor: Color(0xFF7C3AED),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget مخصص لتصميم الكروت (Cards) بطريقة عالمية وأنيقة
class CustomStatCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;

  const CustomStatCard({
    Key? key,
    required this.title,
    required this.count,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // خلفية الكارت بتدرج لوني وحواف دائرية
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: secondaryColor.withOpacity(0.4),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // تفاعل عند الضغط على الكارت (يمكن تعديله حسب الحاجة)
            print('$title card tapped');
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              // توزيع المحتويات داخل الكارت بشكل متناسق
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // أيقونة الكارت داخل دائرة شفافة
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12),
                // عنوان الكارت
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.95),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                // قيمة العدد مع حجم خط أكبر
                Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
