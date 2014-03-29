//
//  Quiz6ViewController.m
//  Quiz6
//
//  Created by Arek Bolton on 3/28/14.
//  Copyright (c) 2014 Arek Bolton. All rights reserved.
//

#import "Quiz6ViewController.h"
#import "Task.h"
#import "Quiz6DetailViewController.h"

@interface Quiz6ViewController ()

@end

@implementation Quiz6ViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [tasks sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Task *t1=obj1;
        Task *t2 = obj2;
        return [t1.dueDate compare:t2.dueDate];
    }];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"My Tasks"];
    tasks = [[NSMutableArray alloc] init];
    [self.tableView setDelegate: self];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    for (int i=0; i<10; i++) {
        Task *task = [[Task alloc] init];
        [task setTaskName:[NSString stringWithFormat:@"Task %d",i]];
        [task setUrgency:i];
        [task setDueDate:[NSDate dateWithTimeIntervalSinceNow:i*60.0*60.0*24.0]];
        [tasks addObject:task];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [tasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell = [cell initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    // Configure the cell...
    Task *t = [tasks objectAtIndex:[indexPath row]];
    [cell.textLabel setText:[t taskName]];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle: NSDateFormatterLongStyle];
    [cell.detailTextLabel setText:[df stringFromDate:t.dueDate]];
    if (t.urgency > 6) {
        [[cell imageView] setImage:[UIImage imageNamed:@"urgent.jpg"]];
    } else {
        [[cell imageView] setImage: nil];
    }
    cell.contentView.backgroundColor = [UIColor colorWithRed:(t.urgency/10) green:(1-(t.urgency/10)) blue:0 alpha:.3];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Quiz6DetailViewController *dvc = [[Quiz6DetailViewController alloc] initWithNibName:@"Quiz6DetailViewController" bundle:nil];
    [dvc setTask:[tasks objectAtIndex:[indexPath row]]];
    [self.navigationController setModalPresentationStyle: UIModalTransitionStyleCrossDissolve];
    [self presentModalViewController:dvc animated:YES];
    
}

@end
