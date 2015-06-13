{
    "ansible_facts": {
        "ansible_all_ipv4_addresses": [
            "194.187.79.11"
        ], 
        "ansible_all_ipv6_addresses": [
            "fe80::250:56ff:fe01:3b0"
        ], 
        "ansible_architecture": "x86_64", 
        "ansible_bios_date": "04/14/2014", 
        "ansible_bios_version": "6.00", 
        "ansible_cmdline": {
            "BOOT_IMAGE": "/vmlinuz-3.16.0-37-generic", 
            "ro": true, 
            "root": "/dev/mapper/vm1--vg-root"
        }, 
        "ansible_date_time": {
            "date": "2015-06-13", 
            "day": "13", 
            "epoch": "1434208651", 
            "hour": "17", 
            "iso8601": "2015-06-13T15:17:31Z", 
            "iso8601_micro": "2015-06-13T15:17:31.547429Z", 
            "minute": "17", 
            "month": "06", 
            "second": "31", 
            "time": "17:17:31", 
            "tz": "CEST", 
            "tz_offset": "+0200", 
            "weekday": "Saturday", 
            "year": "2015"
        }, 
        "ansible_default_ipv4": {
            "address": "194.187.79.11", 
            "alias": "eth0", 
            "gateway": "194.187.79.1", 
            "interface": "eth0", 
            "macaddress": "00:50:56:01:03:b0", 
            "mtu": 1500, 
            "netmask": "255.255.255.192", 
            "network": "194.187.79.0", 
            "type": "ether"
        }, 
        "ansible_default_ipv6": {}, 
        "ansible_devices": {
            "fd0": {
                "holders": [], 
                "host": "", 
                "model": null, 
                "partitions": {}, 
                "removable": "1", 
                "rotational": "1", 
                "scheduler_mode": "deadline", 
                "sectors": "0", 
                "sectorsize": "512", 
                "size": "0.00 Bytes", 
                "support_discard": "0", 
                "vendor": null
            }, 
            "sda": {
                "holders": [], 
                "host": "SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 01)", 
                "model": "Virtual disk", 
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
                    "sda3": {
                        "sectors": "234883072", 
                        "sectorsize": 512, 
                        "size": "112.00 GB", 
                        "start": "33552384"
                    }, 
                    "sda5": {
                        "sectors": "33050624", 
                        "sectorsize": 512, 
                        "size": "15.76 GB", 
                        "start": "501760"
                    }
                }, 
                "removable": "0", 
                "rotational": "1", 
                "scheduler_mode": "deadline", 
                "sectors": "268435456", 
                "sectorsize": "512", 
                "size": "128.00 GB", 
                "support_discard": "0", 
                "vendor": "VMware"
            }, 
            "sr0": {
                "holders": [], 
                "host": "IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01)", 
                "model": "VMware IDE CDR00", 
                "partitions": {}, 
                "removable": "1", 
                "rotational": "1", 
                "scheduler_mode": "deadline", 
                "sectors": "1218560", 
                "sectorsize": "2048", 
                "size": "2.32 GB", 
                "support_discard": "0", 
                "vendor": "NECVMWar"
            }
        }, 
        "ansible_distribution": "Ubuntu", 
        "ansible_distribution_major_version": "14", 
        "ansible_distribution_release": "trusty", 
        "ansible_distribution_version": "14.04", 
        "ansible_domain": "melkfl.es", 
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
            "SSH_CLIENT": "212.187.48.56 47364 22", 
            "SSH_CONNECTION": "212.187.48.56 47364 194.187.79.11 22", 
            "SSH_TTY": "/dev/pts/3", 
            "TERM": "xterm-256color", 
            "TNS_ADMIN": "/usr/local/lib/instantclient_10_2/network/admin/", 
            "USER": "fboender", 
            "XDG_RUNTIME_DIR": "/run/user/1002", 
            "XDG_SESSION_ID": "946", 
            "_": "/bin/sh"
        }, 
        "ansible_eth0": {
            "active": true, 
            "device": "eth0", 
            "ipv4": {
                "address": "194.187.79.11", 
                "netmask": "255.255.255.192", 
                "network": "194.187.79.0"
            }, 
            "ipv6": [
                {
                    "address": "fe80::250:56ff:fe01:3b0", 
                    "prefix": "64", 
                    "scope": "link"
                }
            ], 
            "macaddress": "00:50:56:01:03:b0", 
            "module": "e1000", 
            "mtu": 1500, 
            "promisc": false, 
            "type": "ether"
        }, 
        "ansible_fips": false, 
        "ansible_form_factor": "Other", 
        "ansible_fqdn": "zoltar-new.melkfl.es", 
        "ansible_hostname": "zoltar", 
        "ansible_interfaces": [
            "lo", 
            "eth0"
        ], 
        "ansible_kernel": "3.16.0-37-generic", 
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
            "description": "Ubuntu 14.04.2 LTS", 
            "id": "Ubuntu", 
            "major_release": "14", 
            "release": "14.04"
        }, 
        "ansible_machine": "x86_64", 
        "ansible_machine_id": "c64d3c2e1f3a7d04ac52df465523c7ba", 
        "ansible_memfree_mb": 909, 
        "ansible_memory_mb": {
            "nocache": {
                "free": 3114, 
                "used": 839
            }, 
            "real": {
                "free": 909, 
                "total": 3953, 
                "used": 3044
            }, 
            "swap": {
                "cached": 11, 
                "free": 4068, 
                "total": 4091, 
                "used": 23
            }
        }, 
        "ansible_memtotal_mb": 3953, 
        "ansible_mounts": [
            {
                "device": "/dev/mapper/vm1--vg-root", 
                "fstype": "ext4", 
                "mount": "/", 
                "options": "rw,errors=remount-ro", 
                "size_available": 28847923200, 
                "size_total": 130666967040, 
                "uuid": ""
            }, 
            {
                "device": "/dev/sda1", 
                "fstype": "ext2", 
                "mount": "/boot", 
                "options": "rw", 
                "size_available": 97247232, 
                "size_total": 246755328, 
                "uuid": ""
            }
        ], 
        "ansible_nodename": "zoltar", 
        "ansible_os_family": "Debian", 
        "ansible_pkg_mgr": "apt", 
        "ansible_processor": [
            "GenuineIntel", 
            "Intel(R) Xeon(R) CPU E5-2680 0 @ 2.70GHz", 
            "GenuineIntel", 
            "Intel(R) Xeon(R) CPU E5-2680 0 @ 2.70GHz"
        ], 
        "ansible_processor_cores": 1, 
        "ansible_processor_count": 2, 
        "ansible_processor_threads_per_core": 1, 
        "ansible_processor_vcpus": 2, 
        "ansible_product_name": "VMware Virtual Platform", 
        "ansible_product_serial": "NA", 
        "ansible_product_uuid": "NA", 
        "ansible_product_version": "None", 
        "ansible_python_version": "2.7.6", 
        "ansible_selinux": false, 
        "ansible_ssh_host_key_dsa_public": "AAAAB3NzaC1kc3MAAACBAKxeCwoC0SuiLJSAV8Ddu+wg/o+JUafhBZvSnNIdDRhsK0kkoyIgl+YtXvqf10noeMs5hNBC235S3iY/p8s4hGSTMicEaPq+zYtCyHfhEfce/lB2tglQmqehCqW9RJAxyulvfpy55bVnvdRCqI9IkfsB78FP7zehEjerlr44GkRrAAAAFQD/Yp+ska/3rothPAbA1ZKJ1BUIBwAAAIEAje6UMAPMmN9qla2XGZHI7CTnII501WcY9kXkvv9POh8cNuHkXo9olNguJmWmNhQIqOJtCQZl90oeW0zDlLxvqarUd/6ReeThl5/ZSdcnDDTsAGz15xKD1VQSGbOeYT9ltESNijIQrtJQnOQ5/MPWHo6OoeE/lhIMu+IqWjBQ+DgAAACAG6XG+OurAg8J4sLBLD/YuSZnOLgc48DjHKuRjYqpmt4DI7IcrCM61TgLeFyWpILtlkfeydaKSxBwrXZvaxNt7jKZLdXrVcqoRR9T8mYq7aYFQKC59z4BdyfUbcq3B1CqgjGQAOtPjXG7FEbcsylORfYSpn/XhNmVpufQTJU7RXY=", 
        "ansible_ssh_host_key_ecdsa_public": "AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBJva+sNQx/rb0uR2EoAwYo5XhWhNvchgAfiZekHnClNMQ1bvEmVfcSZWh0AHV4+BFstNCl0FP0iyvCU/ygJ1uZo=", 
        "ansible_ssh_host_key_rsa_public": "AAAAB3NzaC1yc2EAAAADAQABAAABAQDMKSEFIWU4Y5scoPdHLh4QX3r6vuxsL49EYC+H2odTeaOyhfOoxchKWugy0xMQy6JCFo1YizHBiKRopM3P1rBP0gJC2YQC8e6AvD8CeI2/iPgazzOP8RNJO0k7HV+3XQDIfAPre5EF8f94oowrzbMZGljFW8KsnZ603h8CffsYLcYJo/VsS1qD+hX074VNgeLd75770VlJasAvQVHgBnEM9UaLh9UVjYzxhw4qHh16yO2PxjDtwTHiF2s5VN9BOZQTpre8exUIQJy+GzqSDhJGij9dyIv26WmhYBpwUkBjX7Z+ohsGwuT9IaE7wJRlabqKsiIhsb4US87auPy2Tibj", 
        "ansible_swapfree_mb": 4068, 
        "ansible_swaptotal_mb": 4091, 
        "ansible_system": "Linux", 
        "ansible_system_vendor": "VMware, Inc.", 
        "ansible_user_dir": "/home/fboender", 
        "ansible_user_gecos": "Ferry Boender,,,", 
        "ansible_user_gid": 1002, 
        "ansible_user_id": "fboender", 
        "ansible_user_shell": "/bin/bash", 
        "ansible_user_uid": 1002, 
        "ansible_userspace_architecture": "x86_64", 
        "ansible_userspace_bits": "64", 
        "ansible_virtualization_role": "guest", 
        "ansible_virtualization_type": "VMware", 
        "module_setup": true
    }, 
    "changed": false
}