//
//  NFCViewController2.m
//  Pet Universal
//
//  Created by students@deti on 04/12/17.
//  Copyright © 2017 pet@ua.pt. All rights reserved.
/*

#import "NFCViewController2.h"

@interface NFCViewController2 ()

@end

@implementation NFCViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    NFCNDEFReaderSession *session = [[NFCNDEFReaderSession alloc] initWithDelegate:self queue:dispatch_queue_create(NULL,DISPATCH_QUEUE_CONCURRENT) invalidateAfterFirstRead:NO];
    [session beginSession];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Delegate back call
- (void) readerSession:(nonnull NFCNDEFReaderSession *)session didDetectNDEFs:(nonnull NSArray<NFCNDEFMessage *> *)messages {
    
    for (NFCNDEFMessage *message in messages) {
        for (NFCNDEFPayload *payload in message.records) {
            NSLog(@"Payload data:%@",payload.payload);
        }
    }
}

- (void)readerSession:(nonnull NFCNDEFReaderSession *)session didInvalidateWithError:(nonnull NSError *)error {
    [session invalidateSession]; //stop the reader
}
//
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//@end
