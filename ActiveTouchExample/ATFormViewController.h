//
//  ATFormViewController.h
//  ActiveTouchExample
//
//  Created by Lucas Medeiros on 12/02/13.
//  Copyright (c) 2013 ActiveTouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Car;

@interface ATFormViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) Car *car;
@property (weak, nonatomic) IBOutlet UITextField *modelTextField;
@property (weak, nonatomic) IBOutlet UITextField *yearTextField;

@end
