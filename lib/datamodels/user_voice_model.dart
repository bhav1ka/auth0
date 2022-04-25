
enum UserVoiceStatus { connecting, disconnected, connected, echo_test }
class UserVoice
{
  int userVoiceID;
  bool isMuted;
  bool isTalking;
  String timeStamp;
  UserVoiceStatus userVoiceStatus;
  UserVoice(this.userVoiceID,this.isMuted,this.isTalking,this.timeStamp);
  set changeMuteStatus(bool isMuted){
    this.isMuted=isMuted;
  }
  set changeUserVoiceStatus(UserVoiceStatus userVoiceStatus){
    this.userVoiceStatus=userVoiceStatus;
  }
}