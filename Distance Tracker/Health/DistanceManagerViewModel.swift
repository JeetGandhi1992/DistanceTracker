//
//  DistanceManagerViewModel.swift
//  Distance Tracker
//
//  Created by Jeet Gandhi on 5/4/21.
//

import Foundation
import HealthKit

class DistanceManagerViewModel: ObservableObject {
    
    var healthStore = HKHealthStore()
    
    @Published var stepCount = 0.0
    @Published var errorMessage = ""
    var startDate: Date = Date()
    
    func getHealthAuthorization() {
        let healthKitTypes: Set = [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
                                   HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!]
        
        healthStore.requestAuthorization(toShare: healthKitTypes,
                                         read: healthKitTypes) { (isAuthorised, error) in
            
            if (isAuthorised && error == nil) {
                self.startDate = Date()
            }
        }
    }
    
    func endJourney() {
        self.getDistanceWalked { (result) in
            self.stepCount = result
        }
    }
    
    func getDistanceWalked(_ completion: @escaping ((_ result: Double) -> Void)) {
        
        let type = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let endDate = Date()
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: type,
                                      quantitySamplePredicate: predicate,
                                      options: [.cumulativeSum]) { [weak self] (query, statistics, error) in
            var resultCount = 0.0
            if error != nil {
                print("something went wrong")
                self?.errorMessage = error?.localizedDescription ?? ""
            } else if let quantity = statistics?.sumQuantity() {
                self?.errorMessage = ""
                resultCount = quantity.doubleValue(for: HKUnit.count())
            }
            DispatchQueue.main.async {
                completion(resultCount)
            }
        }
        healthStore.execute(query)
    }
    
}
