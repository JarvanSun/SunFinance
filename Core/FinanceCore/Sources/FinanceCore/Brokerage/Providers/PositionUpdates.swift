//
//  PositionUpdates.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

extension PositionProviding {
    public func portfolioUpdates(every interval: Duration = .seconds(15))
        -> AsyncStream<Result<Portfolio, BrokerageError>>
    {
        AsyncStream { continuation in
            let polling = Task {
                while await waitForNextPoll(after: interval) {
                    continuation.yield(await fetchPortfolio())
                }
                continuation.finish()
            }
            continuation.onTermination = { _ in polling.cancel() }
        }
    }
}

private extension PositionProviding {
    func waitForNextPoll(after interval: Duration) async -> Bool {
        do {
            try await Task.sleep(for: interval)
            return !Task.isCancelled
        } catch {
            return false
        }
    }

    func fetchPortfolio() async -> Result<Portfolio, BrokerageError> {
        do {
            return .success(try await portfolio())
        } catch {
            return .failure(error)
        }
    }
}
