`status` values

Key | Value
-- | --
`delivered` | this message has been delivered to the phone number.
`expired` | the target carrier did not send a status in the 72 hours after this message was delivered to them.
`failed` | the target carrier failed to deliver this message.
`rejected` | the target carrier rejected this message.
`accepted` | the target carrier has accepted to send this message.
`buffered` | This message is in the process of being delivered.
`unknown` | the target carrier has returned an undocumented status code.
