# Lab 4: DNS and Network Configuration with Hosts File and BIND9

## Objective
Demonstrate the differences between using the hosts file and DNS for URL resolution. Modify the hosts file to resolve a URL to a specific IP address, then configure BIND9 as a DNS solution to resolve wildcard subdomains and verify resolution using `dig` or `nslookup`.

---

## Steps to Complete the Task

### 1. **Modify the Hosts File for Manual Resolution**
   The first step is to manually modify the `/etc/hosts` file to resolve a URL to a specific IP address.
   
   1. Open the `/etc/hosts` file:
      ```bash
      sudo nano /etc/hosts
      ```

   2. Add the following line to map a URL to an IP address (e.g., `name-ivolve.com` to `192.168.1.10`):
      ```
      192.168.1.10  name-ivolve.com
      ```

   3. Save and exit the file (`Ctrl + X`, then `Y` to confirm changes, and `Enter`).

   4. Test the resolution using `ping`:
      ```bash
      ping name-ivolve.com
      ```

   You should see that the system now resolves `name-ivolve.com` to `192.168.1.10`.

---

### 2. **Install and Configure BIND9 for DNS Resolution**
   Next, you will configure a DNS server using BIND9 to resolve subdomains.

   1. **Install BIND9**:
      ```bash
      sudo apt update
      sudo apt install bind9 bind9utils bind9-doc
      ```

   2. **Configure the DNS Zone File**:
      - Create a new zone configuration in the BIND configuration file.
      - Edit the `/etc/bind/named.conf.local` file:
        ```bash
        sudo nano /etc/bind/named.conf.local
        ```

      - Add a new zone configuration:
        ```
        zone "name-ivolve.com" {
            type master;
            file "/etc/bind/db.name-ivolve.com";
        };
        ```

   3. **Create the Zone File**:
      - Create the DNS zone file at `/etc/bind/db.name-ivolve.com`:
        ```bash
        sudo nano /etc/bind/db.name-ivolve.com
        ```

      - Add the following contents:
        ```
        $TTL 86400
        @    IN    SOA   ns1.name-ivolve.com. admin.name-ivolve.com. (
                        2023120301 ; Serial
                        604800     ; Refresh
                        86400      ; Retry
                        2419200    ; Expire
                        86400 )    ; Minimum TTL

        ; Name Servers
        @    IN    NS    ns1.name-ivolve.com.

        ; A Records for the domain
        @    IN    A     192.168.1.10

        ; Wildcard subdomains
        *    IN    A     192.168.1.10
        ```

   4. **Configure the Forward and Reverse Zones** (if needed):
      If you need reverse DNS lookup or additional subdomains, configure the reverse zone as well by editing `/etc/bind/named.conf.local` and `/etc/bind/db.name-ivolve.com.rev`.

   5. **Restart BIND9**:
      After making changes to the configuration files, restart the BIND9 service:
      ```bash
      sudo systemctl restart bind9
      ```

   6. **Test DNS Resolution**:
      To check if the DNS server is working correctly, use `dig` or `nslookup`:
      ```bash
      dig @localhost name-ivolve.com
      ```

      This should return the `A` record for `name-ivolve.com` pointing to `192.168.1.10`.

   You can also test the wildcard subdomain:
   ```bash
   dig @localhost random.name-ivolve.com


