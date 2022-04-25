import 'package:mpsc_demo/datamodels/coremx.dart';
import 'package:mpsc_demo/datamodels/participants.dart';

class Conference {
  List<Participants> participants;
  List<Participants> owners;
  String id;
  CoreMX coreMX;
  Conference(this.id, this.participants, this.owners, this.coreMX);
  Conference.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    coreMX = CoreMX.fromJson(json['coremx']);
    for (var i in json['participants'])
      participants.add(Participants.fromJson(i));
    for (var i in json['owners']) participants.add(Participants.fromJson(i));
  }
}
