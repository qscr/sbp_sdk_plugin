//
//  SBPWidgetBankWrapper.swift
//  sbp_sdk_plugin
//
//  Created by Maxim Petrov on 24.04.2024.
//

import Foundation

final public class SBPWidgetBankWrapper: Codable {
    init(name: String, logoURL: URL?, dboLink: URL) {
        self.name = name
        self.logoURL = logoURL
        self.dboLink = dboLink
    }
    
    /// Bank name
    final public let name: String

    /// Bank logo image url
    final public let logoURL: URL?

    /// Bank deeplink
    final public let dboLink: URL
}
