//
//  File.swift
//  TopicsList
//
//  Created by Iggy on 4/30/17.
//  Copyright © 2017 Iggy Mwangi. All rights reserved.
//

import Foundation
import CoreData
/*
 
 Core data implementation in Swift 3.0 for iOS 8.0 and later versions.
 
 see https://iphoneappcode.blogspot.com/2017/01/core-data-implementation-in-swift-30.html
 */
class DBManager: NSObject
{
    //-- singleton declaration
    static let sharedDBManager = DBManager()
    
    override init() {
    }
    
    //MARK: - ================================
    //MARK: Core Data Delegate Methods
    //MARK: ================================
    
    //-- Application Document directory ...
    public lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1]
    }()
    
    //-- ManagedObjectModel ...
    private lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "mydatabase", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    //-- Persistent Store Coordinator ...
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("TopicsList.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            // Configure automatic migration.
            let options = [ NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true ]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    //-- ManagedObjectContext Creation
    lazy var managedObjectContext: NSManagedObjectContext = {
        var managedObjectContext: NSManagedObjectContext?
        if #available(iOS 10.0, *){
            managedObjectContext = self.persistentContainer.viewContext
        }
        else{
            // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
            let coordinator = self.persistentStoreCoordinator
            managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            managedObjectContext?.persistentStoreCoordinator = coordinator
        }
        return managedObjectContext!
    }()
    
    //-- iOS - 10 : NSPersistentContainer
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "mydatabase")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        print("\(self.applicationDocumentsDirectory)")
        return container
    }()
    
    //-- Core Data Saving support
    func saveContext () {
        if self.managedObjectContext.hasChanges {
            do {
                try self.managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    //MARK: - ================================
    //MARK: Below is the example to get user based on cust_id
    //MARK: ================================
    
    
//    func getUserWith(_ cust_id : String, completionHandler : @escaping(_ result : User?, _ error : NSError?) -> Swift.Void)
//    {
//        let context = self.managedObjectContext
//        let request: NSFetchRequest<User>
//        if #available(iOS 10.0, *) {
//            request = User.fetchRequest()
//        } else {
//            request = NSFetchRequest(entityName: "User")
//        }
//        request.predicate = NSPredicate(format: "cust_id = %@", cust_id)
//        do {
//            let arrUser = try context.fetch(request)
//            if arrUser.count > 0 {
//                completionHandler(arrUser[0], nil)
//            }
//            else {
//                completionHandler(nil, nil)
//            }
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//            completionHandler(nil, error)
//        }
//    }
    
    //MARK: - ================================
    //MARK: Below is the function to delete the records from the core-data table which are not available in Array fetched from backend server.
    //MARK: ================================
    
//    func deleteVehicleInfoUsing(_ arrVehicle : Array<Any>)
//    {
//        print("Vehicle : \(arrVehicle)")
//        let context = self.managedObjectContext
//        let request: NSFetchRequest<Vehicle>
//        if #available(iOS 10.0, *) {
//            request = Vehicle.fetchRequest()
//        } else {
//            request = NSFetchRequest(entityName: "Vehicle")
//        }
//        request.predicate = NSPredicate(format: "NOT(vehicle_id IN %@)", arrVehicle)
//        do {
//            let arrVeh = try context.fetch(request)
//            for obj_veh in arrVeh {
//                context.delete(obj_veh)
//            }
//            do {
//                try context.save()
//            } catch let error as NSError {
//                print("Could not delete vehicle. \(error), \(error.userInfo)")
//            }
//        } catch let error as NSError {
//            print("Could not delete vehicle. \(error), \(error.userInfo)")
//        }
//    }
    
    //MARK: - ================================
    //MARK: To “Add” reservation record into the core data table. Likewise you can add your own record to the table.
    //MARK: ================================
    
//    func saveReservation(_ obj_addreservation : AddReservation, completionHandler : @escaping(_ result : Bool,_ obj_reservation : Reservation?, _ error : NSError?) -> Swift.Void)
//    {
//        let context = self.managedObjectContext
//        let entity = NSEntityDescription.entity(forEntityName: "Reservation", in: context)
//        let obj_reservation = (NSManagedObject(entity: entity!,  insertInto: context) as! Reservation)
//        
//        obj_reservation.phoneID = obj_addreservation.phoneID
//        obj_reservation.locationID = (obj_addreservation.locationID != nil) ? Int64(obj_addreservation.locationID!):0
//        obj_reservation.licensePlate = obj_addreservation.licensePlate
//        obj_reservation.provinceID = (obj_addreservation.provinceID != nil) ? Int64(obj_addreservation.provinceID!):0
//        obj_reservation.vehicleMakeID = (obj_addreservation.vehicleMakeID != nil) ? Int64(obj_addreservation.vehicleMakeID!):0
//        obj_reservation.vehicleTypeID = (obj_addreservation.vehicleTypeID != nil) ? Int64(obj_addreservation.vehicleTypeID!):0
//        obj_reservation.vehicleColourID = (obj_addreservation.vehicleColourID != nil) ? Int64(obj_addreservation.vehicleColourID!):0
//        obj_reservation.openDate = obj_addreservation.openDate
//        obj_reservation.closeDate = obj_addreservation.closeDate
//        obj_reservation.airlineCode = obj_addreservation.airlineCode
//        obj_reservation.flightNum = (obj_addreservation.flightNum != nil) ? Int64(obj_addreservation.flightNum!):0
//        obj_reservation.associationNumber = obj_addreservation.associationNumber
//        obj_reservation.rewardRedemptionCoupon = obj_addreservation.rewardRedemptionCoupon
//        obj_reservation.aeroplanNumber = obj_addreservation.aeroplanNumber
//        obj_reservation.ticket_id = obj_addreservation.ticket_id
//        
//        do {
//            try context.save()
//            completionHandler(true,obj_reservation,nil)
//        } catch let error as NSError {
//            print("Could not save reservation. \(error), \(error.userInfo)")
//            completionHandler(true, nil, error)
//        }
//    }
    
    //MARK: - ================================
    //MARK: To fetch all the records from the table in core data instead of specific one
    //MARK: ================================
    
//    func fetchAllReservations(completionHandler : @escaping(_ result : [Reservation]?, _ error : String?) -> Swift.Void)
//    {
//        let context = self.managedObjectContext
//        let request: NSFetchRequest<Reservation>
//        if #available(iOS 10.0, *) {
//            request = Reservation.fetchRequest()
//        } else {
//            request = NSFetchRequest(entityName: "Reservation")
//        }
//        do {
//            let arrReservation = try context.fetch(request)
//            if arrReservation.count > 0 {
//                completionHandler(arrReservation, nil)
//            }
//            else {
//                completionHandler([], "No reservation found.")
//            }
//        } catch let error as NSError {
//            print("Could not fetch reservation. \(error), \(error.userInfo)")
//            completionHandler([], error.localizedDescription)
//        }
//    }
    
    //MARK: - ================================
    //MARK: To fetch the count of records from the table in core data
    //MARK: ================================
    
//    func getTotalReservation() -> Int
//    {
//        let context = self.managedObjectContext
//        let request: NSFetchRequest<Reservation>
//        if #available(iOS 10.0, *) {
//            request = Reservation.fetchRequest()
//        } else {
//            request = NSFetchRequest(entityName: "Reservation")
//        }
//        request.includesPropertyValues = false
//        
//        do {
//            let count = try context.count(for: request)
//            return count
//        } catch let error as NSError {
//            print("Error: \(error.localizedDescription)")
//            return 0
//        }
//    }
}
