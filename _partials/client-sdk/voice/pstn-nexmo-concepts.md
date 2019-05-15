Before proceeding any further, here are couple of concepts that you'll need to understand.

A [Nexmo application](/concepts/guides/applications) allows you to easily use Nexmo products, in this case the [Voice API](/voice/voice-api/overview) to build voice applications in the Cloud.

A Nexmo application requires two URLs as parameters:

* `answer_url` - Nexmo will make a request to this URL as soon as someone makes a call to your Nexmo number. It contains the actions that will happen throughout the call.
* `event_url` - Nexmo sends event information asynchronously to this URL when the call status changes; this ultimately depicts the flow of the call.

Both URLs need to return JSON and follow the [Nexmo Call Control Object (NCCO)](/voice/voice-api/ncco-reference) reference. In the example below, you will define an NCCO that reads a predefined text for an incoming call, using the [Text to Speech](/voice/voice-api/guides/text-to-speech) engine.

A [Nexmo virtual number](/numbers/overview) will be associated with the app and serve as the "entry point" to it - this is the number you'll call to test the application.

For more information on Nexmo applications please visit the Nexmo [API Reference](/api/application).)
