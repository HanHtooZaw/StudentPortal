//
//  SPDocumentViewController.h
//  Student Portal
//
//  Created by Han Htoo Zaw on 1/5/16.
//  Copyright © 2016 HHZ. All rights reserved.
//

#import "ViewController.h"
#import "SPApiClient.h"
@import QuickLook;

@interface SPDocumentViewController : QLPreviewController

@property (nonatomic, strong) NSString *documentTitle;

@end
