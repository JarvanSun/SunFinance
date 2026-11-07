//
//  OrderListLoads.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

struct OrderListLoads: Equatable {
    private var settledPhase = OrderList.Phase.idle
    private var running = 0
    private var started = 0
    private var applied = 0

    var phase: OrderList.Phase {
        switch running {
        case 0: settledPhase
        default: .loading
        }
    }

    mutating func start() -> Int {
        running += 1
        started += 1
        return started
    }

    mutating func abandon() {
        running -= 1
    }

    mutating func finish(_ load: Int, settling phase: OrderList.Phase) -> Bool {
        running -= 1
        guard load > applied else { return false }

        applied = load
        settledPhase = phase
        return true
    }
}
