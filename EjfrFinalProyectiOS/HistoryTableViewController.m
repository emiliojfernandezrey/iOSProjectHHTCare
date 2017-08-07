//
//  HistoryTableViewController.m
//  EjfrFinalProyectiOS
//
//  Created by Eve Moon on 20/7/17.
//
//

#import "HistoryTableViewController.h"
#import "DataBase.h"
#import "BleedingTableViewCell.h"
#import "Utils.h"

@interface HistoryTableViewController ()
@property (nonatomic,strong) DataBase *database;

@property (nonatomic, strong) NSArray *bleedings;


@end

@implementation HistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[Utils defaultBackgroundColor]];
    
    self.bleedings = [NSMutableArray array];
    self.database = [DataBase defaultDatabase];
    [self reloadRows];
    
    //init selected bleeding value
    if(self.bleedings!=nil && self.bleedings>0){
        self.selectedBleed = self.bleedings[0];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setBackgroundColor:[Utils defaultCellTableViewBackgroundColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.bleedings!=nil && self.bleedings.count>0){
        return self.bleedings.count;
    }
    return 0;
}

- (void)reloadRows
{
    //Creamos consulta a la DB
    //Aqui añadimos una variable para que refresque los datos de la DB cada vez que se recargue la tabla
    NSFetchRequest * contactsRequest = [Bleed fetchRequest]; //Esta consulta no tiene ninguna clausula WHERE por lo que devuelve la tabla completa
    
    //Filtro los contactos por predicado
    NSSortDescriptor *dateShortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:false];//ordenado por date
    contactsRequest.sortDescriptors = @[dateShortDescriptor]; //ordenamos por date
    
    NSError *fetchError;
    self.bleedings = [self.database.moc executeFetchRequest:contactsRequest error:&fetchError];
    
    for (int i=0; i< self.bleedings.count; i++) {
        Bleed *bleeding = self.bleedings[i];
        //NSLog(@"Bleedings[%d]=%@",i,[Utils getDateFormatterStringWithDefaultFormatFrom: bleeding.date]);
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"HistoryTVC viewWillAppear");
    [super viewWillAppear:animated];
    
    [self reloadRows];
    
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Bleed *bleeding;
    BleedingTableViewCell *cell;
    
    if(indexPath.section == 0){
        bleeding = self.bleedings[indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:@"bleedingCell" forIndexPath:indexPath];
    }
    NSString *msg = [NSString stringWithFormat:@"%@ - %@", [Utils getDateFormatterStringWithDefaultFormatFrom:bleeding.date], bleeding.area];
    cell.dateBleedingLabel.text = msg;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectedRowAtIndexPAth: %d, bleedings.count: %d",(int) indexPath.row, (int) self.bleedings.count);
    
    //[self performSegueWithIdentifier:@"EditBleeding" sender:self.selectedBleed];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"prepareForSegue %@",segue.identifier);
    
    if([segue.identifier isEqualToString:@"EditBleeding"]){
        
        UINavigationController *navController = segue.destinationViewController; //recuperamos el control de navegacion
        EditBledTableViewController *destination = (EditBledTableViewController *) navController.topViewController; //topviewController es la vista raiz del control de navegacion
        self.selectedBleed = self.bleedings[self.tableView.indexPathForSelectedRow.row];
        destination.bleed = self.selectedBleed;
        
        destination.delegate = self;
        
        NSLog(@"HistoryTVC prepareForSegue %@",self.selectedBleed.area);
        
        //Le decimos a la escena de control que el delegado soy yo
        
    }
}

-(void)doneEdition:(Bleed *)bleed
{
    //   [self.contacts addObject:contact];
    [self.database saveDatabase];//Con esto confirmamos que se guarden los datos
    [self dismissViewControllerAnimated:true completion:nil];
    
}

-(void)cancelEdition
{
    [self dismissViewControllerAnimated:true completion:nil];
}


@end
