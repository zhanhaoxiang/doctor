import 'package:get/get.dart';

class DetailController extends GetxController {
  final hospital = '北京协和医院'.obs;
  final dept = '呼吸内科 · 门诊';
  final visitTime = '2026-03-08 09:22';
  final member = '妈妈';
  final complaint = '咳嗽2周，伴轻微发热';
  final diagnosis = '急性支气管炎';
  final aiSummary = '患者咳嗽2周，X线影像提示轻度炎症，无发热，血常规正常。医嘱：布洛芬按需服用，多饮水，3天后复诊。';
  final doctorOrder = '布洛芬10ml，每8小时一次；多饮水；3天后复诊。';
  final examItems = ['胸部X线', '血常规', '肺功能'];
  final medications = ['布洛芬', '阿莫西林'];
  final recordNo = 'MR-2026-001';
  final source = '手动录入';
}
