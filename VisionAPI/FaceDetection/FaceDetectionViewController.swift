//
//  FaceDetectionViewController.swift
//  VisionAPI
//
//  Created by temoki on 2017/06/08.
//  Copyright © 2017年 temoki. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class FaceDetectionViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var resultView: FaceDetectionResultView!
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)!
        let input = try! AVCaptureDeviceInput(device: device)
        captureSession.addInput(input)
        
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue.global())
        captureSession.addOutput(output)
        
        let layer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.videoView.layer.addSublayer(layer)
        self.previewLayer = layer
        
        self.resultView.backgroundColor = .clear
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.previewLayer?.frame = self.videoView.bounds
        captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        var faceObservation: VNFaceObservation?
        
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        defer {
            CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
            self.resultView.observation = faceObservation
        }
        
        /*
        let request = VNDetectFaceLandmarksRequest(completionHandler: { [unowned self] (request, error) in
            var observation: VNFaceObservation?
            defer { self.resultView.observation = observation }
            if let error = error { print(error); return }
            guard let result = request.results?.first else { print("NotFound"); return }
            observation = result as? VNFaceObservation
        })
        */
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: 5)
        let request = VNDetectFaceLandmarksRequest()
        
        do {
            try handler.perform([request])
        } catch let error {
            print(error)
        }
        
        guard let result = request.results?.first else {
            print("NotFound")
            return
        }
        
        faceObservation = result as? VNFaceObservation
    }
    
}
