# WaterMonitor

**This is work in progress**

This project is used to directly displays data from an e.g. Syr LEX Plus 10 Connect on a dashboard.

Currently the following parts are part of this project:
* simple DNS server that replies to every request with its own IP address
* a simple HTTP server that handles the POST requests from the Syr device
* a dashboard to show some data

This project is intended to run on a raspberry pi with the Ethernet interface connected to the Syr device and the WLAN interface connected to the home network.

In addition to this Elixir project, a dhcp server must run on the raspberry, that is assigning the DHCP address to the Syr device and sets itself as the name server, e.g.
~~~
option domain-name-servers <raspberry IP>;
~~~

## Dashboard

![Dashboard](https://cloud.githubusercontent.com/assets/974411/20904804/6847f4e4-bb41-11e6-9257-2e0e88c28459.png)

