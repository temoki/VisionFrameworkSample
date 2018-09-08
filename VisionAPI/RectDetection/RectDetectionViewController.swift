//
//  RectDetectionViewController.swift
//  VisionAPI
//
//  Created by temoki on 2017/06/08.
//  Copyright © 2017年 temoki. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class RectDetectionViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var resultView: RectDetectionResultView!
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    let requestHandler = VNSequenceRequestHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)!
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
        self.resultView.observation = nil
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        var rectObservation: VNRectangleObservation? = nil
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        defer {
            self.resultView.observation = rectObservation
            CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
        }
        
        let request: VNRequest
        if let observation = self.resultView.observation {
            print("Tracking")
            let trackRequest = VNTrackRectangleRequest(rectangleObservation: observation)
            trackRequest.isLastFrame = false
            trackRequest.trackingLevel = .accurate
            request = trackRequest
        } else {
            print("Detecting")
            let detectRequest = VNDetectRectanglesRequest()
            detectRequest.maximumObservations = 1
            request = detectRequest
        }
        
        do {
            try self.requestHandler.perform([request], on: pixelBuffer, orientation: 6)
        } catch let error {
            print(error)
            return
        }
        
        guard let result = request.results?.first else {
            print("NotFound")
            return
        }
        
        rectObservation = result as? VNRectangleObservation
    }
    
}

