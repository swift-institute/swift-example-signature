import Algebra_Derivation
import Call_Derivation
import Client
public import Example
public import Example_Counter

extension Example.Counter {
    @Client
    @Calls
    package protocol Signature {
        func increment(limit: Limit) async throws(Error) -> Value
    }
}
