//
//  File.swift
//  
//
//  Created by Hamed Khosravi on 1/17/20.
//

import Foundation
import SwiftUI
public struct SwiftUIPhonePickerCountryModel{
    var code: String!
    var name: String!
    var phoneCode: String!
    var flag:UIImage!
    var emoji:String = ""
    init(code: String!, name: String!, phoneCode: String!,flag:UIImage) {
        self.code = code
        self.name = name
        self.phoneCode = phoneCode
        self.flag = flag
    }
}
