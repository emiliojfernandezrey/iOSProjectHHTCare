//
//  ViewController.m
//  EjfrFinalProyectiOS
//
//  Created by Eve Moon on 18/7/17.
//
//

#import <CoreLocation/CoreLocation.h>
#import "MapViewController.h"
#import "MapLocationAnnotation.h"

@interface MapViewController ()
@property (weak,nonatomic) UIAlertAction *addInterestPointAction;
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)doneButtonPressedAction:(id)sender;
- (IBAction)currentLocationButtonPressedAction:(id)sender;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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
    
    //Si el usuario no da permiso la app no peta, lo unico que pasa es q las funciones de GPS no funcionarian
    self.mapView.showsUserLocation = true;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    //CurrentLocation
    //self.selectedLocation = [[CLLocation alloc] init];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //Aqui cargamos los datos en la base de datos en el mapa
    //[self.mapView addAnnotations:self.database.interestPoints];
    
    //CLLocationCoordinate2D  ctrpoint = self.selectedLocation.coordinate;
    MapLocationAnnotation *addAnnotation = [[MapLocationAnnotation alloc] initWithLocation:self.selectedLocation];
    [self.mapView addAnnotation:addAnnotation];
    //[addAnnotation release];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)doneButtonPressedAction:(id)sender {
    [self.delegate doneEdition:self.selectedLocation];
}

- (IBAction)currentLocationButtonPressedAction:(id)sender {
    self.selectedLocation = [[CLLocation alloc] init];
}

@end
