package
{
    import flash.display.Sprite;
    import flash.net.NetConnection;
    import flash.net.NetStream;
    import flash.events.NetStatusEvent;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.NetStatusEvent;
    import flash.events.StatusEvent;
    import flash.media.Camera;
    import flash.media.Microphone;
    import flash.media.Video;
    import flash.external.ExternalInterface;
    import flash.text.TextField;
    import flash.system.Security;

    public class Recorder extends Sprite
    {
        private var activeConnection:NetConnection;
        private var activeCamera:Camera;
        private var activeMic:Microphone;
        private var activeStream:NetStream;
        private var cameraReady:Boolean = false;
        private var connected:Boolean = false;
        private var video:Video;
        private var currentState:String= '';

        public function Recorder():void
        {
            init();
        }

        private function init():void
        {
            video = new Video(320, 240);
            video.smoothing = true;
            video.x = 10;
            video.y = 10;
            addChild(video);
            Security.allowDomain('*');
            if (ExternalInterface.available) {
                try {
                    ExternalInterface.addCallback("connect", connect);
                    ExternalInterface.addCallback("disconnect", disconnect);
                    ExternalInterface.addCallback("startRecording", startRecording);
                    ExternalInterface.addCallback("stopRecording", stopRecording);
                } catch (error:Error) {
                    setCurrentState("An Error occurred: " + error.message + "\n");
                }
            }
        }

        public function connect(rtmpUrl):void {
            activeConnection = new NetConnection();
            activeConnection.client = this;
            activeConnection.addEventListener(NetStatusEvent.NET_STATUS, connectionStatusChanged, false, 0, true);
            activeConnection.connect(rtmpUrl);
        }

        public function disconnect():void {
            if(activeConnection != null) {
                activeConnection.close();
                activeConnection.removeEventListener(NetStatusEvent.NET_STATUS, connectionStatusChanged);
                activeConnection = null;
            }
        }

        public function startRecording(recordingFileName):void {
            setCurrentState("recording");
            activeCamera = Camera.getCamera();
            activeMic = Microphone.getMicrophone();
            activeMic.setSilenceLevel(0);
            activeMic.gain = 50;
            video.attachCamera(activeCamera);
            activeStream = new NetStream(activeConnection);
            activeStream.attachCamera(activeCamera);
            activeStream.attachAudio(activeMic);
            activeStream.publish(recordingFileName + "_video", "record");
        }

        public function stopRecording():void {
            setCurrentState("connected");
            activeStream.attachCamera(null);
            activeStream.attachAudio(null);
            activeStream.close();
        }

        private function cameraStatusChanged(status:StatusEvent):void {
            trace("CameraStatus - " + e.code);
            switch(status.code) {
                case 'Camera.muted':
                    trace("Camera muted");
                    break;
                case 'Camera.Unmuted':
                    cameraReady = true;
                    break;
            }
        }

        private function connectionStatusChanged(statusEvent:NetStatusEvent):void {
            trace("connectionStatusChanged:" + statusEvent.info.code );
            if(statusEvent.info.code == 'NetConnection.Connect.Success') {
                connected= true;
                setCurrentState("connected");
            }
        }

        private function streamStatusChanged(statusEvent:NetStatusEvent):void {
            setCurrentState(statusEvent.info.code);
            trace("streamStatusChanged:" + statusEvent.info.code );
            // 'NetStream.Buffer.Empty', 'NetStream.Buffer.Full','NetStream.Buffer.Flush'
        }

        private function setCurrentState(state:String):void {
            currentState = state;
            ExternalInterface.call("setRecordingStatus", currentState);
        }

    }
}