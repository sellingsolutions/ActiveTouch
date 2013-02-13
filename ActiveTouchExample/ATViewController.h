//
//  ATViewController.h
//  ActiveTouchExample
//
//  Created by Lucas Medeiros on 09/02/13.
//  Copyright (c) 2013 ActiveTouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

@end
