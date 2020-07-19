//
//  String+Extensions.swift
//  TextFieldValidationCombineApproach
//
//  Created by Wilson on 7/18/20.
//  Copyright © 2020 NinjaLabs. All rights reserved.
//

import Foundation

extension String  {
    private static let __firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
    private static let __serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
    private static let __emailRegex = __firstpart + "@" + __serverpart + "[A-Za-z]{2,6}"
    
    var isFormatValidEmail: Bool {
        // here, `try!` will always succeed because the pattern is valid
        let predicate = NSPredicate(format: "SELF MATCHES %@", type(of:self).__emailRegex)
        return predicate.evaluate(with: self)
    }
    
    var isStrongPassword: Bool {

        let passwordRegex = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}"

        let passwordTest = NSPredicate(format:"SELF MATCHES %@",
                                     passwordRegex)
        return passwordTest.evaluate(with: self)
    }
}
