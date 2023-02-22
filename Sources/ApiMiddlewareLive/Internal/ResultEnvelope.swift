struct ResultEnvelope<V: Encodable>: Encodable {
  var result: V
}
