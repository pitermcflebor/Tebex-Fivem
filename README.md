# Tebex.io wrapper for FiveM (Plus Plan required!)
---

### Installation
- Download the latest version of this resource
- Put the resource inside your `resources` folder
- Add `ensure tebex` into your `server.cfg` file
- *You should have already setup the `sv_tebexSecret` at your `server.cfg` file!*

### Tebex setup
- Get into your [Tebex dashboard](https://server.tebex.io/)
- Then open your [Webhooks](https://server.tebex.io/webhooks) settings at [Integrations > Webhooks](https://server.tebex.io/webhooks)
- Fill the webhook URL text box with `http://your-server-ip:30120/tebex/payments` *the port is your FiveM server port!*

### Usage
- Handle the event `tebex:newPayment` at any server-side resource file!
- Check the [example.lua](tebex/example.lua) file for useful examples