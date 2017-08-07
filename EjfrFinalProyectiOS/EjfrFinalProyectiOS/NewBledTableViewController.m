//
//  NewBledTableViewController.m
//  EjfrFinalProyectiOS
//
//  Created by Eve Moon on 19/7/17.
//
//

#import "NewBledTableViewController.h"
#import "DataBase.h"
#import "Bleed+CoreDataClass.h"
#import "Utils.h"

@interface NewBledTableViewController ()
{
    //NSNumber *latitude;
    //NSNumber *longitude;
    //CLPlacemark *currentLocation;
    NSDate *date;
    NSMutableArray *minutesStringArray;
    //int intensity;
    //int type;
}

@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *areaPickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *areaTextField;
@property (strong, nonatomic) IBOutlet UIPickerView *minutesPickerView;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextField *howLongTextField;
@property (weak, nonatomic) IBOutlet UISwitch *stopSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *stressSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *intensitySegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegmentedControl;

//@property (strong,nonatomic) NSArray *areaStringArray;
//@property (strong, nonatomic) NSMutableArray *minutesStringArray;
@property (strong,nonatomic) CLLocation *currentLocation;
@property (strong,nonatomic) CLLocationManager *locationManager;//para geolocalizarion

//DataBase proterty
@property (nonatomic,strong) DataBase *database;

- (IBAction)cancelBledAction:(id)sender;
- (IBAction)datePickerValueChanged:(id)sender;
- (IBAction)locateUserAction:(id)sender;
- (IBAction)saveBledAction:(id)sender;
- (IBAction)stopValueChanged:(id)sender;
- (IBAction)stressValueChanged:(id)sender;

@end

@implementation NewBledTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[Utils defaultBackgroundColor]];
    
    //Initialize default components color
    //...
    
    //Initializes DDBB
    self.database = [DataBase defaultDatabase];
    
    //-------------------Initialize LocationManager-----------------------
    self.locationManager = [[CLLocationManager alloc] init];
    
    //Comprobamos si el usr ya ha autorizado a la app a usar el GPS
    //Solo se le pregunta una vez, si ya se ha dado permiso no entra aqui
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        [self.locationManager requestWhenInUseAuthorization];//Muestra al usr una alerta para preguntarle y pedirle permiso para usar el GPS
    }
    self.locationManager.delegate =self;
    
    //Antes de reportar la localizacion, vamos a establecer los parametros para indicar cuando hay que hacerlo
    self.locationManager.distanceFilter = 10;//Se actualiza cada 10 metros
    
    //con esto indicamos que no nos mande la posicion hasta que no tenga una precision de X metros
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;//precision del GPS en metros, hay unas constantes establecdidas
    [self.locationManager startUpdatingLocation];//Metodo para que actualice la localizacion
    
    //-------------------End Initialize LocationManager-------------------
    
    
    //-------------------Init Components----------------------------------
    //Area
    self.areaTextField.inputView = self.areaPickerView;
    self.areaPickerView.delegate = self;
    self.areaPickerView.dataSource = self;
    self.areaTextField.text = [Utils getStringAreaDefaultIndex];
    
    //Date
    date = [NSDate date];
    self.dateTextField.inputView = self.datePicker;
    //asignamos al campo de texto la fecha formateada
    self.dateTextField.text = [Utils getDateFormatterStringWithDefaultFormatFrom:date];
    
    //Intensity
    //intensity=0;
    for(int i=0;i<[Utils getIntensityStringArray].count;i++){
        [self.intensitySegmentedControl setTitle:[Utils getIntensityStringForIndex:i] forSegmentAtIndex:i];
    }
    [self.intensitySegmentedControl setSelectedSegmentIndex:[Utils getIntensityDefaultSelectedIndex]];
    
    //HowLong
    minutesStringArray = [[NSMutableArray alloc] initWithCapacity:300];
    for(int i=0;i<[Utils getMaxValueForBleedingMinutes];i++){
        NSString *number= [NSString stringWithFormat:@"%d",i];
        minutesStringArray[i]=number;
    }
    self.howLongTextField.inputView = self.minutesPickerView;
    self.minutesPickerView.delegate= self;
    self.minutesPickerView.dataSource=self;
    self.howLongTextField.text = minutesStringArray.firstObject;
    
    //Type
    //type=0;
    for(int i=0;i<[Utils getTypeStringArray].count;i++){
        [self.typeSegmentedControl setTitle:[Utils getTypeStringForIndex:i] forSegmentAtIndex:i];
    }
    [self.typeSegmentedControl setSelectedSegmentIndex:[Utils getTypeDefaultSelectedIndex]];
    
    //Stop
    [self.stopSwitch setOn:false];
    
    //Stress
    [self.stressSwitch setOn:false];
    
    //CurrentLocation
    self.currentLocation = [[CLLocation alloc] init];
    //initialize latitude, longitude and currentLocation
    
    //init latitude & longitude
    self.longitudeLabel.text = [[NSNumber numberWithDouble: self.currentLocation.coordinate.longitude] stringValue];
    self.latitudeLabel.text = [[NSNumber numberWithDouble: self.currentLocation.coordinate.latitude] stringValue];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setBackgroundColor:[Utils defaultCellTableViewBackgroundColor]];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if(pickerView == self.areaPickerView){
        return 1;
    } else if (pickerView == self.minutesPickerView) {
        return 1;
    }
    return 0;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(pickerView == self.areaPickerView) {
        return [Utils getAreasStringArray].count;
    }else if(pickerView == self.minutesPickerView) {
        return  minutesStringArray.count;
    }
    return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if( pickerView == self.areaPickerView){
        //return ((Planet *)[planets objectAtIndex:row]).planetName;
        return [Utils getStringAreaFrom:(int) row];//self.areaStringArray[row];
    }else if( pickerView == self.minutesPickerView) {
        return minutesStringArray[row];
    }
    return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(pickerView == self.areaPickerView) {
        self.areaTextField.text = [Utils getStringAreaFrom:(int) row];//self.areaStringArray[row];
    }else if(pickerView == self.minutesPickerView){
        self.howLongTextField.text = minutesStringArray[row];
    }
    [[self view] endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelBledAction:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)datePickerValueChanged:(UIDatePicker*)sender {
    //asignamos al campo de texto la fecha formateada
    NSLog(@"datePicker %@", [Utils getDateFormatterStringWithDefaultFormatFrom:sender.date]);
    date = sender.date;
    self.dateTextField.text = [Utils getDateFormatterStringWithDefaultFormatFrom:sender.date];
    [[self view] endEditing:YES];
}

