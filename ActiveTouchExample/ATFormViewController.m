//
//  ATFormViewController.m
//  ActiveTouchExample
//
//  Created by Lucas Medeiros on 12/02/13.
//  Copyright (c) 2013 ActiveTouch. All rights reserved.
//

#import "ATFormViewController.h"
#import "Car.h"

@interface ATFormViewController ()

@end

@implementation ATFormViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.modelTextField.text = self.car.model;
    self.yearTextField.text = self.car.year;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UIView *view = [self.view viewWithTag:([textField tag] + 1)];
    if (view) {
        [view becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Actions

- (IBAction)closeButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonTapped
{
    [self.view endEditing:YES];
    self.car.model = self.modelTextField.text;
    self.car.year = self.yearTextField.text;
    
    if (self.car._id) {
    
        [self.car updateWithSuccessBlock:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        } withErrorBlock:^(NSError *error) {
            NSLog(@"Error: %@", error);
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Car cannot be updated" delegate:nil cancelButtonTitle:@"OK!" otherButtonTitles:nil, nil];
            [view show];
        }];
        
    } else {
    
        [self.car createWithSuccessBlock:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        } withErrorBlock:^(NSError *error) {
            NSLog(@"Error: %@", error);
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Car cannot be created" delegate:nil cancelButtonTitle:@"OK!" otherButtonTitles:nil, nil];
            [view show];
        }];
        
    }

}

@end
