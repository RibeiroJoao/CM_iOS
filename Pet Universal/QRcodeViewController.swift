//
//  QRcodeViewController.swift
//  Pet Universal
//
//  Created by students@deti on 27/11/17.
//  Copyright © 2017 pet@ua.pt. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class QRcodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{
    
    var video = AVCaptureVideoPreviewLayer()
    @IBOutlet weak var square: UIImageView!
    var QRcontent = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Start Session
        let session = AVCaptureSession()
        
        //Define capture device
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do{
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        }catch{
            NSLog("ERROR in QRcode");
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        video = AVCaptureVideoPreviewLayer(session: session)
        
        //fill screen
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        
        self.view.bringSubview(toFront: square)
        
        //start the session
        session.startRunning()
        
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if (metadataObjects != nil && metadataObjects.count != 0){
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{
                if object.type == AVMetadataObjectTypeQRCode{
                    QRcontent = object.stringValue;
                    let alert = UIAlertController(title: "Nome do Animal:", message: object.stringValue, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Outra vez", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Seguir", style: .default, handler:  {action in self.performSegue(withIdentifier:"QRSegueAnimal", sender: nil)}))
                    present (alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "QRSegueAnimal"{
            let tri = AnimalViewController()
            tri.localAnimalID = "1"

            //let aVC = segue.destination as! AnimalViewController
            //aVC.localAnimalID = "1"
            
            //let nav: UINavigationController = segue.destination as! UINavigationController
            //let addEventViewContro ller = nav.topViewController as! AnimalViewController
            //addEventViewController.localAnimalID = "0";
            
            NSLog("    YEP!!!!    %@", QRcontent);
            //NSLog("    YEP!!!!    %@", aVC.localAnimalID);
        }
    }
    
}
