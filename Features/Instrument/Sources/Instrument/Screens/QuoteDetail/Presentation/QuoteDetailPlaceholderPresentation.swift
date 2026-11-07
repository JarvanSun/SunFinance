//
//  QuoteDetailPlaceholderPresentation.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

extension QuoteDetailPlaceholder {
    var title: LocalizedStringResource {
        switch self {
        case .loading: .init("quoteDetail.placeholder.loading", bundle: .module)
        case .failed(let issue): issue.title
        }
    }
}
