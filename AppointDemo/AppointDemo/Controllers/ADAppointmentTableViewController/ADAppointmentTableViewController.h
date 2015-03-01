//
//  ADAppointmentTableViewController.h
//  AppointDemo
//
//  Created by Vijay Tholpadi on 2/28/15.
//  Copyright (c) 2015 TheGeekProjekt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ADAppointmentDetailViewController.h"


@interface ADAppointmentTableViewController : UITableViewController<ADAppointmentDetailViewControllerDelegate,NSFetchedResultsControllerDelegate>

@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;

@end
