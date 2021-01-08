# Tebex.io wrapper for FiveM
---

### Installation
- Download the latest version of this resource
- Put the resource inside your `resources` folder
- Add `ensure tebex` into your `server.cfg` file

### Usage
- Import tebex to your resource with `server_script '@tebex/lib/tebex.lua'`
- Check the [example.lua](tebex/example.lua) file
---

### Methods
| Method | Description | Returns |
|--------|-------------|---------|
| GetPurchaseFromTransaction | Get purchase info from transaction id (use currently saved data *faster*) | `table` |
| OnPackageNameBought | Set a function to execute when a package matching the name is bought | `nil` |
| OnPackageIdBought | Set a function to execute when a package matching the id is bought | `nil` |
| GetAccountInfo | Get current tebex account info | `table` |
| GetPackages | Get full list of packages | `metatable` |
| GetPackages():GetPackageByName | Get package info matching name | `table` |
| GetPackages():GetPackageById | Get Package info matching id | `table` |
| DoesPlayerBoughtPackage | Get if the player bought a package matching the name (string) or id (number) | `boolean` |
| GetPaymentInfo | Get info of a payment with transaction id (use API request *slower*) | `table` |

### Accessible data
#### Purchase *from OnPackage[Name/Id]Bought*
| Index | Type |
|-------|------|
| **Transaction** | table |
| Id | number |
| Server | string |
| Price | number |
| Currency | string |
| FullPrice | string |
| Date | string |
| Quantity | number |
| **Package** | table |
| Id | number |
| Price | number |
| Expiry | string |
| Name | string |
| **Purchaser** | table |
| Name | string |
| UUID | number |

#### Package *from Tebex:GetPackages():GetPackageByName*
**A table with this index:** https://docs.tebex.io/plugin/endpoints/packages#retrieve-a-package

#### Account *from Tebex:GetAccountInfo()*
**A table with this index:** https://docs.tebex.io/plugin/endpoints/information#get-server-information
