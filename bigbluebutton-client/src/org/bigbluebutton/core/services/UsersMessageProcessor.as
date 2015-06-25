package org.bigbluebutton.core.services
{
  import org.bigbluebutton.core.vo.UserVO;
  import org.bigbluebutton.core.vo.VoiceUserVO;

  public class UsersMessageProcessor
  {
    private static const LOG:String = "Users::UsersMessageProcessor - ";
    
    public function processUserJoinedVoiceMessage(voiceUser:Object):VoiceUserVO {
      trace(LOG + "*** processUserJoinedVoiceMessage **** \n"); 
      if (voiceUser != null) {
        return processVoiceUser(voiceUser);
      }
      
      return null;
    }
    
    public function processUserLeftVoiceMessage(voiceUser:Object):VoiceUserVO {
      trace(LOG + "*** processUserLeftVoiceMessage **** \n"); 
      if (voiceUser != null) {
        return processVoiceUser(voiceUser);
      }
      
      return null;      
    }
    
    private function processVoiceUser(vu: Object):VoiceUserVO {     
      var vuv: VoiceUserVO = new VoiceUserVO;
      vuv.id = vu.userId;
      vuv.webId = vu.webUserId;
      vuv.name = vu.callerName;
      vuv.number = vu.callerNum;
      vuv.joined = vu.joined;
      vuv.locked = vu.locked;
      vuv.muted = vu.muted;
      vuv.talking = vu.talking;
      return vuv;      
    }
    
    private function processUser(u: Object):UserVO {
      var nu: UserVO = new UserVO();
      nu.id = u.id;
      nu.externId = u.externUserID;
      nu.name = u.name;
      nu.role = u.role;
      nu.handRaised = u.handRaised;
      nu.presenter = u.presenter;
      nu.hasStream = u.hasStream;
      nu.webcamStream = u.webcamStream;
      nu.locked = u.locked;
      nu.voiceUser = processVoiceUser(u.voiceUser as Object);
      nu.customData = u.customData;      
      
      return nu;
    }
    
    public function processUserJoinedMessage(user: Object):UserVO {
      return processUser(user);
    }
    
    public function processUserLeftMessage(user: Object):UserVO {
      return processUser(user);
    }
    
    public function processUserMutedMessage(msg: Object):Object {
      var userId: String = msg.userId;
      var voiceUserId: String = msg.voiceUserId;
      var muted:Boolean = msg.muted;
      
      return {userId: userId, voiceId: voiceUserId, muted: muted};
    }
    
    public function processUserTalkingMessage(msg: Object):Object {
      var userId: String = msg.userId;
      var voiceUserId: String = msg.voiceUserId;
      var talking:Boolean = msg.talking;
      
      return {userId: userId, voiceId: voiceUserId, talking: talking};      
    }
  }
}