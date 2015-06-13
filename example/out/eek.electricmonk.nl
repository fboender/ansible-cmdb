{
    "ansible_facts": {
        "ansible_all_ipv4_addresses": [
            "192.168.0.10"
        ], 
        "ansible_all_ipv6_addresses": [
            "fe80::e2cb:4eff:fea7:4b56"
        ], 
        "ansible_architecture": "i386", 
        "ansible_bios_date": "12/17/2009", 
        "ansible_bios_version": "5.06", 
        "ansible_cmdline": {
            "BOOT_IMAGE": "/vmlinuz-3.13.0-44-generic", 
            "quiet": true, 
            "ro": true, 
            "root": "/dev/mapper/live-root", 
            "splash": true, 
            "vt.handoff": "7"
        }, 
        "ansible_date_time": {
            "date": "2015-06-13", 
            "day": "13", 
            "epoch": "1434208610", 
            "hour": "17", 
            "iso8601": "2015-06-13T15:16:50Z", 
            "iso8601_micro": "2015-06-13T15:16:50.416025Z", 
            "minute": "16", 
            "month": "06", 
            "second": "50", 
            "time": "17:16:50", 
            "tz": "CEST", 
            "tz_offset": "+0200", 
            "weekday": "Saturday", 
            "year": "2015"
        }, 
        "ansible_default_ipv4": {
            "address": "192.168.0.10", 
            "alias": "eth0", 
            "gateway": "192.168.0.1", 
            "interface": "eth0", 
            "macaddress": "e0:cb:4e:a7:4b:56", 
            "mtu": 1500, 
            "netmask": "255.255.255.0", 
            "network": "192.168.0.0", 
            "type": "ether"
        }, 
        "ansible_default_ipv6": {}, 
        "ansible_devices": {
            "sda": {
                "holders": [], 
                "host": "IDE interface: Intel Corporation NM10/ICH7 Family SATA Controller [IDE mode] (rev 01)", 
                "model": "ST3320418AS", 
                "partitions": {
                    "sda1": {
                        "sectors": "497664", 
                        "sectorsize": 512, 
                        "size": "243.00 MB", 
                        "start": "2048"
                    }, 
                    "sda2": {
                        "sectors": "2", 
                        "sectorsize": 512, 
                        "size": "1.00 KB", 
                        "start": "501758"
                    }, 
                    "sda5": {
                        "sectors": "624640000", 
                        "sectorsize": 512, 
                        "size": "297.85 GB", 
                        "start": "501760"
                    }
                }, 
                "removable": "0", 
                "rotational": "1", 
                "scheduler_mode": "deadline", 
                "sectors": "625142448", 
                "sectorsize": "512", 
                "size": "298.09 GB", 
                "support_discard": "0", 
                "vendor": "ATA"
            }, 
            "sdb": {
                "holders": [], 
                "host": "IDE interface: Intel Corporation NM10/ICH7 Family SATA Controller [IDE mode] (rev 01)", 
                "model": "ST4000DM000-1F21", 
                "partitions": {}, 
                "removable": "0", 
                "rotational": "1", 
                "scheduler_mode": "deadline", 
                "sectors": "7814037168", 
                "sectorsize": "4096", 
                "size": "29.11 TB", 
                "support_discard": "0", 
                "vendor": "ATA"
            }, 
            "sdc": {
                "holders": [], 
                "host": "USB controller: Intel Corporation NM10/ICH7 Family USB2 EHCI Controller (rev 01)", 
                "model": "Flash Reader", 
                "partitions": {}, 
                "removable": "1", 
                "rotational": "1", 
                "scheduler_mode": "deadline", 
                "sectors": "0", 
                "sectorsize": "512", 
                "size": "0.00 Bytes", 
                "support_discard": "0", 
                "vendor": "Multi"
            }
        }, 
        "ansible_distribution": "Ubuntu", 
        "ansible_distribution_major_version": "14", 
        "ansible_distribution_release": "trusty", 
        "ansible_distribution_version": "14.04", 
        "ansible_domain": "electricmonk.nl", 
        "ansible_env": {
            "EDITOR": "vim", 
            "GDK_USE_XFT": "1", 
            "HOME": "/home/fboender", 
            "LANG": "en_US.UTF-8", 
            "LANGUAGE": "en_US.UTF-8", 
            "LC_ALL": "en_US.UTF-8", 
            "LC_CTYPE": "en_US.UTF-8", 
            "LESS": "-RgiMSx4 -FX", 
            "LOGNAME": "fboender", 
            "LS_COLORS": "rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36::ow=103;30;01:", 
            "PAGER": "less", 
            "PATH": "~/bin:/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/games:/usr/local/sbin:/usr/sbin:/sbin:~/bin/:", 
            "PWD": "/home/fboender", 
            "SHELL": "/bin/bash", 
            "SHLVL": "1", 
            "SSH_CLIENT": "192.168.0.3 44283 22", 
            "SSH_CONNECTION": "192.168.0.3 44283 192.168.0.10 22", 
            "SSH_TTY": "/dev/pts/1", 
            "TERM": "xterm-256color", 
            "TNS_ADMIN": "/usr/local/lib/instantclient_10_2/network/admin/", 
            "USER": "fboender", 
            "XDG_RUNTIME_DIR": "/run/user/1000", 
            "XDG_SESSION_COOKIE": "465fd05aaf059cdcd190e45f517192e3-1434208609.195433-1496522230", 
            "XDG_SESSION_ID": "42", 
            "_": "/bin/sh"
        }, 
        "ansible_eth0": {
            "active": true, 
            "device": "eth0", 
            "ipv4": {
                "address": "192.168.0.10", 
                "netmask": "255.255.255.0", 
                "network": "192.168.0.0"
            }, 
            "ipv6": [
                {
                    "address": "fe80::e2cb:4eff:fea7:4b56", 
                    "prefix": "64", 
                    "scope": "link"
                }
            ], 
            "macaddress": "e0:cb:4e:a7:4b:56", 
            "module": "r8169", 
            "mtu": 1500, 
            "promisc": false, 
            "type": "ether"
        }, 
        "ansible_fips": false, 
        "ansible_form_factor": "Desktop", 
        "ansible_fqdn": "eek.electricmonk.nl", 
        "ansible_hostname": "eek", 
        "ansible_interfaces": [
            "lo", 
            "eth0"
        ], 
        "ansible_kernel": "3.13.0-44-generic", 
        "ansible_lo": {
            "active": true, 
            "device": "lo", 
            "ipv4": {
                "address": "127.0.0.1", 
                "netmask": "255.0.0.0", 
                "network": "127.0.0.0"
            }, 
            "ipv6": [
                {
                    "address": "::1", 
                    "prefix": "128", 
                    "scope": "host"
                }
            ], 
            "mtu": 65536, 
            "promisc": false, 
            "type": "loopback"
        }, 
        "ansible_lsb": {
            "codename": "trusty", 
            "description": "Ubuntu 14.04.1 LTS", 
            "id": "Ubuntu", 
            "major_release": "14", 
            "release": "14.04"
        }, 
        "ansible_machine": "i686", 
        "ansible_machine_id": "465fd05aaf059cdcd190e45f517192e3", 
        "ansible_memfree_mb": 245, 
        "ansible_memory_mb": {
            "nocache": {
                "free": 2069, 
                "used": 926
            }, 
            "real": {
                "free": 245, 
                "total": 2995, 
                "used": 2750
            }, 
            "swap": {
                "cached": 15, 
                "free": 2902, 
                "total": 3035, 
                "used": 133
            }
        }, 
        "ansible_memtotal_mb": 2995, 
        "ansible_mounts": [
            {
                "device": "/dev/mapper/live-root", 
                "fstype": "ext4", 
                "mount": "/", 
                "options": "rw,errors=remount-ro", 
                "size_available": 290729607168, 
                "size_total": 311513391104, 
                "uuid": ""
            }, 
            {
                "device": "/dev/sdb", 
                "fstype": "ext4", 
                "mount": "/storage", 
                "options": "rw,errors=remount-ro", 
                "size_available": 1001502662656, 
                "size_total": 3937873526784, 
                "uuid": ""
            }, 
            {
                "device": "/dev/sda1", 
                "fstype": "ext2", 
                "mount": "/boot", 
                "options": "rw", 
                "size_available": 139682816, 
                "size_total": 238787584, 
                "uuid": ""
            }
        ], 
        "ansible_nodename": "eek", 
        "ansible_os_family": "Debian", 
        "ansible_pkg_mgr": "apt", 
        "ansible_processor": [
            "GenuineIntel", 
            "Pentium(R) Dual-Core  CPU      E5300  @ 2.60GHz", 
            "GenuineIntel", 
            "Pentium(R) Dual-Core  CPU      E5300  @ 2.60GHz"
        ], 
        "ansible_processor_cores": 2, 
        "ansible_processor_count": 1, 
        "ansible_processor_threads_per_core": 1, 
        "ansible_processor_vcpus": 2, 
        "ansible_product_name": "WL239AA-ABH s5330nl", 
        "ansible_product_serial": "NA", 
        "ansible_product_uuid": "NA", 
        "ansible_product_version": "NA", 
        "ansible_python_version": "2.7.6", 
        "ansible_selinux": false, 
        "ansible_ssh_host_key_dsa_public": "AAAAB3NzaC1kc3MAAACBAM1jDUCvPyiO7vXbDXd/H9+dv4zM08KaaCrSIlIBk5rIL57ERtJ+dARuL3c5SyehsHCgDnOuLkxUB4QT6GresjlvorHIm+tj/eWAhiIQ/giTjNWsRSSwzey0MibaCOyO2neo0xLY8NTTfYuJqEoZSduY5cabrVpBK1RouogPRPBjAAAAFQDHLOaokUARAewpVTOCmet1N4VOjQAAAIEApykRAohSkQZkv3I0xVaF9PgBvNfM9CenP4OCXjpF4tfloGNyWQA1YpgP3gNz53GlNXiwStfYuL8/JtS1H94GZP0ITDbvG4RRWRsdocLJIC4ggZjHb8URIOAwJl+jxHuv0JmyXT5AvfS7SUOYBeYc8hOA5u3FZ4oE4SKLpy4Ns4gAAACAOTUTPRYa0sw+P5IPTUy787xlLRkINnpOhObHEV99NcQRSck/tpiYZFs0Tvk2iG1eXyAn1pybrYOgY8GfsJalhQrSbmQacrbY4vVVxOFe/qL6Xz+hHTW4zrORcKYhB4SXM0rfp2KgdeL1rp9ciA0VsphUE7ydWG+xwmiUNIXadzE=", 
        "ansible_ssh_host_key_ecdsa_public": "AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBE7fPU479aa8KWrXyO5ANtNhxA4at2lVUg6FSAq2/WnxAwDJ2fdQ1cHaqtOQnl99r+c63shnVcXsv1MoMJX556k=", 
        "ansible_ssh_host_key_rsa_public": "AAAAB3NzaC1yc2EAAAADAQABAAABAQDG+L9giLHk6KbbQizra1nC7kOH9hmrSelPjFp78hvzeCwsHx1kpgqLK/VZ0HejzEn/KkXj5zImYhhSuSCicos8567/TvFc8HBDrD80d0QPqVf75lGqfKTsNtnvIpOJIYSw+PilQ8JY1MmodO1tY/PHDo5W67kALITtggAXV5am2NUPJwv14Gm1dmXzIfV3o03fIndx/qE+rqbwQvq6JMP3eVhsTXqEnKarOCBX6bC/yOKVq9h7Gp0yHdatp12qNlMS/4sE/5xuz+PxZYz8JlrkDRsIYlZTLgt30t7vdfbSy8E56c5OA+jdYi/k9A8pH8VHyuIcXPL+bhfDZiJGfxPP", 
        "ansible_swapfree_mb": 2902, 
        "ansible_swaptotal_mb": 3035, 
        "ansible_system": "Linux", 
        "ansible_system_vendor": "HP-Pavilion", 
        "ansible_user_dir": "/home/fboender", 
        "ansible_user_gecos": "Ferry Boender,,,", 
        "ansible_user_gid": 1000, 
        "ansible_user_id": "fboender", 
        "ansible_user_shell": "/bin/bash", 
        "ansible_user_uid": 1000, 
        "ansible_userspace_architecture": "i386", 
        "ansible_userspace_bits": "32", 
        "ansible_virtualization_role": "host", 
        "ansible_virtualization_type": "kvm", 
        "module_setup": true
    }, 
    "changed": false
}