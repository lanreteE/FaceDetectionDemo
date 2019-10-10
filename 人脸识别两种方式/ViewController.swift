//
//  ViewController.swift
//  人脸识别两种方式
//
//  Created by 王译 on 2019/9/23.
//  Copyright © 2019 王译. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureMetadataOutputObjectsDelegate {
    
    var captureDevice : AVCaptureDevice?
    var captureInput : AVCaptureDeviceInput?
    var captureOutput : AVCaptureVideoDataOutput!
    var metaOutput : AVCaptureMetadataOutput!
    var capturePreViewLayer : AVCaptureVideoPreviewLayer?
    var captureSession : AVCaptureSession?
    var index = 0
    let detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .high
        captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)!
        captureInput = try! AVCaptureDeviceInput(device: captureDevice!)
        captureSession?.addInput(captureInput!)

        captureOutput = AVCaptureVideoDataOutput()
        captureSession!.addOutput(captureOutput)
        captureOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        captureOutput.videoSettings = [:]
        
//        metaOutput = AVCaptureMetadataOutput()
//        metaOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//        captureSession?.addOutput(metaOutput)
//        metaOutput.metadataObjectTypes = [.face]
        
        capturePreViewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        capturePreViewLayer?.frame = self.view.frame
        capturePreViewLayer?.videoGravity = .resizeAspectFill
        self.view.layer.insertSublayer(capturePreViewLayer!, at: 0)
        self.captureSession?.startRunning()
        
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        let imageBuffer: CVImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        let ciImage = CIImage(cvImageBuffer: imageBuffer)
        let faceArr = detector?.features(in: ciImage, options: nil)
        
        for r in faceArr!{
            let faceFeature = r as! CIFaceFeature
            if faceFeature.hasLeftEyePosition && faceFeature.hasRightEyePosition && faceFeature.hasMouthPosition{
                print("识别到人脸...")
                index += 1
                //  手动增加识别时间,提高稳定性,防止图片模糊等
                if index > 10{
                    print("识别结束")
                    captureSession?.stopRunning()
                    index = 0
                    let temporaContext = CIContext(options: nil)
                    let cgImageRef = temporaContext.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(imageBuffer), height: CVPixelBufferGetHeight(imageBuffer)))
                    let resultImage = UIImage.init(cgImage: cgImageRef!, scale: 1, orientation: .leftMirrored)
                    //  orientation不起作用
//                    let resultImage = UIImage.init(ciImage: ciImage, scale: 1, orientation: .leftMirrored)
                    let vc = NextViewController()
                    vc.imgView.image = resultImage
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        Thread.sleep(forTimeInterval: 0.3)
    }
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for face in metadataObjects{
            print("检测到人脸了, faceId = ",(face as? AVMetadataFaceObject)?.faceID)
        }
    }
}
