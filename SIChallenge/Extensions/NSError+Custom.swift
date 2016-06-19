//
//  NSError+Custom.swift
//  SIChallenge
//
//  Created by Juan Cruz Ghigliani on 16/6/16.
//  Copyright © 2016 Juan Cruz Ghigliani. All rights reserved.
//

import Foundation

/** Custom Extends NSError

*/
extension NSError {
    
    /**
     Convenience constructor to simplify the inclusion of error messages in user info
     
     - parameter domain:                  Error domain
     - parameter code:                    Error code number
     - parameter Description:             Error detail info
     - parameter FailureReasonError:      Cause of the failure
     - parameter RecoverySuggestionError: Posible recovery actions
     
     - returns: Instance of NSError object
     */
    public convenience init(domain:String,
                            code:Int,
                            Description:String,
                            FailureReasonError:String = "",
                            RecoverySuggestionError:String = ""
        ) {
        self.init(domain: domain, code: code, userInfo: [
            NSLocalizedDescriptionKey: Description,
            NSLocalizedFailureReasonErrorKey: FailureReasonError,
            NSLocalizedRecoverySuggestionErrorKey: RecoverySuggestionError
            ]
        )
    }
}