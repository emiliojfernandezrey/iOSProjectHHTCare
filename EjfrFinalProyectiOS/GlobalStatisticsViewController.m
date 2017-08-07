//
//  GlobalStatisticsViewController.m
//  EjfrFinalProyectiOS
//
//  Created by Eve Moon on 23/7/17.
//
//

#import "GlobalStatisticsViewController.h"
#import "Bleed+CoreDataClass.h"
#import "DataBase.h"
#import "Utils.h"

@interface GlobalStatisticsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *dayAverageLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property(nonatomic,strong) DataBase *database;
@property(nonatomic,strong) NSArray * bleedings;

@end

@implementation GlobalStatisticsViewController

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

    int month=0;
    int year=0;
    int total=0;
    NSDate * lastDate;
    for(int i = 0;i<self.bleedings.count;i++){
        Bleed * bleed = self.bleedings[i];

        int differenceDays = [Utils getDaysBetweenDate1: bleed.date date2:currentDate];
        
        //Si estamos en los ultimos 30 días
        //Si estamos en el ultimos 365 días
        if(differenceDays<=365){
            if(differenceDays<=30){
                month+=1;
            }
            year+=1;
        }
        total+=1;
        if(i==self.bleedings.count-1){
            lastDate = bleed.date;
        }
    }
    
    NSString * monthMsg = [NSString stringWithFormat:@"During last month: %d",month];
    NSString * yearMsg = [NSString stringWithFormat:@"During last year: %d",year];
    NSString * totalMsg = [NSString stringWithFormat:@"Total since %@: %d",[Utils getDateFormatterStringWithDefaultFormatFrom:lastDate],total];
    
    int totalDays = [Utils getDaysBetweenDate1:lastDate date2:currentDate];
    double averageDay = total / (double) totalDays;
    NSString * dayMsg =[NSString stringWithFormat:@"Average per day: %.02f", averageDay];
    
    self.dayAverageLabel.text = dayMsg;
    self.lastMonthLabel.text =monthMsg;
    self.lastYearLabel.text=yearMsg;
    self.totalLabel.text =totalMsg;
}

-(int) getMonthBefore: (int) month{
    if(month>1){
        return month-=1;
    }else{
        return 12;
    }
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
