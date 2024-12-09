# Qobserve

*Tested on QDS 9.12.0*

Qobserve is an observability instrumentation for Q-SYS systems designed for integration with 3rd party observability platforms. It intends to solve the shortcomings of Q-SYS Reflect and Q-SYS Designer such as vendor lock in, lack of customization, and the cumbersome nature of updating parts of designs at scale. Qobserve is built with flexibility, scalability and compatibility in mind.

---
## Limitations
At the moment qobserve only works with a Splunk HEC server, but adding another observability platform is only a matter of updating the `config.json` file and adding a module to format and send the data to that platform.

---
## Features
- Third party compatibility
	- If your organization doesn't use Splunk, you can add a module for whatever platform you prefer
- Monitor and log any control on any component in the design
	- Define what you want to monitor in the config file
- Batch updating
	- Update the qobserve config of all your systems with the provided [script](scripts/push-module.py)
- Live updates
	- No need to re-push the design and disrupt a system. Once you add the provided user component it will automatically update when a revision is uploaded to the core

---
## Getting Started
To get started read the [docs](docs/table-of-contents.md)

---
## Roadmap
- [ ] Other observability platform implementations
	- [ ] Grafana
	- [ ] Graylog
	- [ ] InfluxDB
- [ ] Metric Data
	- Many observability platforms require a different format for metric data as opposed to log data
- [ ] Poll Data
	- Send snapshots of design states (or whatever data you want) at a defined interval
- [ ] System Logs
	- Pull and log the OS logs to analyze against application data

---
## Contributing
Use pull requests or issues on [github](https://github.com/ip-mc/qobserve) to add an implementation for your preferred observability platform, report a bug, ask a question, or add some features. Please read the [docs](docs/table-of-contents.md) first.