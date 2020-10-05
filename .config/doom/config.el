;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

(setq fancy-splash-image "~/.config/doom/black-hole.png")

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Anurup Dey"
      user-mail-address "anu.rup.dey98@gmail.com")

(set-email-account! "gmail-personal"
                    '((mu4e-sent-folder       . "/gmail-personal/Sent Mail")
                      (mu4e-drafts-folder     . "/gmail-personal/Drafts")
                      (mu4e-trash-folder      . "/gmail-personal/Trash")
                      (mu4e-refile-folder     . "/gmail-personal/All Mail")
                      (smtpmail-smtp-user     . "anu.rup.dey98@gmail.com")
                      (mu4e-compose-signature . "---\nAnurup Dey"))
                    t)

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "monospace" :width 'condensed :size 13 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

(custom-set-faces
 '(default ((t (:background "#121212"))))
 '(hl-line ((t (:background "#000000"))))
 )

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/"
      org-hide-emphasis-markers t)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)

;; Switch to the new window after splitting
(setq evil-split-window-below t
      evil-vsplit-window-right t)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(use-package! dap-cpptools
  :hook ((c-mode c++-mode objc-mode cuda-mode) .
         (lambda () (require 'dap-cpptools) (lsp)))
  :config
  (add-hook! 'dap-stopped-hook
    (lambda (_) (call-interactively #'dap-hydra)))
  (setq dap-auto-configure-features '(sessions locals tooltip))
  (setq gc-cons-threshold (* 100 1024 1024)
        read-process-output-max (* 1024 1024)
        treemacs-space-between-root-nodes nil
        company-idle-delay 0.0
        company-minimum-prefix-length 1)
  (map! :leader
        :desc "Toggle Breakpoint"
        "c b" #'dap-breakpoint-toggle))

(load! "colorful-points.el")
