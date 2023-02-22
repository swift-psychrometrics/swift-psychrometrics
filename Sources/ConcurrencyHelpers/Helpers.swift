import Foundation

#if canImport(_Concurrency)
  extension Task where Failure == Never {
    /// An async function that never returns.
    static func never() async throws -> Success {
      for await element in AsyncStream<Success>.never {
        return element
      }
      throw _Concurrency.CancellationError()
    }
  }
  extension AsyncStream {
    static var never: Self {
      Self { _ in }
    }
  }
#endif
