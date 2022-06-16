//
//  invoice.swift
//  miituoLib
//
//  Created by JOHN CRISTOBAL on 15/06/22.
//

import Foundation

struct invoice: Codable {
    let policyID: Int?
    let policyNumber: String?
    let monthName: String?
    let paymenttype: String
    let amount: Double
    let estadoCuentaID, month, monthBill: Int?

    enum CodingKeys: String, CodingKey {
        case policyID = "PolicyId"
        case policyNumber = "PolicyNumber"
        case monthName = "MonthName"
        case estadoCuentaID = "EstadoCuentaId"
        case month = "Month"
        case monthBill = "MonthBill"
        case paymenttype = "PaymentType"
        case amount = "Amount"
    }
}

typealias Invoice = [invoice]
