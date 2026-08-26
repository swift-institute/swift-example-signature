import Algebra_Derivation
import Call_Derivation
import Client
public import Example
public import Example_Counter
public import Example_Counter_Client
public import Example_Greeting
public import Example_Greeting_Client

extension Example {
    @Client
    @Calls
    package protocol Signature {
        var greeting: Greeting.Client { get }
        var counter: Counter.Client { get }
    }
}
