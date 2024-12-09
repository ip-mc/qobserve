# Configuration

```json
{
    "service": "splunk",
    "events": {
        "components": [
            {
                "componentNames": ["all"],
                "controlNames": ["status"]
            },
            {
	            "componentNames": ["Src-1", "Src-2"],
                "controlNames": ["5v", "input.format"]
            }
        ]
    }
}
```

## Location
The config file needs to be placed in `src/config.json`
## Schema
The config is broken into 2 root properties.
- service
	- The observability service used
- events
	- Events to monitor. When a change occurs the details are sent to the logging server
## Subfields
The event property contains nested properties which specify the type of object to get data from and what data to get.
### Components
The components property contains an array of objects. Each object has the property `"componentNames"` and `"controlNames"`. There can be multiple component objects.

- componentNames
	- An array of the components "code names" to monitor
- controlNames
	- An array of the controls to monitor for those components specified in the object
	- To find the control names:
		- In Q-SYS Designer go to `Tools -> View Component Control Info...` and click on the component you want to view