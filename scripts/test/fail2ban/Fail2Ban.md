### These are some settings found to perform a BanHammer on those who want to hack into your server via SSH.
Reference : https://nerdily.org/2017/upgrading-fail2ban-to-a-permanent-banhammer/


On a fresh server if you wait an hour or so, this will show you a list of IP's that have been trying to access your server :-
```sh
sudo cat /var/log/fail2ban.log
```
Make copy of jail
```sh
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
```
Edit jail.local
```sh
sudo nano /etc/fail2ban/jail.local
```
Change host bantime from 600 to -1 for infinity
```sh
bantime = -1
```
Then edit iptables
```sh
sudo nano /etc/fail2ban/action.d/iptables-multiport.conf
```
Find :-
```sh
actionstart = <iptables> -N f2b-<name>
              <iptables> -A f2b-<name> -j <returntype>
              <iptables> -I <chain> -p <protocol> -m multiport --dports <port> -j f2b-<name>
```
Underneath add :-
```sh
     cat /etc/fail2ban/persistent.bans | awk '/^fail2ban-<name>/ {print $2}' \
     | while read IP; do iptables -I fail2ban-<name> 1 -s $IP -j <blocktype>; done
```
Find :-
```sh
actionban = <iptables> -I f2b-<name> 1 -s <ip> -j <blocktype>
```
Underneath add :-
```sh
     echo "fail2ban-<name> <ip>" >> /etc/fail2ban/persistent.bans
```
Finally restart Fail2Ban
```sh
sudo service fail2ban restart
```

