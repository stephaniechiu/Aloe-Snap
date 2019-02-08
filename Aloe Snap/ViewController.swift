//
//  ViewController.swift
//  Aloe Snap
//
//  Created by Stephanie on 2/7/19.
//  Copyright © 2019 Stephanie Chiu. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
//Manages all camera inputs and outputs data
    let session = AVCaptureSession()
    var camera: AVCaptureDevice?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var cameraCaptureOutput: AVCapturePhotoOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
       initializeCaptureSession()
    }

//What users see in their preview screen when camera is open
    func initializeCaptureSession() {
        session.sessionPreset = AVCaptureSession.Preset.high
        
        camera = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        
        do{
            let cameraCaptureInput = try AVCaptureDeviceInput (device: camera!)
            cameraCaptureOutput = AVCapturePhotoOutput()
            
            session.addInput(cameraCaptureInput)
            session.addOutput(cameraCaptureOutput!)
            
        } catch {
            print(error.localizedDescription)
        }
    
        cameraPreviewLayer = AVCaptureVideoPreviewLayer.init(session: session)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.frame = view.bounds
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        
        
        view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        
        session.startRunning()
    }
    
    //User takes photo
    func takePicture() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        cameraCaptureOutput?.capturePhoto(with: settings, delegate: self)
    }

}

func displayCapturedPhoto(capturedPhoto:UIImage) {
    
}

extension ViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        let imageData = photo.fileDataRepresentation()
        
        // Check if there is any error in capturing
        if let unwrappedError = error {
            print("Fail to capture photo: \(String(unwrappedError.localizedDescription))")
        } else {
        
        // Check if UIImage could be initialized with image data
            if let capturedImage = UIImage(data: imageData!) {
            displayCapturedPhoto(capturedPhoto: capturedImage)
            }
            else {
                print("Fail to convert image data to UIImage")
                return
        }
    }
}
}
