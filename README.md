# Open Thread Border Router Full Network

[![pipeline status](https://github.com/Smeagolworms4/core_openthread_border_router/actions/workflows/build_images.yml/badge.svg)](https://github.com/Smeagolworms4/core_openthread_border_router/actions/workflows/build_images.yml)

[!["Buy Me A Coffee"](https://raw.githubusercontent.com/Smeagolworms4/donate-assets/master/coffee.png)](https://www.buymeacoffee.com/smeagolworms4)
[!["Buy Me A Coffee"](https://raw.githubusercontent.com/Smeagolworms4/donate-assets/master/paypal.png)](https://www.paypal.com/donate/?business=SURRPGEXF4YVU&no_recurring=0&item_name=Hello%2C+I%27m+SmeagolWorms4.+For+my+open+source+projects.%0AThanks+you+very+mutch+%21%21%21&currency_code=EUR)

Open Thread Border Router without usb device dependancy 

## Usage

Pull repository

```bash
docker pull smeagolworms4/core_openthread_border_router
```
Run container:

```bash
docker run -ti smeagolworms4/core_openthread_border_router
```

## Docker hub

https://hub.docker.com/r/smeagolworms4/core_openthread_border_router_amd64
https://hub.docker.com/r/smeagolworms4/core_openthread_border_router_aarch64

## Github

https://github.com/Smeagolworms4/core_openthread_border_router


## Home Assistant Addon

https://github.com/GollumDom/addon-repository

## Troubleshooting

Both failure modes below end the same way in the log — `Init() at
spinel_driver.cpp:87: Failure`, then the container stops — but they are not the
same problem.

**`tiocmbic: Inappropriate ioctl for device`** — fixed in 3.1.0.2. Upstream adds
`uart-init-deassert` to the radio URL when `flow_control` is off, and the
resulting `ioctl(TIOCMBIC)` is not implemented by a socat PTY, so port setup
gives up before `tcsetattr`. This image now drops the UART flow-control
parameters whenever a `network_device` is configured.

**No `tiocmbic`, still line 87** — line 87 is `CheckSpinelVersion()`: the RCP
never answered. socat is connected (otherwise the error would be
`hdlc_interface.cpp:154: No such file or directory`), so the radio itself is
frozen. Over TCP there are no DTR/RTS lines to toggle its reset pin, so the
adapter must do it: on an SLZB-06, *Settings and Tools -> General settings ->
Zigbee restart*, then start the add-on again.

See `DOCS.md` in the add-on repository for a standalone script that queries the
RCP version directly over TCP to tell the two apart.
