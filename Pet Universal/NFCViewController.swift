//
//  NFCViewController.swift
//  Pet Universal
//
//  Created by students@deti on 04/12/17.
//  Copyright © 2017 pet@ua.pt. All rights reserved.
/*

import UIKit
import CoreNFC

class NFCViewController: UIViewController, NFCNDEFReaderSessionDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let session = NFCNDEFReaderSession(delegate: self,
                                           queue: DispatchQueue(label: "queueName", attributes: .concurrent), invalidateAfterFirstRead: false)
        session?.begin()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //Delegate backcall
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        for message in messages {
            for record in message.records {
                print(record.payload)
            }
        }
        session.invalidateSession //Stop Reader
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
}
 */
