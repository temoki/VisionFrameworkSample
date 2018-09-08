//
//  TextDetectionViewController.swift
//  VisionAPI
//
//  Created by temoki on 2017/06/08.
//  Copyright © 2017年 temoki. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class TextDetectionViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var resultView: TextDetectionResultView!
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
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
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        var textObservations: [VNTextObservation]?
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        defer {
            CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
            self.resultView.observations = textObservations
        }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: 6)
        let request = VNDetectTextRectanglesRequest()
        request.reportCharacterBoxes = true
        
        do {
            try handler.perform([request])
        } catch let error {
            print(error)
        }
        
        guard let results = request.results, !results.isEmpty else {
            print("NotFound")
            return
        }
        
        textObservations = results.flatMap({ $0 as? VNTextObservation })
    }
    
}
