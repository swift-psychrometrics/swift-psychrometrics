public struct ResultEnvelope<V: Encodable>: Encodable {
  public var result: V
}
