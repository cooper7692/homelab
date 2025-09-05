# Inventory

## Hosts
- **node1_ubuntu_ip**: `192.168.1.231`
- **node2_ubuntu_ip**: `192.168.1.172`
- **windows_node_ip**: `192.168.1.233`
- **truenas_ip**: `192.168.1.45`
- **homeassistant_ip**: `192.168.1.246`
- **UDM_ip**: `192.168.1.1`

## Services
| Service | DNS | Node | IP | Port |
|---|---|---|---|---|
| sonarr | sonarr.ttgs.io | node1 | 192.168.1.231 | 8989 |
| radarr | radarr.ttgs.io | node1 | 192.168.1.231 | 7878 |
| prowlarr | prowlarr.ttgs.io | node1 | 192.168.1.231 | 9696 |
| qbt | qbt.ttgs.io | node1 | 192.168.1.231 | 8080 |
| ha | ha.ttgs.io | Homeassistant | 192.168.1.246 | 8123 |
| unifi | unifi.ttgs.io | UDM | <IP_FOR_UDM> | 8443 |
| tdarr | tdarr.ttgs.io | windows | 192.168.1.233 | 8265 |
| paperless | paperless.ttgs.io | TBD | <TBD> | 8000 |
| huntarr | huntarr.ttgs.io | node1 | 192.168.1.231 | 3000 |
| plex | plex.ttgs.io | windows | 192.168.1.233 | 32400 |
| proxy | proxy.ttgs.io | node1 | 192.168.1.231 | 7777 |
| node1 | node1.ttgs.io | node1 | 192.168.1.231 | 22 |
| node2 | node2.ttgs.io | node2 | 192.168.1.172 | 22 |
| truenas | truenas.ttgs.io | nas | 192.168.1.45 | 443 |
