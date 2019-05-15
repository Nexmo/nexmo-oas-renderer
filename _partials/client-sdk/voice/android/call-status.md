To be aware of the call status, for example, if one of the members answers or hangs up, you should register to `CallEvents`. The `FinishOnCallEnd` is a `NexmoCallEventListener` that finishes the current activity if the call is completed or canceled.

Register to its instance, to address the use cases mentioned previously.

On both `OnCallActivity` and `IncomingCallActivity`, add:
