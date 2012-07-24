//
//  ViewController.h
//  LockBox
//
//  Created by Mark H. Granoff on 4/19/12.
//  Copyright (c) 2012 Hawk iMedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

@property ( nonatomic) IBOutlet UITextField *inputTextField;
@property ( nonatomic) IBOutlet UIButton *saveButton;
@property ( nonatomic) IBOutlet UIButton *fetchButton;
@property ( nonatomic) IBOutlet UILabel *fetchedValueLabel;
@property ( nonatomic) IBOutlet UILabel *statusLabel;

@end
