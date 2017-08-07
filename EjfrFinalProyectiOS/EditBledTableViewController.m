//
//  EditBledTableViewController.m
//  EjfrFinalProyectiOS
//
//  Created by Eve Moon on 22/7/17.
//
//

#import "EditBledTableViewController.h"
#import "DataBase.h"
#import "Utils.h"

@interface EditBledTableViewController ()
{
    NSDate *date;
    NSMutableArray *minutesStringArray;
}
@property (strong,nonatomic) CLLocationManager *locationManager;//para geolocalizarion
@property (strong,nonatomic) CLLocation *currentLocation;
//DataBase proterty
@property (nonatomic,strong) DataBase *database;

@property (weak, nonatomic) IBOutlet UITextField *areaTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *intensitySegmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *howLongTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegmentedControl;
@property (weak, nonatomic) IBOutlet UISwitch *stopSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *stressSwitch;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *areaPickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *minutesPickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePickerView;

- (IBAction)datePickerValueChanged:(id)sender;
- (IBAction)cancelButtonAction:(id)sender;
- (IBAction)saveButtonAction:(id)sender;
- (IBAction)locateUserAction:(id)sender;
@end

@implementation EditBledTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[Utils defaultBackgroundColor]];
    
    NSLog(@"EditBledTVC viewDidLoad %@",self.bleed.area);
    
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

    
    //area
    self.areaTextField.inputView = self.areaPickerView;
    self.areaPickerView.delegate = self;
    self.areaPickerView.dataSource = self;
    self.areaTextField.text = self.bleed.area;
    
    //date
    self.dateTextField.inputView = self.datePickerView;
    date = [NSDate date];
    self.dateTextField.text = [Utils getDateFormatterStringWithDefaultFormatFrom:self.bleed.date];
    
    //intensity
    for(int i=0;i<[Utils getIntensityStringArray].count;i++){
        [self.intensitySegmentedControl setTitle:[Utils getIntensityStringForIndex:i] forSegmentAtIndex:i];
    }
    [self.intensitySegmentedControl setSelectedSegmentIndex: self.bleed.intensity];
    
    //length
    minutesStringArray = [[NSMutableArray alloc] initWithCapacity:300];
    for(int i=0;i<[Utils getMaxValueForBleedingMinutes];i++){
        NSString *number= [NSString stringWithFormat:@"%d",i];
        minutesStringArray[i]=number;
    }
    self.howLongTextField.inputView = self.minutesPickerView;
    self.minutesPickerView.delegate= self;
    self.minutesPickerView.dataSource=self;
    self.howLongTextField.text = [NSString stringWithFormat:@"%lli",self.bleed.length];
    
    //Type
    for(int i=0;i<[Utils getTypeStringArray].count;i++){
        [self.typeSegmentedControl setTitle:[Utils getTypeStringForIndex:i] forSegmentAtIndex:i];
    }
    [self.typeSegmentedControl setSelectedSegmentIndex: self.bleed.type];
    
    //Stop
    [self.stopSwitch setOn:self.bleed.stop];
    
    //Stress
    [self.stressSwitch setOn:self.bleed.stress];
    
    //location
    self.currentLocation = [[CLLocation alloc] init];
    self.longitudeLabel.text = [NSString stringWithFormat: @"%f",self.bleed.locationLongitude];
    self.latitudeLabel.text = [NSString stringWithFormat:@"%f",self.bleed.locationLatitude];
    
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

- (IBAction)datePickerValueChanged:(UIDatePicker*)sender {
    date = sender.date;
    self.dateTextField.text = [Utils getDateFormatterStringWithDefaultFormatFrom:date];
    [[self view] endEditing:YES];
}

- (IBAction)cancelButtonAction:(id)sender {
    //[self dismissViewControllerAnimated:true completion:nil];
    [self.delegate cancelEdition];
}

- (IBAction)saveButtonAction:(id)sender {
    
    //Here I have to check all fields
    
    self.bleed.area = self.areaTextField.text;
    self.bleed.date = date; //No tengo claro que esto se actualice e inicialice correctamente
    self.bleed.intensity = [self.intensitySegmentedControl selectedSegmentIndex];
    self.bleed.length = [self.howLongTextField.text intValue];
    self.bleed.type = [self.typeSegmentedControl selectedSegmentIndex];
    self.bleed.stop = [self.stopSwitch isOn];
    self.bleed.stress = [self.stressSwitch isOn];
    self.bleed.locationLatitude = [self.latitudeLabel.text doubleValue];
    self.bleed.locationLongitude = [self.longitudeLabel.text doubleValue];
    
    //[self.database saveDatabase];
    //[self dismissViewControllerAnimated:true completion:nil];
    
    [self.delegate doneEdition:self.bleed];
}

- (IBAction)locateUserAction:(id)sender {
    self.longitudeLabel.text = [[NSNumber numberWithDouble: self.currentLocation.coordinate.longitude] stringValue];
    self.latitudeLabel.text = [[NSNumber numberWithDouble: self.currentLocation.coordinate.latitude] stringValue];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    self.currentLocation = locations.lastObject;//Ultima localizacion conocida
    //NSLog(@"Latitude: %lf, Longitude: %lf",self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude);
}

@end
