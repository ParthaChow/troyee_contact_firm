import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import '../../../app/core/theme/app_colors.dart';
import '../controller/signature_controller.dart';

class SignatureView extends GetView<FarmSignatureController> {
  const SignatureView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            _HeaderSection(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SummaryCard(),
                    const SizedBox(height: 24),
                    // _SignatureSection(),
                    // const SizedBox(height: 16),
                    // _ClearButton(),
                    // const SizedBox(height: 20),
                    _ConfirmationCheckbox(),
                    const SizedBox(height: 40),
                    _SubmitButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xff1A261F),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 10,
        20,
        30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Confirmation Page",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.only(left: 36),
            child: Text(
              "তথ্য নিশ্চিতকরণ",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends GetView<FarmSignatureController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _SummaryRow(
            label: "মোট মৃত্যু",
            value: controller.mortalityCount.toString(),
          ),
          const Divider(height: 32),
          _SummaryRow(
            label: "গড় ওজন",
            value: "${controller.averageWeightKg.toString()} গ্রাম",
          ),
          const Divider(height: 32),
          _SummaryRow(
            label: "খাদ্য খরচ",
            value: "${controller.totalFeedKg.toString()} কেজি",
          ),
        ],
      ),
    );
  }


}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xff212121),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff212121),
          ),
        ),
      ],
    );
  }
}
//
// class _SignatureSection extends GetView<FarmSignatureController> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Container(
//               width: 4,
//               height: 16,
//               color: const Color(0xffD79A09),
//             ),
//             const SizedBox(width: 8),
//             const Text(
//               "এখানে স্বাক্ষর করুন",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xff0F2D20),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         Container(
//           height: 250,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: const Color(0xffF9F9F9),
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(
//               color: Colors.grey.shade300,
//               style: BorderStyle.solid,
//             ),
//           ),
//           child: Stack(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 child: Signature(
//                   controller: controller.signatureController,
//                   backgroundColor: Colors.transparent,
//                   width: double.infinity,
//                   height: 250,
//                 ),
//               ),
//               IgnorePointer(
//                 child: _DashedBorder(),
//               ),
//               IgnorePointer(
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Container(
//                         width: 250,
//                         height: 1,
//                         color: Colors.grey.shade300,
//                       ),
//                       const SizedBox(height: 12),
//                       Text(
//                         "আঙুল দিয়ে এখানে স্বাক্ষর করুন",
//                         style: TextStyle(
//                           color: Colors.grey.shade400,
//                           fontSize: 12,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _DashedBorder extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: CustomPaint(
//         painter: DashedPainter(),
//         child: Container(),
//       ),
//     );
//   }
// }

// class DashedPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = Colors.grey.shade300
//       ..strokeWidth = 1
//       ..style = PaintingStyle.stroke;
//
//     final double dashWidth = 5;
//     final double dashSpace = 5;
//     final Radius radius = const Radius.circular(20);
//
//     final RRect rrect = RRect.fromLTRBR(0, 0, size.width, size.height, radius);
//     final Path path = Path()..addRRect(rrect);
//
//     for (final PathMetric metric in path.computeMetrics()) {
//       double distance = 0;
//       while (distance < metric.length) {
//         canvas.drawPath(
//           metric.extractPath(distance, distance + dashWidth),
//           paint,
//         );
//         distance += dashWidth + dashSpace;
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }
//
// class _ClearButton extends GetView<FarmSignatureController> {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: 60,
//       child: OutlinedButton(
//         onPressed: () => controller.clearSignature(),
//         style: OutlinedButton.styleFrom(
//           side: const BorderSide(color: Color(0xff0F2D20)),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//         ),
//         child: const Text(
//           "মুছে ফেলুন",
//           style: TextStyle(
//             color: Color(0xff0F2D20),
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }

class _ConfirmationCheckbox extends GetView<FarmSignatureController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          Checkbox(
            value: controller.isConfirmed.value,
            onChanged: (val) => controller.toggleConfirmation(val),
            activeColor: const Color(0xffD32F2F),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const Expanded(
            child: Text(
              "আমি নিশ্চিত করছি যে উপরের তথ্য সঠিক",
              style: TextStyle(fontSize: 14, color: Color(0xff424242)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubmitButton extends GetView<FarmSignatureController> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () => controller.submit(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff41695F),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Confirm",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, size: 20),
          ],
        ),
      ),
    );
  }
}

// Helper for Dashed Path
