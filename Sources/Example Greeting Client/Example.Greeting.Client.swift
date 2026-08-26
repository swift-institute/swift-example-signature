import Algebra_Derivation
public import Call_Derivation
import Client
public import Example
public import Example_Greeting

extension Example.Greeting {
    @Algebra
    @Calls
    package protocol Signature {
        func greet(_ name: Example.Greeting.Name) async -> Example.Greeting.Message
    }
}
