//
//  ViewController.swift
//  DNLiveDemo
//
//  Created by mainone on 16/11/17.
//  Copyright © 2016年 wjn. All rights reserved.
//

import UIKit
import LFLiveKit

class ViewController: UIViewController, LFLiveSessionDelegate {
    
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var beautyButton: UIButton!
    @IBOutlet weak var startLiveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestAccessForVideo()
        self.requestAccessForAudio()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - 界面按钮操作
    // 美颜
    @IBAction func beautyBtnClick(_ sender: UIButton) {
        session.beautyFace = !session.beautyFace;
        beautyButton.isSelected = !session.beautyFace
        if beautyButton.isSelected {
            beautyButton.setImage(UIImage(named: "camra_beauty"), for: UIControlState.selected)
        } else {
            beautyButton.setImage(UIImage(named: "camra_beauty_close"), for: UIControlState())
        }
    }
    
    // 相机
    @IBAction func cameraBtnClick(_ sender: UIButton) {
        let devicePositon = session.captureDevicePosition;
        session.captureDevicePosition = (devicePositon == AVCaptureDevicePosition.back) ? AVCaptureDevicePosition.front : AVCaptureDevicePosition.back;
    }
    
    // 关闭界面
    @IBAction func closeBtnClick(_ sender: UIButton) {
        
    }
    
    // 开始直播
    @IBAction func startLiveBtnClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            startLiveButton.setTitle("结束直播", for: .normal)
            startLive()
        } else {
            startLiveButton.setTitle("开始直播", for: .normal)
            stopLive()
        }
        
    }
    
    // MARK: - LFLiveSessionDelegate
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
    
    // MARK: - 直播操作
    // 开始直播
    func startLive() {
        let stream = LFLiveStreamInfo()
        stream.url = "rtmp://192.168.3.242:1935/rtmplive/room"
        session.startLive(stream)
    }
    
    func stopLive() -> Void {
        session.stopLive()
    }
    
    // MARK: - 权限认证
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
    
    // MARK: - Getters and Setters
    lazy var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.defaultConfiguration(for: .high)
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: .low3)
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)
        session?.delegate = self
        session?.preView = self.view
        return session!
    }()
    
    
}

