{
    "ansible_facts": {
        "ansible_all_ipv4_addresses": [
            "192.168.57.1"
        ], 
        "ansible_all_ipv6_addresses": [
            "fe80::a00:27ff:fef9:98a7"
        ], 
        "ansible_architecture": "x86_64", 
        "ansible_bios_date": "12/01/2006", 
        "ansible_bios_version": "VirtualBox", 
        "ansible_cmdline": {
            "BOOT_IMAGE": "/vmlinuz-2.6.32-5-amd64", 
            "quiet": true, 
            "ro": true, 
            "root": "/dev/mapper/debian-root"
        }, 
        "ansible_date_time": {
            "date": "2015-06-13", 
            "day": "13", 
            "epoch": "1434208621", 
            "hour": "17", 
            "iso8601": "2015-06-13T15:17:01Z", 
            "iso8601_micro": "2015-06-13T15:17:01.129950Z", 
            "minute": "17", 
            "month": "06", 
            "second": "01", 
            "time": "17:17:01", 
            "tz": "CEST", 
            "tz_offset": "+0200", 
            "weekday": "Saturday", 
            "year": "2015"
        }, 
        "ansible_default_ipv4": {
            "address": "192.168.57.1", 
            "alias": "eth0", 
            "gateway": "192.168.56.1", 
            "interface": "eth0", 
            "macaddress": "08:00:27:f9:98:a7", 
            "mtu": 1500, 
            "netmask": "255.255.255.0", 
            "network": "192.168.57.0", 
            "type": "ether"
        }, 
        "ansible_default_ipv6": {}, 
        "ansible_devices": {
            "sda": {
                "holders": [], 
                "host": "SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA AHCI Controller (rev 02)", 
                "model": "VBOX HARDDISK", 
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
                        "sectors": "209211392", 
                        "sectorsize": 512, 
                        "size": "99.76 GB", 
                        "start": "501760"
                    }
                }, 
                "removable": "0", 
                "rotational": "1", 
                "scheduler_mode": "cfq", 
                "sectors": "209715200", 
                "sectorsize": "512", 
                "size": "100.00 GB", 
                "support_discard": null, 
                "vendor": "ATA"
            }, 
            "sr0": {
                "holders": [], 
                "host": "IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01)", 
                "model": "CD-ROM", 
                "partitions": {}, 
                "removable": "1", 
                "rotational": "1", 
                "scheduler_mode": "cfq", 
                "sectors": "2097151", 
                "sectorsize": "512", 
                "size": "1024.00 MB", 
                "support_discard": null, 
                "vendor": "VBOX"
            }
        }, 
        "ansible_distribution": "Debian", 
        "ansible_distribution_major_version": "6", 
        "ansible_distribution_release": "NA", 
        "ansible_distribution_version": "6.0.10", 
        "ansible_domain": "", 
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
            "LS_COLORS": "rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36::ow=103;30;01:", 
            "PAGER": "less", 
            "PATH": "~/bin:/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/games:/usr/local/sbin:/usr/sbin:/sbin:~/bin/:", 
            "PWD": "/home/fboender", 
            "SHELL": "/bin/bash", 
            "SHLVL": "1", 
            "SSH_CLIENT": "192.168.56.1 48074 22", 
            "SSH_CONNECTION": "192.168.56.1 48074 192.168.57.1 22", 
            "SSH_TTY": "/dev/pts/1", 
            "TERM": "xterm-256color", 
            "TNS_ADMIN": "/usr/local/lib/instantclient_10_2/network/admin/", 
            "USER": "fboender", 
            "_": "/bin/sh"
        }, 
        "ansible_eth0": {
            "active": true, 
            "device": "eth0", 
            "ipv4": {
                "address": "192.168.57.1", 
                "netmask": "255.255.255.0", 
                "network": "192.168.57.0"
            }, 
            "ipv6": [
                {
                    "address": "fe80::a00:27ff:fef9:98a7", 
                    "prefix": "64", 
                    "scope": "link"
                }
            ], 
            "macaddress": "08:00:27:f9:98:a7", 
            "module": "pcnet32", 
            "mtu": 1500, 
            "promisc": false, 
            "type": "ether"
        }, 
        "ansible_fips": false, 
        "ansible_form_factor": "Other", 
        "ansible_fqdn": "localhost", 
        "ansible_hostname": "dev", 
        "ansible_interfaces": [
            "lo", 
            "eth0"
        ], 
        "ansible_kernel": "2.6.32-5-amd64", 
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
            "mtu": 16436, 
            "promisc": false, 
            "type": "loopback"
        }, 
        "ansible_lsb": {
            "codename": "squeeze", 
            "description": "Debian GNU/Linux 6.0.10 (squeeze)", 
            "id": "Debian", 
            "major_release": "6", 
            "release": "6.0.10"
        }, 
        "ansible_machine": "x86_64", 
        "ansible_machine_id": "00a3ac55878f7a9340c879050000036c", 
        "ansible_memfree_mb": 25, 
        "ansible_memory_mb": {
            "nocache": {
                "free": 376, 
                "used": 120
            }, 
            "real": {
                "free": 25, 
                "total": 496, 
                "used": 471
            }, 
            "swap": {
                "cached": 0, 
                "free": 727, 
                "total": 727, 
                "used": 0
            }
        }, 
        "ansible_memtotal_mb": 1496, 
        "ansible_mounts": [
            {
                "device": "/dev/mapper/debian-root", 
                "fstype": "ext3", 
                "mount": "/", 
                "options": "rw,errors=remount-ro", 
                "size_available": 189026240512, 
                "size_total": 304680742912, 
                "uuid": "NA"
            }, 
            {
                "device": "/dev/sda1", 
                "fstype": "ext2", 
                "mount": "/boot", 
                "options": "rw", 
                "size_available": 209807360, 
                "size_total": 238787584, 
                "uuid": "NA"
            }, 
            {
                "device": "//share/Prüfhinweise", 
                "fstype": "cifs", 
                "mount": "/media", 
                "options": "rw", 
                "size_available": 349807360, 
                "size_total": 428787584, 
                "uuid": "NA"
            }
        ], 
        "ansible_nodename": "dev.local", 
        "ansible_os_family": "Debian", 
        "ansible_pkg_mgr": "apt", 
        "ansible_processor": [
            "GenuineIntel", 
            "Intel(R) Core(TM) i7-4712HQ CPU @ 2.30GHz"
        ], 
        "ansible_processor_cores": 1, 
        "ansible_processor_count": 1, 
        "ansible_processor_threads_per_core": 1, 
        "ansible_processor_vcpus": 1, 
        "ansible_product_name": "VirtualBox", 
        "ansible_product_serial": "NA", 
        "ansible_product_uuid": "NA", 
        "ansible_product_version": "1.2", 
        "ansible_python_version": "2.6.6", 
        "ansible_selinux": false, 
        "ansible_ssh_host_key_dsa_public": "AAAAB3NzaC1kc3MAAACBAOJWOpQVltXw3wNsRq20+r37aOHiD11hNvNttywbVkNPLo+s7Q0Y0lctaOWl9WR4b3EK55t+a7/sCqS7Qy5CGwtMmsg3ayUUNZLSwwAkAZ2UISyYRbb3AJwMb3HqBXu6P/lm5GRDEycU+bQUUdVOsBe6kwMEKUdBtsa++ipCCCcNAAAAFQCUI0c8CwmSvtwcuj7JTjEJnhBKiQAAAIEA4Mhgav6N18adoQ6xvgHNVrdf/ilNOv1tFUpL2pFlH21zrONj19/hT/HSyj7CeDV0Hpfwg1gGYI12TNgf+9NDOfz2ceXef6QVfG1Nf8j7HAp9KoSU50MCM9la3oTUnN4AwwPGp8ItuHwzmGubt1UaVaBPpeeNrMCWqewHF8bgZmAAAACAB68uE+BWPsGpKqdXeaohvinF296nWc0urbXQ6yPVaATT96UP+vT2QToZY+4Zkcs6l3gL0kS7s8Y/50AxbvO1yKFhIqBnH/p4tV21jdTnXL066bbU60f5tjC5/ty+zYQREKAm3XiLxOSRyyC0M34bFVIqCtZ5tMax2xtaRndDlys=", 
        "ansible_ssh_host_key_rsa_public": "AAAAB3NzaC1yc2EAAAADAQABAAABAQDFwue0q1kD5CgZczAKg10/DFyKWgxoSK1J/r/Tk9PqvckNjwVx7Yn78rElXgo4SCMceWPIucb8Yl8FpmdnuXH8/yn5i+snOpBQddoFun/CiB3HUw28T2M7Y9q4QtEcMiULBq1oiCoYJfNU9o3aD2caxk8OhcrF5k7Ec5DIyAGN8doYxey6icl6ohUJR6x6jnZO+6uoSKyHwxS3HBZ+6RrVY7ckCuRk/w24P7YM5sEnHZ9dnS4uTVCYKrJpygYUbN/HrSNuIIAQpvitZWua6t7mFy1zugCc0Lj8QbPStnsntIVWoIwWY+iFnFrS6N3IiGHAyOv6Jla0P3HEFmrhoVIH", 
        "ansible_swapfree_mb": 727, 
        "ansible_swaptotal_mb": 727, 
        "ansible_system": "Linux", 
        "ansible_system_vendor": "innotek GmbH", 
        "ansible_user_dir": "/home/fboender", 
        "ansible_user_gecos": "fboender,,,", 
        "ansible_user_gid": 1000, 
        "ansible_user_id": "fboender", 
        "ansible_user_shell": "/bin/bash", 
        "ansible_user_uid": 1000, 
        "ansible_userspace_architecture": "x86_64", 
        "ansible_userspace_bits": "64", 
        "ansible_virtualization_role": "guest", 
        "ansible_virtualization_type": "virtualbox", 
        "module_setup": true
    }, 
    "changed": false
}
