//
//  NFChelper.swift
//  Pet Universal
//
//  Created by students@deti on 04/12/17.
//  Copyright © 2017 pet@ua.pt. All rights reserved.
/*

import Foundation
import CoreNFC

class NCFHelper: NCFNDEFReaderDelegate{
    func restartSession() {
        let session = NCFNDEFReaderSession (delegate:self, queue: nil, invalidateAfterFirstRead: true)
        session.begin()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error:Error) {
        NSLog("NFC ERROR %@", "didInvalidateWithError")
        session.invalidateSession //Stop Reader
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        for message in messages {
            for record in message.records {
                print(record.payload)
            }
        }
        session.invalidateSession //Stop Reader
    }
}
 */
