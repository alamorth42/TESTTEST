//
//  TypeAlias.swift
//  iTravel
//
//  Created by Kyphun Lepeule on 04/02/2022.
//
import UIKit

typealias UserCompletion = (_ user: User?) -> (Void)
typealias SuccessCompletion = (_ success: Bool?, _ erreur: String?) -> (Void)
typealias TripCompletion = (_ trip: Trip?) -> (Void)
typealias RemarkCompletion = (_ remark: Remark?) -> (Void)
