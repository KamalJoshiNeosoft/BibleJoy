//
//  CheckNetworkUsability.swift
//  MPCB
//
//  Created by Arjun  on 26/09/19.
//  Copyright © 2019 Pervacio. All rights reserved.
//

import Foundation

class CheckNetworkUtility {
    
    static let connectNetwork = CheckNetworkUtility()
    
    func checkNetwork() -> Bool {
        let reachability : Reachability = Reachability.forInternetConnection()
        return reachability.currentReachabilityStatus() == NotReachable ? false : true
    }
}
