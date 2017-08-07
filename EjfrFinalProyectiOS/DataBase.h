//
//  DataBase.h
//  EjfrFinalProyectiOS
//
//  Created by cice on 20/7/17.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataBase : NSObject

@property (nonatomic, readonly, strong) NSManagedObjectContext *moc;

-(void)loadDatabase;//inicializar la DB
-(void)saveDatabase;//Guardar los datos en disco

+(DataBase*) defaultDatabase;//metodo estatico que devuelve una instancia de la clase

@end
