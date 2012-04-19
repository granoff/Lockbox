//
//  ViewController.h
//  LockBox
//
//  Created by Mark H. Granoff on 4/19/12.
//  Copyright (c) 2012 Hawk iMedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UITextField *inputTextField;
@property (retain, nonatomic) IBOutlet UIButton *saveButton;
@property (retain, nonatomic) IBOutlet UIButton *fetchButton;
@property (retain, nonatomic) IBOutlet UILabel *fetchedValueLabel;
@property (retain, nonatomic) IBOutlet UILabel *statusLabel;

@end
