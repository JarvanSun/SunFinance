//
//  OrderStatusNote.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

enum OrderStatusNote: Equatable {
    case none
    case waiting(LocalizedStringResource)
    case rejected(LocalizedStringResource)
}
