# etcd Chef cookbook for Gentoo

### Recipes
| Name | Description |
|:-----|:------------|
| `default` | Install etcd, and enable/start the service

## Attributes

| Attribute | Default | Description |
|:---------------------------------|:---------------|:-----------------------------------------|
|`default['etcd']['name']`| `nil` | Defaults to `nil`; will attempt to get EC2 instance ID from http://169.254.169.254 service |
|`default['etcd']['discovery']` | `nil` | Discovery URL — get one from http://discovery.etcd.io/new?size=7 |
|`default['etcd']['version']` | `v2.0.11` | Version of etcd which will be downloaded and installed |
|`default['etcd']['sha256']` | `b351d05f` | SHA256 checksum for the downloaded etcd release archive |
|`default['etcd']['data_dir']` | `/db/etcd` | Directory for etcd WAL and snapshot files |
|`default['etcd']['user']`| `etcd` | User the etcd daemon will run as |
|`default['etcd']['group']` | `etcd` | Group the daemon will run as |

## Usage
#### Single-instance node:
Simply add the following to your main cookbook:
````
include_recipe 'etcd::default'
````

## Setting up a cluster

Go to https://discovery.etcd.io/new?size=7 to get a new token URL to use for automatic node discovery, then set `node['etcd']['discovery']` with this value.
