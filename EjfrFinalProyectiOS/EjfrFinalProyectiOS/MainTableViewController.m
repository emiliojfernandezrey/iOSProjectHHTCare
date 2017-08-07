//
//  MainTableViewController.m
//  EjfrFinalProyectiOS
//
//  Created by cice on 19/7/17.
//
//

#import "MainTableViewController.h"
#import "DataBase.h"
#import "Utils.h"

@interface MainTableViewController ()

@property (nonatomic,strong) NSMutableArray *bledDataArray;
@property (nonatomic, strong) NSArray *bledArray;

//DataBase proterty
@property (nonatomic,strong) DataBase *database;

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[Utils defaultBackgroundColor]];
    
    //Init database instance
    self.database = [[DataBase alloc] init];
    //load database data
    [self.database loadDatabase];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setBackgroundColor:[Utils defaultCellTableViewBackgroundColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){//index = 0 New Bleeding
        [self performSegueWithIdentifier:@"AddBleding" sender:nil];
    }
}*/

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"AddBleeding"]){
        UINavigationController *navController = segue.destinationViewController; //recuperamos el control de navegacion
        
        NewBledTableViewController *destination = //accedemos a la escena raiz
        (NewBledTableViewController *) navController.topViewController; //topviewController es la vista raiz del control de navegacion
        
    }
}



@end
