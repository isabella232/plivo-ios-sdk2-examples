//
//  Token.swift
//  SwiftVoiceCallingApp
//
//  Created by Venkata Sri Ram Karthik on 23/04/20.
//  Copyright © 2020 Plivo. All rights reserved.
//

import Foundation
import PlivoVoiceKit
class Token:PlivoOutgoing {
    
    static let sharedTokenInstance = Token()
    override func getToken()
    {
        print("Karthik Token Method Called from app");
    }
}
