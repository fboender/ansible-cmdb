{
    "ansible_facts": {
        "ansible_all_ipv4_addresses": [
            "192.168.0.3", 
            "192.168.56.1"
        ], 
        "ansible_all_ipv6_addresses": [], 
        "ansible_architecture": "x86_64", 
        "ansible_bios_date": "07/16/2014", 
        "ansible_bios_version": "A06", 
        "ansible_cmdline": {
            "BOOT_IMAGE": "/boot/vmlinuz-3.16.1-031601-generic", 
            "quiet": true, 
            "ro": true, 
            "root": "UUID=a1cd04ba-d816-471d-ba29-516ed875b89d", 
            "splash": true, 
            "vt.handoff": "7"
        }, 
        "ansible_date_time": {
            "date": "2015-06-13", 
            "day": "13", 
            "epoch": "1434208649", 
            "hour": "17", 
            "iso8601": "2015-06-13T15:17:29Z", 
            "iso8601_micro": "2015-06-13T15:17:29.919816Z", 
            "minute": "17", 
            "month": "06", 
            "second": "29", 
            "time": "17:17:29", 
            "tz": "CEST", 
            "tz_offset": "+0200", 
            "weekday": "Saturday", 
            "year": "2015"
        }, 
        "ansible_default_ipv4": {
            "address": "192.168.0.3", 
            "alias": "wlan0", 
            "gateway": "192.168.0.1", 
            "interface": "wlan0", 
            "macaddress": "e8:2a:ea:62:a0:bb", 
            "mtu": 1500, 
            "netmask": "255.255.255.0", 
            "network": "192.168.0.0", 
            "type": "ether"
        }, 
        "ansible_default_ipv6": {}, 
        "ansible_devices": {
            "sda": {
                "holders": [], 
                "host": "RAID bus controller: Intel Corporation 82801 Mobile SATA Controller [RAID mode] (rev 05)", 
                "model": "TOSHIBA MQ02ABF1", 
                "partitions": {
                    "sda1": {
                        "sectors": "1024000", 
                        "sectorsize": 512, 
                        "size": "500.00 MB", 
                        "start": "2048"
                    }, 
                    "sda2": {
                        "sectors": "81920", 
                        "sectorsize": 512, 
                        "size": "40.00 MB", 
                        "start": "1026048"
                    }, 
                    "sda3": {
                        "sectors": "262144", 
                        "sectorsize": 512, 
                        "size": "128.00 MB", 
                        "start": "1107968"
                    }, 
                    "sda4": {
                        "sectors": "4194304", 
                        "sectorsize": 512, 
                        "size": "2.00 GB", 
                        "start": "1370112"
                    }, 
                    "sda5": {
                        "sectors": "699672576", 
                        "sectorsize": 512, 
                        "size": "333.63 GB", 
                        "start": "5564416"
                    }, 
                    "sda6": {
                        "sectors": "19477255", 
                        "sectorsize": 512, 
                        "size": "9.29 GB", 
                        "start": "1934036992"
                    }, 
                    "sda7": {
                        "sectors": "1215129600", 
                        "sectorsize": 512, 
                        "size": "579.42 GB", 
                        "start": "705236992"
                    }, 
                    "sda8": {
                        "sectors": "13670400", 
                        "sectorsize": 512, 
                        "size": "6.52 GB", 
                        "start": "1920366592"
                    }
                }, 
                "removable": "0", 
                "rotational": "1", 
                "scheduler_mode": "deadline", 
                "sectors": "1953525168", 
                "sectorsize": "4096", 
                "size": "7.28 TB", 
                "support_discard": "0", 
                "vendor": "ATA"
            }, 
            "sdb": {
                "holders": [], 
                "host": "RAID bus controller: Intel Corporation 82801 Mobile SATA Controller [RAID mode] (rev 05)", 
                "model": "LITEONIT LMS-32L", 
                "partitions": {
                    "sdb1": {
                        "sectors": "16809984", 
                        "sectorsize": 512, 
                        "size": "8.02 GB", 
                        "start": "2048"
                    }
                }, 
                "removable": "0", 
                "rotational": "0", 
                "scheduler_mode": "deadline", 
                "sectors": "62533296", 
                "sectorsize": "512", 
                "size": "29.82 GB", 
                "support_discard": "512", 
                "vendor": "ATA"
            }
        }, 
        "ansible_distribution": "Linuxmint", 
        "ansible_distribution_major_version": "17", 
        "ansible_distribution_release": "qiana", 
        "ansible_distribution_version": "17", 
        "ansible_domain": "", 
        "ansible_env": {
            "EDITOR": "vim", 
            "GDK_USE_XFT": "1", 
            "HOME": "/home/fboender", 
            "LANG": "en_US.UTF-8", 
            "LANGUAGE": "en_US.UTF-8", 
            "LC_ADDRESS": "nl_NL.UTF-8", 
            "LC_ALL": "en_US.UTF-8", 
            "LC_CTYPE": "en_US.UTF-8", 
            "LC_IDENTIFICATION": "nl_NL.UTF-8", 
            "LC_MEASUREMENT": "nl_NL.UTF-8", 
            "LC_MONETARY": "nl_NL.UTF-8", 
            "LC_NAME": "nl_NL.UTF-8", 
            "LC_NUMERIC": "nl_NL.UTF-8", 
            "LC_PAPER": "nl_NL.UTF-8", 
            "LC_TELEPHONE": "nl_NL.UTF-8", 
            "LC_TIME": "nl_NL.UTF-8", 
            "LESS": "-RgiMSx4 -FX", 
            "LOGNAME": "fboender", 
            "LS_COLORS": "rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36::ow=103;30;01:", 
            "PAGER": "less", 
            "PATH": "~/bin:/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/games:/usr/local/sbin:/usr/sbin:/sbin:~/bin/:", 
            "PWD": "/home/fboender", 
            "SHELL": "/bin/bash", 
            "SHLVL": "1", 
            "SSH_CLIENT": "127.0.0.1 43781 22", 
            "SSH_CONNECTION": "127.0.0.1 43781 127.0.0.1 22", 
            "SSH_TTY": "/dev/pts/15", 
            "TERM": "xterm-256color", 
            "TNS_ADMIN": "/usr/local/lib/instantclient_10_2/network/admin/", 
            "USER": "fboender", 
            "XDG_RUNTIME_DIR": "/run/user/1000", 
            "XDG_SESSION_COOKIE": "1f27ff55dfa2a96246d24e8c53ee2208-1434208649.101589-1394746371", 
            "XDG_SESSION_ID": "12", 
            "_": "/bin/sh"
        }, 
        "ansible_fips": false, 
        "ansible_form_factor": "Portable", 
        "ansible_fqdn": "jib", 
        "ansible_hostname": "jib", 
        "ansible_interfaces": [
            "vboxnet2", 
            "lo", 
            "vboxnet0", 
            "vboxnet1", 
            "wlan0",
            "ovs-system"
        ], 
        "ansible_kernel": "3.16.1-031601-generic", 
        "ansible_lo": {
            "active": true, 
            "device": "lo", 
            "ipv4": {
                "address": "127.0.0.1", 
                "netmask": "255.0.0.0", 
                "network": "127.0.0.0"
            }, 
            "mtu": 65536, 
            "promisc": false, 
            "type": "loopback"
        }, 
        "ansible_lsb": {
            "codename": "qiana", 
            "description": "Linux Mint 17 Qiana", 
            "id": "LinuxMint", 
            "major_release": "17", 
            "release": "17"
        }, 
        "ansible_machine": "x86_64", 
        "ansible_machine_id": "1f27ff55dfa2a96246d24e8c53ee2208", 
        "ansible_memfree_mb": 2000, 
        "ansible_memory_mb": {
            "nocache": {
                "free": 11380, 
                "used": 4571
            }, 
            "real": {
                "free": 2000, 
                "total": 15951, 
                "used": 13951
            }, 
            "swap": {
                "cached": 0, 
                "free": 0, 
                "total": 0, 
                "used": 0
            }
        }, 
        "ansible_memtotal_mb": 15951, 
        "ansible_mounts": [
            {
              "device": "/opt/xensource/packages/iso/XenCenter.iso",
              "fstype": "iso9660",
              "mount": "/var/xen/xc-install",
              "options": "ro,loop=/dev/loop0",
              "size_available": 0,
              "size_total": 0,
              "uuid": "NA"
            }, 
            {
                "device": "/dev/sda1", 
                "fstype": "vfat", 
                "mount": "/boot/efi", 
                "options": "rw", 
                "size_available": 489680896, 
                "size_total": 520093696, 
                "uuid": ""
            }, 
            {
                "device": "/home/fboender/.Private", 
                "fstype": "ecryptfs", 
                "mount": "/home/fboender", 
                "options": "ecryptfs_check_dev_ruid,ecryptfs_cipher=aes,ecryptfs_key_bytes=16", 
                "size_available": 420194226176, 
                "size_total": 612248961024, 
                "uuid": "NA"
            }
        ], 
        "ansible_nodename": "jib", 
        "ansible_os_family": "Linuxmint", 
        "ansible_pkg_mgr": "apt", 
        "ansible_processor": [
            "GenuineIntel", 
            "Intel(R) Core(TM) i7-4712HQ CPU @ 2.30GHz", 
            "GenuineIntel", 
            "Intel(R) Core(TM) i7-4712HQ CPU @ 2.30GHz", 
            "GenuineIntel", 
            "Intel(R) Core(TM) i7-4712HQ CPU @ 2.30GHz", 
            "GenuineIntel", 
            "Intel(R) Core(TM) i7-4712HQ CPU @ 2.30GHz", 
            "GenuineIntel", 
            "Intel(R) Core(TM) i7-4712HQ CPU @ 2.30GHz", 
            "GenuineIntel", 
            "Intel(R) Core(TM) i7-4712HQ CPU @ 2.30GHz", 
            "GenuineIntel", 
            "Intel(R) Core(TM) i7-4712HQ CPU @ 2.30GHz", 
            "GenuineIntel", 
            "Intel(R) Core(TM) i7-4712HQ CPU @ 2.30GHz"
        ], 
        "ansible_processor_cores": 4, 
        "ansible_processor_count": 1, 
        "ansible_processor_threads_per_core": 2, 
        "ansible_processor_vcpus": 8, 
        "ansible_product_name": "XPS 15 9530", 
        "ansible_product_serial": "NA", 
        "ansible_product_uuid": "NA", 
        "ansible_product_version": "A06", 
        "ansible_python_version": "2.7.6", 
        "ansible_selinux": false, 
        "ansible_ssh_host_key_dsa_public": "AAAAB3NzaC1kc3MAAACBAO232JmQyGQuuO37YVY1bKd5Ugh/E2R5+DJzPbnPZOyjuWyYiWjOrkQHd6DR1e3njGCtlsUYmk2FTk3BENQgJTR+9y7AkcP7lkPs/KdvulZHoTFbx3Lstje2oWcHDX+s8KRWf4L12YdNfCwAB4geSIu+PSDH5lCbJ+1GOwcYWZyTAAAAFQCnxWrdqtyOY+JIp+vfciB+R1jcSwAAAIA0hbQmKltCXfbdTUCCFTW3npUMh/OFkXg90cNr4quEk05ac3UeTvNNk3VRoqqUQu5co5iqDNLcofXsPrt+IgVW4DeFP2Tl7MCXlyZxsnCffYG+w/PuUzUOmxSUGUaSCgwEcU3V3Ix+RULw5XlgGKLxEx7M1CkeidaWhNWlX7+hRQAAAIEAhAdUsYZIKYw9cIQUX7DtzPFcoamn/urtqbf5RSWDuE34qBhHm27/VjqeFUefCHsNqDvxxPKnH+XwLL9H2o+Mgn5J9DKKLYzSU2EWZSZKxwZSo3uM1GU+8kq40UT+dIE97ylGy+5Qni6m2DF03oPrfLlgGMoC+VLJ5kMoYPgy+CE=", 
        "ansible_ssh_host_key_ecdsa_public": "AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBI5IV562Ta2wTSPZGEEgPbxyo/bA9frz3uZ2aP9uRNKoHP0oH0oHQFQzzqWNgoGulG21fOxMfk3RprIsJEB8Vgk=", 
        "ansible_ssh_host_key_rsa_public": "AAAAB3NzaC1yc2EAAAADAQABAAABAQCfMkNl1FGOz8oKkx4/Ne1dcCAR4VBPPJxt1+XhlfaBxa8fO36C/QBSHQkhX2kdJ8FqovlXASjz3KPp6bwEuHNCRosRI5Wj5045saK10rZmWY/TobmxoH6Nu7UMXOWjg2UmpcKHhwHNDJzQxhxdgEja/T40newH5ovboU831XqCNpxa7Kg0dHWQXglLM94vHnHMbREQdd+tJdMm917DRS1TaaQWAYrYE7WVY+5K9BdQUgEmSej7XMM4+P40uIhNDpv19Pz9bcrXhPmfGv2YIWDIJk/IT/XLrORag2ak95A7HXrWLrPfD1Ir36wpWaArnk0NzdrXO2tuUtp3oVRyp3LT", 
        "ansible_swapfree_mb": 0, 
        "ansible_swaptotal_mb": 0, 
        "ansible_system": "Linux", 
        "ansible_system_vendor": "Dell Inc.", 
        "ansible_user_dir": "/home/fboender", 
        "ansible_user_gecos": "fboender,,,", 
        "ansible_user_gid": 1000, 
        "ansible_user_id": "fboender", 
        "ansible_user_shell": "/bin/bash", 
        "ansible_user_uid": 1000, 
        "ansible_userspace_architecture": "x86_64", 
        "ansible_userspace_bits": "64", 
        "ansible_vboxnet0": {
            "active": true, 
            "device": "vboxnet0", 
            "ipv4": {
                "address": "192.168.56.1", 
                "netmask": "255.255.255.0", 
                "network": "192.168.56.0"
            }, 
            "macaddress": "0a:00:27:00:00:00", 
            "mtu": 1500, 
            "promisc": true, 
            "type": "ether"
        }, 
        "ansible_vboxnet1": {
            "active": false, 
            "device": "vboxnet1", 
            "macaddress": "0a:00:27:00:00:01", 
            "mtu": 1500, 
            "promisc": false, 
            "type": "ether"
        }, 
        "ansible_vboxnet2": {
            "active": false, 
            "device": "vboxnet2", 
            "macaddress": "0a:00:27:00:00:02", 
            "mtu": 1500, 
            "promisc": false, 
            "type": "ether"
        }, 
        "ansible_virtualization_role": "host", 
        "ansible_virtualization_type": "kvm", 
        "ansible_wlan0": {
            "active": true, 
            "device": "wlan0", 
            "ipv4": {
                "address": "192.168.0.3", 
                "netmask": "255.255.255.0", 
                "network": "192.168.0.0"
            }, 
            "macaddress": "e8:2a:ea:62:a0:bb", 
            "module": "iwlwifi", 
            "mtu": 1500, 
            "promisc": false, 
            "type": "ether"
        }, 
        "module_setup": true
    }, 
    "changed": false
}
