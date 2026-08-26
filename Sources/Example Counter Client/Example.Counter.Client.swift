import Algebra_Derivation
public import Call_Derivation
import Client
public import Example
public import Example_Counter

extension Example.Counter {
    @Algebra
    @Calls
    package protocol Signature {
        func increment(
            limit: Example.Counter.Limit
        ) async throws(Example.Counter.Error) -> Example.Counter.Value
    }
}
