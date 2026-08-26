public import Eliminator_Derivation
public import Example
public import Example_Counter
public import Example_Counter_Client
public import Example_Greeting
public import Example_Greeting_Client
public import Prism_Derivation

extension Example {

    /// The transport-independent pivot: the coproduct of the leaf calls.
    ///
    /// Interim shape. The terminal form derives this from a root `Signature`
    /// whose members are property requirements; until `@Calls` supports those,
    /// the root wears the atomic derivations directly.
    @Prisms
    @Eliminator
    public enum Call {

        case greeting(Example.Greeting.Call)

        case counter(Example.Counter.Call)
    }
}
