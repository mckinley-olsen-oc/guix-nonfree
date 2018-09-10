;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2012, 2013, 2014, 2015, 2017, 2018 Ludovic Courtès <ludo@gnu.org>
;;; Copyright © 2013, 2014 Andreas Enge <andreas@enge.fr>
;;; Copyright © 2012 Nikita Karetnikov <nikita@karetnikov.org>
;;; Copyright © 2014, 2015 Mark H Weaver <mhw@netris.org>
;;; Copyright © 2015 Federico Beffa <beffa@fbengineering.ch>
;;; Copyright © 2015 Taylan Ulrich Bayırlı/Kammer <taylanbayirli@gmail.com>
;;; Copyright © 2015, 2017 Andy Wingo <wingo@igalia.com>
;;; Copyright © 2018 Joe Hillenbrand <joehillen@gmail.com>
;;;
;;; This file is part of GNU Guix.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (gnu packages linux-firmware-nonfree)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages tls)
  #:use-module (guix build-system trivial)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix download))

;;; Forgive me Stallman for I have sinned.

(define-public linux-firmware-nonfree
  (package
    (name "linux-firmware-nonfree")
    (version "85c5d90fc155d78531efa5d2b02e92aaef7e4b88")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git")
                    (commit version)))
              (sha256
               (base32
                "1anr7fblxfcrfrrgq98kzy64yrwygc2wdgi47skdmjxhi3wbrvxz"))))
    (build-system trivial-build-system)
    (arguments
     `(#:modules ((guix build utils))
       #:builder (begin
                   (use-modules (guix build utils))
                   (let ((source (assoc-ref %build-inputs "source"))
                         (fw-dir (string-append %output "/lib/firmware/")))
                     (mkdir-p fw-dir)
                     (copy-recursively source fw-dir)
                     #t))))

    (home-page "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/about/")
    (synopsis "Non-free firmware for Linux")
    (description "Non-free firmware for Linux"))
    (lincense (license:non-copyleft "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/WHENCE")))

(define-public radeon-firmware-nonfree
  (package
    (inherit linux-firmware-nonfree)
    (name "radeon-firmware-nonfree")
    (arguments
     `(#:modules ((guix build utils))
       #:builder (begin
                   (use-modules (guix build utils))
                   (let ((source (assoc-ref %build-inputs "source"))
                         (fw-dir (string-append %output "/lib/firmware/radeon/")))
                     (mkdir-p fw-dir)
                     (for-each (lambda (file)
                                 (copy-file file
                                            (string-append fw-dir "/"
                                                           (basename file))))
                               (find-files source
                                           (lambda (file stat)
                                             (string-contains file "radeon"))))
                     #t))))
    (synopsis "Non-free firmware for Radeon integrated chips")
    (description "Non-free firmware for Radeon integrated chips")
    (license (license:non-copyleft "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/LICENSE.radeon"))))

(define-public ath10k-firmware-nonfree
  (package
    (inherit linux-firmware-nonfree)
    (name "ath10k-firmware-nonfree")
    (arguments
     `(#:modules ((guix build utils))
       #:builder (begin
                   (use-modules (guix build utils))
                   (let ((source (assoc-ref %build-inputs "source"))
                         (fw-dir (string-append %output "/lib/firmware/")))
                     (mkdir-p fw-dir)
                     (copy-recursively (string-append source "/ath10k")
                                       (string-append fw-dir "/ath10k"))
                     #t))))
    (synopsis "Non-free firmware for Qualcom Atheros wireless chips")
    (description "Non-free firmware for Qualcom Atheros wireless chips")
    (license (license:non-copyleft "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/LICENSE.QualcommAtheros_ath10k"))))

(define-public iwlwifi-firmware-nonfree
  (package
    (inherit linux-firmware-nonfree)
    (name "iwlwifi-firmware-nonfree")
    (arguments
     `(#:modules ((guix build utils))
       #:builder (begin
                   (use-modules (guix build utils))
                   (let ((source (assoc-ref %build-inputs "source"))
                         (fw-dir (string-append %output "/lib/firmware")))
                     (mkdir-p fw-dir)
                     (for-each (lambda (file)
                                 (copy-file file
                                            (string-append fw-dir "/"
                                                           (basename file))))
                               (find-files source "iwlwifi-.*\\.ucode$|LICENCE\\.iwlwifi_firmware$"))
                     #t))))
    (home-page "https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi")
    (synopsis "Non-free firmware for Intel wifi chips")
    (description "Non-free firmware for Intel wifi chips")
    (license (license:non-copyleft "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/LICENCE.iwlwifi_firmware"))))

(define-public ibt-hw-firmware-nonfree
  (package
    (inherit linux-firmware-nonfree)
    (name "ibt-hw-firmware-nonfree")
    (arguments
     `(#:modules ((guix build utils))
       #:builder (begin
                   (use-modules (guix build utils))
                   (let ((source (assoc-ref %build-inputs "source"))
                         (fw-dir (string-append %output "/lib/firmware/intel")))
                     (mkdir-p fw-dir)
                     (for-each (lambda (file)
                                 (copy-file file
                                            (string-append fw-dir "/"
                                                           (basename file))))
                               (find-files source "ibt-hw-.*\\.bseq$|LICENCE\\.ibt_firmware$"))
                     #t))))
    (home-page "http://www.intel.com/support/wireless/wlan/sb/CS-016675.htm")
    (synopsis "Non-free firmware for Intel bluetooth chips")
    (description "Non-free firmware for Intel bluetooth chips")
    (license (license:non-copyleft "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/LICENCE.ibt_firmware"))))