- (IBAction)locateUserAction:(id)sender {

    self.longitudeLabel.text = [[NSNumber numberWithDouble: self.currentLocation.coordinate.longitude] stringValue];
    self.latitudeLabel.text = [[NSNumber numberWithDouble: self.currentLocation.coordinate.latitude] stringValue];
}

- (IBAction)saveBledAction:(id)sender {
    NSString * area = self.areaTextField.text;
    //int intensity =intensity;
    int howLong = (int) [self.howLongTextField.text integerValue];
    //int type = type;
    BOOL stop = self.stopSwitch.on;
    BOOL stress = self.stressSwitch.on;
    double placeLatitude = self.currentLocation.coordinate.latitude;
    double placeLongitude = self.currentLocation.coordinate.longitude;
    
    NSLog(@"area: %@",area);
    NSLog(@"date: %@", [Utils getDateFormatterStringWithDefaultFormatFrom:date]);
    NSLog(@"intensity: %d", (int) self.intensitySegmentedControl.selectedSegmentIndex);
    NSLog(@"how long: %d", howLong);
    NSLog(@"type: %d",(int) self.typeSegmentedControl.selectedSegmentIndex);
    NSLog(@"stop: %d",stop);
    NSLog(@"stress: %d",stress);
    NSLog(@"latitude: %f",placeLatitude);
    NSLog(@"longitude: %f",placeLongitude);
    
    //Here I should check the fields, in case of error I should not allow to create the object
    self.bled = [NSEntityDescription insertNewObjectForEntityForName:@"Bleed" inManagedObjectContext:self.database.moc];
    
    self.bled.area = area;
    self.bled.date = date;
    self.bled.intensity= self.intensitySegmentedControl.selectedSegmentIndex;
    self.bled.length = howLong;
    self.bled.type = self.typeSegmentedControl.selectedSegmentIndex;
    self.bled.stop = stop;
    self.bled.stress = stress;
    self.bled.locationLatitude = placeLatitude;
    self.bled.locationLongitude =placeLongitude;
    
    
    NSLog(@"Call Database saveDatabase");
    [self.database saveDatabase];
    
    UIAlertController * alert=[UIAlertController
                               
                               alertControllerWithTitle:@"New Bleeding" message:@"New bleeding saved successfully"preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [self dismissViewControllerAnimated:true completion:nil];
                                    
                                }];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
    
    //usleep(1000000);
    //[self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)stopValueChanged:(id)sender {
}

- (IBAction)stressValueChanged:(id)sender {
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    self.currentLocation = locations.lastObject;//Ultima localizacion conocida
    //NSLog(@"Latitude: %lf, Longitude: %lf",self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude);
}
/*
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"newBleedingShowMap"]){
        
        UINavigationController *navController = segue.destinationViewController; //recuperamos el control de navegacion
        MapViewController *destination = (MapViewController *) navController.topViewController; //topviewController es la vista raiz del control de navegacion
        destination.selectedLocation = self.currentLocation;
        destination.delegate = self;
    }
}*/


-(void)doneEdition:(CLLocation *)selectedLocation{
    self.currentLocation = selectedLocation;
    [self dismissViewControllerAnimated:true completion:nil];
    
    if(self.currentLocation!=nil){
        self.longitudeLabel.text = [[NSNumber numberWithDouble: self.currentLocation.coordinate.longitude] stringValue];
        self.latitudeLabel.text = [[NSNumber numberWithDouble: self.currentLocation.coordinate.latitude] stringValue];
    }
}

@end
