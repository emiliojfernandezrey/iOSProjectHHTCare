//
//  DataBase.m
//  EjfrFinalProyectiOS
//
//  Created by cice on 20/7/17.
//
//

#import "DataBase.h"

@interface DataBase()

@property (nonatomic,strong) NSPersistentContainer *pc;
@property (nonatomic,strong) NSMutableArray *BledArray;

@end

@implementation DataBase

//CREACCION DEL SINGLETON DE LA BASE DE DATOS
+(DataBase *) defaultDatabase {
    static dispatch_once_t pred;
    static DataBase *shared = nil;
    dispatch_once(&pred, ^{ //dispatch_one hace que este codigo solo se ejecute la primera vez que se llame al metodo
        //le decimos que inicialice la DB
        shared = [[DataBase alloc] init];
        //le decimos que cargue la base de datos
        [shared loadDatabase];
    });
    return shared;
}

-(void)loadDatabase{
    
    //Creamos el persistenContainer
    self.pc = [[NSPersistentContainer alloc] initWithName:@"DataModel"] ;
    
    //inicializamos el PC
    [self.pc loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * _Nonnull desc, NSError * _Nullable error) {
        //
        if(error){
            abort();//Esto cierra la aplicacion directamente
        }else{
            //Con esto inicializamos la DB
            _moc = self.pc.viewContext;
        }
    }];
}

-(void)saveDatabase{
    NSError *error;
    [_moc save:&error];
    //id error I show the message
    if(error!=nil && error.description.length >0){
        NSLog(@"Error saving on database: %@",error.description);
    }
}


@end
