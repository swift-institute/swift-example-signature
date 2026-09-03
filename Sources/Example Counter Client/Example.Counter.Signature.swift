public import Client_Derivation
public import Example
public import Example_Counter
public import Signature_Derivation

extension Example.Counter {
    @Signature
    @Client
    package protocol `Protocol` {
        func increment(limit: Limit) async throws(Error) -> Value
    }
}
