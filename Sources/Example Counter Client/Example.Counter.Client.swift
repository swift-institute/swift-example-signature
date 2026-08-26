import Algebra_Derivation
import Client
public import Example
public import Example_Counter

extension Example.Counter {
    @Algebra
    package protocol Signature {
        func increment(
            limit: Example.Counter.Limit
        ) async throws(Example.Counter.Error) -> Example.Counter.Value
    }
}
