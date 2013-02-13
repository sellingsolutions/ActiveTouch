//
//  ATViewController.m
//  ActiveTouchExample
//
//  Created by Lucas Medeiros on 09/02/13.
//  Copyright (c) 2013 ActiveTouch. All rights reserved.
//

#import "ATViewController.h"
#import "ATFormViewController.h"
#import "Car.h"

@interface ATViewController ()

@property (nonatomic, strong) NSMutableArray *cars;

@end

@implementation ATViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadCars];
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cars count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Car *car = [self.cars objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"carCell"];
    cell.textLabel.text = car.model;
    cell.detailTextLabel.text = car.year;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Car *car = [self.cars objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"carSegue" sender:car];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Car *car = [self.cars objectAtIndex:indexPath.row];
        [car destroyWithSuccessBlock:^{
            
            [self.cars removeObject:car];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        } withErrorBlock:^(NSError *error) {
            NSLog(@"Error: %@", error);
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Car cannot be destroyed" delegate:nil cancelButtonTitle:@"OK!" otherButtonTitles:nil, nil];
            [view show];
        }];
        
    }
}

#pragma mark - Actions

- (IBAction)addButtonTapped:(id)sender
{
    [self performSegueWithIdentifier:@"carSegue" sender:[[Car alloc] init]];
}

- (IBAction)refreshButtonTapped:(id)sender
{
    [self loadCars];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"carSegue"]) {
        ATFormViewController *controller = segue.destinationViewController;
        controller.car = sender;
    }
}

#pragma mark - Private methods

- (void)loadCars
{
    [Car allWithSuccessBlock:^(NSArray *collection) {
        self.cars = [NSMutableArray arrayWithArray:collection];
        [self.tableView reloadData];
    } withErrorBlock:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
