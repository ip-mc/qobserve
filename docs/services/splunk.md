# Splunk

The Splunk service is an implementation with a [Splunk HEC server](https://docs.splunk.com/Documentation/Splunk/9.3.1/Data/HECExamples), which forwards logs to Splunk Enterprise.

### Secrets

The Splunk implementation requires the following secrets to be stored in `src/secrets.json`

- `splunkToken`
	- API token
- `splunkIndex`
	- The index to store the logs in
- `splunkURL`
	- The complete URL endpoint for the HEC server

The secrets should be [encrypted](../secrets.md). See the example `secrets.json` below.

```json
{
    "splunkToken": "vV8E5B/zIcBSULCoteFgj4nPFz1ysdfgdsfgdjbUyRrj8G1U9nTuUDbeSkFAK2Nkd",
    "splunkIndex": "4+m5dfsgyYF9dsfgdfgk9v8g==",
    "splunkURL": "5Hkd8Gifd/gjdlkTkdh69dsHksngkoGk=="
}
```