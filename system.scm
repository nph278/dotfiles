;; -*- mode: scheme; -*-
;; Guix system configuration

(use-modules (gnu)
	     (gnu system nss)
	     (guix utils)
	     (gnu packages vim)
	     (nongnu packages linux)
	     (nongnu system linux-initrd))
(use-service-modules desktop sddm xorg)
(use-package-modules certs gnome)

(operating-system
  (host-name "tp01")
  (timezone "America/New_York")
  (locale "en_US.utf8")
  (keyboard-layout (keyboard-layout "us"))

  ;; Kernel and initrd
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))

  ;; Use the UEFI variant of GRUB with the EFI System
  (bootloader (bootloader-configuration
               (bootloader grub-efi-bootloader)
               (targets '("/boot/efi"))
               (keyboard-layout keyboard-layout)))

  ;; LUKS partitions
  (mapped-devices
   (list (mapped-device
          (source (uuid "18f722e5-b551-4429-b242-17fe5d127d1c"))
          (target "btrfs")
          (type luks-device-mapping))))

  (file-systems (append
                 (list
		       ;; Root
		       (file-system
                         (device "/dev/mapper/btrfs")
                         (mount-point "/")
                         (type "btrfs")
			 (options "subvol=@root,compress=zstd")
                         (dependencies mapped-devices))
		       ;; Home
                       (file-system
                         (device "/dev/mapper/btrfs")
                         (mount-point "/home")
                         (type "btrfs")
			 (options "subvol=@home,compress=zstd")
                         (dependencies mapped-devices))
		       ;; GNU Store
                       (file-system
                         (device "/dev/mapper/btrfs")
                         (mount-point "/gnu/store")
                         (type "btrfs")
			 (options "subvol=@store,compress=zstd,noatime")
                         (dependencies mapped-devices))
		       ;; EFI
                       (file-system
                         (device (uuid "A1FD-E34F" 'fat))
                         (mount-point "/boot/efi")
                         (type "vfat")))
                 %base-file-systems))

  ;; Specify a swap file for the system, which resides on the
  ;; root file system.
  ;; (swap-devices (list (swap-space
  ;;                      (target "/swapfile"))))

  (users (cons (user-account
                (name "carl")
                (group "wheel")
                (supplementary-groups (list "netdev" "audio" "video")))
               %base-user-accounts))

  (groups %base-groups)

  ;; System-wide packages
  (packages (append (list
                     ;; for HTTPS access
                     nss-certs
                     ;; for user mounts
                     gvfs
		     ;; for text editing
		     vim)
                    %base-packages))

  ;; System-wide services
  (services (append (list)
                    %base-services))

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))
