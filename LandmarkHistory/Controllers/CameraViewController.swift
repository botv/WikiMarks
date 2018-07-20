//
//  ViewController.swift
//  LandmarkHistory
//
//  Created by Ben Botvinick on 7/16/18.
//  Copyright © 2018 Ben Botvinick. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var image: UIImage?
    var landmark: String?
    var findingLandmark = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
        
        instructionsLabel.attributedText = NSMutableAttributedString(string: "Take a picture of a landmark to learn about it.", attributes: stroke(strokeWidth: 1, insideColor: .white, strokeColor: .black))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.animate(withDuration: 2, animations: {
                self.instructionsLabel.alpha = 0
            }, completion: nil)
        }
    }
    
    private func stroke(strokeWidth: Float, insideColor: UIColor, strokeColor: UIColor) -> [NSAttributedStringKey: Any]{
        return [
            NSAttributedStringKey.strokeColor : strokeColor,
            NSAttributedStringKey.foregroundColor : insideColor,
            NSAttributedStringKey.strokeWidth : -strokeWidth
        ]
    }
    
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        
        currentCamera = backCamera
    }
    
    func setupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
    }
    
    func setupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    
    func startRunningCaptureSession() {
        captureSession.startRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        if (!findingLandmark) {
            print("processing")
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            findingLandmark = true;
            let settings = AVCapturePhotoSettings()
            photoOutput?.capturePhoto(with: settings, delegate: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLandmarkInfo" {
            let landmarkInfoViewController = segue.destination as! LandmarkInfoViewController
            landmarkInfoViewController.landmark = landmark
        }
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            image = UIImage(data: imageData)
            MLService.evaluateImage(for: image!) { landmarks in
                self.activityIndicator.isHidden = true
                if landmarks.isEmpty {
                    print("no landmarks found")
                    let alert = UIAlertController(title: "No Landmark Found", message: "No landmark was found in your photo. Try to take a clearer picture and get more of the landmark in the frame.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                            
                        case .cancel:
                            print("cancel")
                            
                        case .destructive:
                            print("destructive")
                        }}))
                    self.present(alert, animated: true, completion: nil)
                    self.findingLandmark = false
                    return
                }
                
                self.landmark = landmarks[0].landmark
                print("landmark found: " + self.landmark!)
                self.activityIndicator.stopAnimating()
                
                self.performSegue(withIdentifier: "toLandmarkInfo", sender: nil)
                self.findingLandmark = false
            }
        }
    }
}
