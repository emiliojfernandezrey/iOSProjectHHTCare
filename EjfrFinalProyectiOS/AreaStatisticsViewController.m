//
//  AreaStatisticsViewController.m
//  EjfrFinalProyectiOS
//
//  Created by Eve Moon on 24/7/17.
//
//

#import "AreaStatisticsViewController.h"
#import "Utils.h"
#import "DataBase.h"
#import "Bleed+CoreDataClass.h"

@interface AreaStatisticsViewController ()
{
    NSMutableArray * areasFound;
}
@property (weak, nonatomic) IBOutlet UILabel *areaStatisticsLabel;

@property(nonatomic,strong) DataBase *database;
@property(nonatomic,strong) NSArray * bleedings;

@end

@implementation AreaStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[Utils defaultBackgroundColor]];
    
    self.database = [DataBase defaultDatabase];
    
    //Creamos consulta a la DB
    //Aqui añadimos una variable para que refresque los datos de la DB cada vez que se recargue la tabla
    NSFetchRequest * contactsRequest = [Bleed fetchRequest]; //Esta consulta no tiene ninguna clausula WHERE por lo que devuelve la tabla completa
    
    //Filtro los contactos por predicado
    NSSortDescriptor *dateShortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:false];//ordenado por date
    contactsRequest.sortDescriptors = @[dateShortDescriptor]; //ordenamos por date
    
    NSError *fetchError;
    self.bleedings = [self.database.moc executeFetchRequest:contactsRequest error:&fetchError];
    
    NSDate *currentDate = [NSDate date];
    
    NSDate * lastDate;
    areasFound = [[NSMutableArray alloc] init];
    
    for(int i = 0;i<self.bleedings.count;i++){
        
        Bleed * bleed = self.bleedings[i];
        
        //if not found
        if(![self areaFound:areasFound other: bleed.area]){
            NSArray * array = [NSArray arrayWithObjects:bleed.area,[NSString stringWithFormat:@"%d",1],nil];
            [areasFound addObject:array];
        }else{
            int position = [self areaIndex:areasFound other: bleed.area];
            if(position>=0){
                NSArray * aux= areasFound[position];
                NSString* areaAux= aux[0] ;
                int cont = [aux[1] intValue];
                cont+=1;
                //aux[1]= [NSString stringWithFormat:@"%d",cont];
                NSArray * array = [NSArray arrayWithObjects:areaAux,[NSString stringWithFormat:@"%d",cont],nil];
                areasFound[position]= array;
            }
        }
        
        if(i==self.bleedings.count-1){
            lastDate = bleed.date;
        }
    }
    
    int totalDays= [Utils getDaysBetweenDate1:lastDate date2:currentDate];
    
    NSMutableString * acum = [[NSMutableString alloc] initWithString:@"Number of Bleedings per Area\n\n"];
    [acum appendString: [NSString stringWithFormat:@"during last %d days: \n\n\n\n\n",totalDays]];
    
    for(int i=0;i<areasFound.count;i++){
        
        NSArray * areaArray = areasFound[i];
        NSString * areaName = areaArray[0];
        NSString * areaCont = areaArray[1];
        NSString * newRow = [NSString stringWithFormat:@"%@ total: %@\n\n",areaName, areaCont];
        [acum appendString: newRow];
    }
    [acum appendString:@"\n\n\n"];
    
    self.areaStatisticsLabel.text=acum;
}

-(bool) areaFound: (NSMutableArray*) areas other:(NSString*) other{
    for(int i =0;i<areas.count;i++){
        NSArray * aux= areas[i];
        if([aux[0] isEqualToString:other]){
            return true;
        }
    }
    return false;
}

-(int) areaIndex: (NSMutableArray*) areas other: (NSString*) other{
    for(int i =0;i<areas.count;i++){
        NSArray * aux= areas[i];
        if([aux[0] isEqualToString:other]){
            return i;
        }
    }
    return -1;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
