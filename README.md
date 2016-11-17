# DNLiveDemo
直播 LFLiveKit推流+ ijkplayer播放
## 申请摄像头和麦克风访问权限
``` swift
// 请求访问摄像头
func requestAccessForVideo() -> Void {
    let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo);
    switch status  {
    // 许可对话没有出现，发起授权许可
    case .notDetermined:
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted) in
            if(granted){
                DispatchQueue.main.async {
                    self.session.running = true
                }
            }
        })
    case .authorized:// 已经开启授权，可继续
        session.running = true
    case .denied: break// 用户明确地拒绝授权，或者相机设备无法访问
    case .restricted: break
    }
}

// 请求访问麦克风
func requestAccessForAudio() -> Void {
    let status = AVCaptureDevice.authorizationStatus(forMediaType:AVMediaTypeAudio)
    switch status  {
    case .notDetermined:// 许可对话没有出现，发起授权许可
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeAudio, completionHandler: { (granted) in
            
        })
    case .authorized: break;// 已经开启授权，可继续
    // 用户明确地拒绝授权，或者相机设备无法访问
    case .denied: break
    case .restricted:break;
    }
}
```

## 初始化
``` swift
lazy var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.defaultConfiguration(for: .high)
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: .low3)
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)
        session?.delegate = self
        session?.preView = self.view
        return session!
    }()
 ```
 ## 开始直播结束直播
 ``` swift
// 开始直播
func startLive() {
    let stream = LFLiveStreamInfo()
    stream.url = "rtmp://192.168.3.242:1935/rtmplive/room"
    session.startLive(stream)
}

func stopLive() -> Void {
    session.stopLive()
}
 ```
## LFLiveSessionDelegate代理回调
``` swift
func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
    print("debugInfo: \(debugInfo?.currentBandwidth)")
}

func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
    print("errorCode: \(errorCode.rawValue)")
}

func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
    print("liveStateDidChange: \(state.rawValue)")
    switch state {
    case LFLiveState.ready:
        stateLabel.text = "未连接"
    case LFLiveState.pending:
        stateLabel.text = "连接中"
    case LFLiveState.start:
        stateLabel.text = "已连接"
    case LFLiveState.error:
        stateLabel.text = "连接错误"
    case LFLiveState.stop:
        stateLabel.text = "未连接"
    }
}

```
 
 
 
 
 
 
