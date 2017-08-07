//
//  HistoryTableViewController.h
//  EjfrFinalProyectiOS
//
//  Created by Eve Moon on 20/7/17.
//
//

#import <UIKit/UIKit.h>
#import "Bleed+CoreDataClass.h"
#import "EditBledTableViewController.h"

@interface HistoryTableViewController : UITableViewController <EditBledTableViewControllerDelegate>
@property (nonatomic, strong) Bleed *selectedBleed;
@end
